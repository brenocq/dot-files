-- Cmd+drag tiling for AeroSpace, as i3's $mod+drag: hold Cmd, press anywhere
-- in a window, drag it over another tiled window and release. The window
-- lands against the edge of the target nearest the pointer, taking that half
-- of the target's slot; a translucent box shows where while dragging.
--
-- The event tap only records points and moves the overlay. Window lookups run
-- from timers and the AeroSpace work runs as a background task with a kill
-- timer, so a hung app or a hung AeroSpace can cancel a drop but never stall
-- mouse input. A Cmd+click that does not move is replayed to the app, so
-- Cmd+click on links and in Finder keeps working.

local M = {}

local types = hs.eventtap.event.types
local props = hs.eventtap.event.properties

-- Marks events this module posts, so its own tap lets them through.
local REPLAY_MARK = 0x41455244
-- Pixels the pointer moves before a press counts as a drag.
local DRAG_THRESHOLD = 6
-- Seconds the drop script may run before it is killed.
local DROP_TIMEOUT = 5
local DROP_SCRIPT = os.getenv("HOME") .. "/.local/bin/aerospace-drop"

-- Pure geometry, exported for tests. Rects and points use screen coordinates
-- with the origin at the top left, as hs.window and hs.eventtap do.

-- Returns the edge of `rect` whose triangle (cut by the diagonals) holds
-- `point`: "left", "right", "up" or "down".
function M.edgeFor(rect, point)
  local dx = (point.x - (rect.x + rect.w / 2)) / rect.w
  local dy = (point.y - (rect.y + rect.h / 2)) / rect.h
  if math.abs(dx) >= math.abs(dy) then
    return dx < 0 and "left" or "right"
  end
  return dy < 0 and "up" or "down"
end

-- Returns the half of `rect` that a window dropped on `edge` occupies.
function M.zoneFor(rect, edge)
  if edge == "left" then
    return { x = rect.x, y = rect.y, w = rect.w / 2, h = rect.h }
  elseif edge == "right" then
    return { x = rect.x + rect.w / 2, y = rect.y, w = rect.w / 2, h = rect.h }
  elseif edge == "up" then
    return { x = rect.x, y = rect.y, w = rect.w, h = rect.h / 2 }
  end
  return { x = rect.x, y = rect.y + rect.h / 2, w = rect.w, h = rect.h / 2 }
end

local function contains(rect, point)
  return point.x >= rect.x and point.x < rect.x + rect.w
    and point.y >= rect.y and point.y < rect.y + rect.h
end

-- Returns the first window in `snapshot` (front to back, each {id, frame})
-- under `point`, skipping `excludeId` and windows whose center is on no
-- screen in `screens`: AeroSpace parks windows of hidden workspaces almost
-- entirely off screen, and their visible sliver is not a drop target.
function M.windowAt(snapshot, point, excludeId, screens)
  for _, win in ipairs(snapshot) do
    if win.id ~= excludeId and contains(win.frame, point) then
      local center = { x = win.frame.x + win.frame.w / 2, y = win.frame.y + win.frame.h / 2 }
      for _, screen in ipairs(screens) do
        if contains(screen, center) then
          return win
        end
      end
    end
  end
  return nil
end

-- Drag state, reset on every release.
local state = nil
local overlay = nil
local tap = nil
local watchdog = nil
local dropTask = nil

local function hideOverlay()
  if overlay then
    overlay:hide()
  end
end

local function showOverlay(rect)
  if not overlay then
    overlay = hs.canvas.new(rect)
    overlay:level(hs.canvas.windowLevels.overlay)
    overlay:behavior({ "canJoinAllSpaces", "transient" })
    overlay[1] = {
      type = "rectangle",
      action = "strokeAndFill",
      fillColor = { red = 0.36, green = 0.72, blue = 0.96, alpha = 0.25 },
      strokeColor = { red = 0.36, green = 0.72, blue = 0.96, alpha = 0.9 },
      strokeWidth = 3,
      roundedRectRadii = { xRadius = 6, yRadius = 6 },
    }
  end
  overlay:frame(rect)
  overlay:show()
end

local function screenFrames()
  local frames = {}
  for _, screen in ipairs(hs.screen.allScreens()) do
    local f = screen:fullFrame()
    table.insert(frames, { x = f.x, y = f.y, w = f.w, h = f.h })
  end
  return frames
end

