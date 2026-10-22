-- Hammerspoon starts at login, without a Dock icon, and runs only the
-- AeroSpace Cmd+drag tiling module. hs.ipc stays off: it would let any local
-- program run code with Hammerspoon's Accessibility permission through the
-- `hs` command. Check the module from Hammerspoon's console instead:
-- require("aerospace_drag").status()
hs.autoLaunch(true)
hs.dockIcon(false)

require("aerospace_drag").start()
