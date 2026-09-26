-- Hyprland configuration.
--
-- Hyprland 0.55+ deprecated the hyprlang `.conf` format in favour of Lua
-- (removal is scheduled for 0.57). API reference:
--   /usr/share/hypr/stubs/hl.meta.lua and https://wiki.hypr.land/Configuring/Start/

-------------------------------------------------------------------------------
-- Colors (gruvbox)
-------------------------------------------------------------------------------
local c = {
    bg       = "rgba(282828ff)",
    bg1      = "rgba(3c3836ff)",
    bg2      = "rgba(504945ff)",
    red      = "rgba(cc241dff)",
    green    = "rgba(98971aff)",
    yellow   = "rgba(d79921ff)",
    blue     = "rgba(458588ff)",
    aqua     = "rgba(689d68ff)",
    purple   = "rgba(b16286ff)",
    gray     = "rgba(a89984ff)",
    darkgray = "rgba(1d2021ff)",
    white    = "rgba(ebdbb2ff)",
}

-------------------------------------------------------------------------------
-- Monitors
-------------------------------------------------------------------------------
-- Fallback for any monitor not configured explicitly below.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- The machine-specific layout lives in ~/.config/hypr/monitors.conf, written by
-- nwg-displays and kept out of git. nwg-displays still emits the old hyprlang
-- syntax (one `monitor=<output>,<mode>,<position>,<scale>` line per monitor),
-- so translate it here. A missing file is simply skipped.
local function load_monitors_conf(path)
    local f = io.open(path, "r")
    if not f then return end
    for line in f:lines() do
        local spec = line:match("^%s*monitor%s*=%s*(.-)%s*$")
        if spec and spec ~= "" then
            local output, mode, position, scale = spec:match("^([^,]*),([^,]*),([^,]*),([^,]*)$")
            if output then
                hl.monitor({
                    output   = output,
                    mode     = mode,
                    position = position,
                    scale    = tonumber(scale) or scale,
                })
            end
        end
    end
    f:close()
end
load_monitors_conf(os.getenv("HOME") .. "/.config/hypr/monitors.conf")

-------------------------------------------------------------------------------
-- Programs
-------------------------------------------------------------------------------
local terminal    = "kitty"
local fileManager = "kitty -d ~ yazi"
local menu        = "wofi --show drun"

-------------------------------------------------------------------------------
-- Autostart (runs once, at startup)
-------------------------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("waybar & mako")
    hl.exec_cmd("hyprpaper -c ~/.config/hypr/hyprpaper.conf")
    -- Picks a random wallpaper over IPC once hyprpaper answers; see the script.
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper.sh")
    hl.exec_cmd("xhost +local:docker")
end)

-------------------------------------------------------------------------------
-- Environment variables
-------------------------------------------------------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-------------------------------------------------------------------------------
-- Look and feel
-------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,

        col = {
            active_border   = { colors = { c.green, c.yellow }, angle = 45 },
            inactive_border = c.gray,
        },

        resize_on_border = false,
        allow_tearing    = false, -- see the Tearing wiki page before enabling
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        -- Focused and unfocused windows are both fully opaque.
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = c.darkgray,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },

    -- Pseudotiling has no config switch since 0.55; it is toggled per window
    -- through the `pseudo` dispatcher.
    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,    -- 0 or 1 disables the anime mascot wallpapers
        disable_hyprland_logo   = false,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 to 1.0, 0 means no modification

        touchpad = { natural_scroll = false },
    },
})

-------------------------------------------------------------------------------
-- Animations
-------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

-- speed is in deciseconds (1 = 100 ms)
hl.animation({ leaf = "global",        enabled = true, speed = 1,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 1,   bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 1,   bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 1,   bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1,   bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1,   bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 1,   bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 1,   bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 1,   bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1,   bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1,   bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 0.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 0.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,   bezier = "quick" })

-------------------------------------------------------------------------------
-- Input devices and gestures
-------------------------------------------------------------------------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Example per-device config, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Binds/ and .../Dispatchers/
local mainMod = "SUPER"
local function M(keys) return mainMod .. " + " .. keys end

hl.bind(M("RETURN"), hl.dsp.exec_cmd(terminal))
hl.bind(M("Q"),      hl.dsp.window.close())
hl.bind(M("DELETE"), hl.dsp.exit())
hl.bind(M("E"),      hl.dsp.exec_cmd(fileManager))
hl.bind(M("SPACE"),  hl.dsp.window.float({ action = "toggle" }))
hl.bind(M("D"),      hl.dsp.exec_cmd(menu))
hl.bind(M("ESCAPE"), hl.dsp.exec_cmd("hyprlock"))
hl.bind(M("R"),      hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(M("F"),      hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(M("S"),      hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(M("G"),      hl.dsp.exec_cmd("kooha"))

-- Move focus / move window with mainMod [+ SHIFT] + hjkl
for key, dir in pairs({ H = "left", L = "right", K = "up", J = "down" }) do
    hl.bind(M(key),               hl.dsp.focus({ direction = dir }))
    hl.bind(M("SHIFT + " .. key), hl.dsp.window.move({ direction = dir }))
end

-- Switch workspaces with mainMod + [0-9], move the active window with SHIFT.
-- 0 is a named workspace: named workspaces get negative ids, so waybar (which
-- sorts by id) lists it before 1, matching a keyboard whose 0 sits left of 1.
for key = 0, 9 do
    local ws = key == 0 and "name:0" or key
    hl.bind(M(tostring(key)),     hl.dsp.focus({ workspace = ws }))
    hl.bind(M("SHIFT + " .. key), hl.dsp.window.move({ workspace = ws, follow = true }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(M("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(M("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(M("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(M("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys: work while locked, and repeat when held
local lr = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), lr)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      lr)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     lr)
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   lr)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  lr)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  lr)

-- Requires playerctl; works while locked
local l = { locked = true }
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       l)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), l)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), l)
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   l)

-------------------------------------------------------------------------------
-- Window rules
-------------------------------------------------------------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Ignore maximize requests from apps.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland.
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