-- Reads every visible standard window, front to back. Runs from a timer,
-- never inside the tap callback, because it talks to apps over AX.
local function takeSnapshot(s)
  local snapshot = {}
  for _, win in ipairs(hs.window.orderedWindows()) do
    if win:isStandard() then
      local f = win:frame()
      table.insert(snapshot, { id = win:id(), frame = { x = f.x, y = f.y, w = f.w, h = f.h } })
    end
  end
  s.snapshot = snapshot
  s.screens = screenFrames()
  local moved = M.windowAt(snapshot, s.downPoint, nil, s.screens)
  s.movedId = moved and moved.id or nil
end

local function updateTarget(s)
  if not s.snapshot or not s.movedId then
    return
  end
  local target = M.windowAt(s.snapshot, s.lastPoint, s.movedId, s.screens)
  if target then
    s.targetId = target.id
    s.edge = M.edgeFor(target.frame, s.lastPoint)
    showOverlay(M.zoneFor(target.frame, s.edge))
  else
    s.targetId = nil
    s.edge = nil
    hideOverlay()
  end
end

local function runDrop(movedId, targetId, edge)
  if dropTask and dropTask:isRunning() then
    return
  end
  dropTask = hs.task.new(DROP_SCRIPT, function(code, _, stderr)
    if code ~= 0 then
      print(string.format("aerospace-drop exited %d: %s", code, stderr or ""))
    end
  end, { tostring(movedId), tostring(targetId), edge })
  dropTask:start()
  local started = dropTask
  hs.timer.doAfter(DROP_TIMEOUT, function()
    if started:isRunning() then
      started:terminate()
    end
  end)
end

-- Gives a press that never became a drag back to the app as a normal click.
local function replayClick(s)
  local down = s.downEvent
  down:setProperty(props.eventSourceUserData, REPLAY_MARK)
  local up = hs.eventtap.event.newMouseEvent(types.leftMouseUp, s.downPoint, { "cmd" })
  up:setProperty(props.mouseEventClickState, down:getProperty(props.mouseEventClickState))
  up:setProperty(props.eventSourceUserData, REPLAY_MARK)
  down:post()
  up:post()
end

local function onlyCmd(flags)
  return flags.cmd and not (flags.alt or flags.ctrl or flags.shift)
end

local function handle(event)
  if event:getProperty(props.eventSourceUserData) == REPLAY_MARK then
    return false
  end
  local kind = event:getType()

  if kind == types.leftMouseDown then
    if not onlyCmd(event:getFlags()) then
      return false
    end
    local p = event:location()
    state = { downPoint = { x = p.x, y = p.y }, lastPoint = { x = p.x, y = p.y }, downEvent = event:copy() }
    return true
  end

  local s = state
  if not s then
    return false
  end

  if kind == types.leftMouseDragged then
    local p = event:location()
    s.lastPoint = { x = p.x, y = p.y }
    if not s.dragging then
      local dx, dy = p.x - s.downPoint.x, p.y - s.downPoint.y
      if dx * dx + dy * dy < DRAG_THRESHOLD * DRAG_THRESHOLD then
        return true
      end
      s.dragging = true
      hs.timer.doAfter(0, function()
        if state == s then
          takeSnapshot(s)
          updateTarget(s)
        end
      end)
      return true
    end
    updateTarget(s)
    return true
  end

  if kind == types.leftMouseUp then
    state = nil
    hideOverlay()
    if not s.dragging then
      hs.timer.doAfter(0, function()
        replayClick(s)
      end)
      return true
    end
    local p = event:location()
    s.lastPoint = { x = p.x, y = p.y }
    hs.timer.doAfter(0, function()
      if not s.snapshot then
        takeSnapshot(s)
      end
      updateTarget(s)
      hideOverlay()
      if s.movedId and s.targetId and s.edge then
        runDrop(s.movedId, s.targetId, s.edge)
      end
    end)
    return true
  end

  return false
end

-- Reports whether the tap is running and whether Hammerspoon holds the
-- Accessibility permission the tap needs.
function M.status()
  return string.format("accessibility=%s tap=%s",
    tostring(hs.accessibilityState()), tostring(tap ~= nil and tap:isEnabled()))
end

function M.start()
  -- Bound every AX call, so an app that stops answering costs half a second
  -- instead of the default several.
  hs.window.timeout(0.5)
  tap = hs.eventtap.new({ types.leftMouseDown, types.leftMouseDragged, types.leftMouseUp }, handle)
  tap:start()
  -- macOS switches off a tap whose callback was too slow; switch it back on.
  watchdog = hs.timer.doEvery(5, function()
    if not tap:isEnabled() then
      state = nil
      hideOverlay()
      tap:start()
    end
  end)
end

return M
