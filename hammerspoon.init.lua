hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

spaces = require("hs._asm.undocumented.spaces")

hs.window.animationDuration = 0

hs.hotkey.bind({ "alt", "ctrl" }, "h", function()
  local win = hs.window.focusedWindow()
  win:moveToUnit(hs.layout.left50)
end)

hs.hotkey.bind({ "alt", "ctrl" }, "l", function()
  local win = hs.window.focusedWindow()
  win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind({ "alt", "ctrl" }, "j", function()
  local win = hs.window.focusedWindow()
  local frame = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local halfMaxHeight = max.h / 2

  frame.h = halfMaxHeight
  frame.y = max.y + halfMaxHeight
  win:setFrame(frame)
end)

hs.hotkey.bind({ "alt", "ctrl" }, "k", function()
  local win = hs.window.focusedWindow()
  local frame = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local halfMaxHeight = max.h / 2

  frame.h = halfMaxHeight
  frame.y = max.y
  win:setFrame(frame)
end)

hs.hotkey.bind({ "alt", "ctrl" }, "1", function()
  local screen = hs.screen.allScreens()[1]
  local win = hs.window.focusedWindow()
  win:moveToScreen(screen)
  win:moveToUnit(hs.layout.maximized)
end)

hs.hotkey.bind({ "alt", "ctrl" }, "2", function()
  local screen = hs.screen.allScreens()[2]
  local win = hs.window.focusedWindow()
  win:moveToScreen(screen)
  win:moveToUnit(hs.layout.maximized)
end)

hs.hotkey.bind({ "alt", "ctrl" }, "3", function()
  local screen = hs.screen.allScreens()[3]
  local win = hs.window.focusedWindow()
  win:moveToScreen(screen)
  win:moveToUnit(hs.layout.maximized)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "h", function()
   navigate(hs.window.filter.defaultCurrentSpace:windowsToWest(nil, true, true))
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
   navigate(hs.window.filter.defaultCurrentSpace:windowsToEast(nil, true, true))
end)

function navigate(candidateWindows)
  local win = hs.window.focusedWindow()
  local closestWindow = candidateWindows[1]
  if not closestWindow then
    return
  end

  local closestApplication = closestWindow:application()

  if closestApplication == win:application() then
    closestWindow:focus()
    closestWindow:focus()
  else
    closestWindow:application():activate()
    closestWindow:focus()
    closestWindow:focus()

    if closestWindow:screen() ~= win:screen() then
      win:raise()
    end
  end
end

hs.hotkey.bind({ "cmd", "ctrl" }, "k", function()
  local win = hs.window.focusedWindow()
  win:focusWindowNorth(nil, true, false)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
  local win = hs.window.focusedWindow()
  win:focusWindowSouth(nil, true, false)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "q", function()
  local app = hs.application.frontmostApplication()
  app:hide()
end)

hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "k", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local orderedWindows = hs.window.orderedWindows()
  local hasFoundWindow = false

  for windowIndex = 1, #orderedWindows do
    local currentWin = orderedWindows[windowIndex]

    if hasFoundWindow then
      if currentWin:title() ~= "" and currentWin:screen() == screen then
        currentWin:application():activate()
        currentWin:focus()
        currentWin:focus()
        return
      end
    elseif currentWin == win then
      hasFoundWindow = true
    end
  end
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "s", function()
  spaces.changeToSpace(spaces.createSpace())
end)

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "l", function()
  hs.window.focusedWindow():spacesMoveTo(getAdjacentSpace())
end)

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "h", function()
  hs.window.focusedWindow():spacesMoveTo(getAdjacentSpace(true))
end)

hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "l", function()
   spaces.changeToSpace(getAdjacentSpace())
end)

hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "h", function()
   spaces.changeToSpace(getAdjacentSpace(true))
end)

function getAdjacentSpace(backwards)
  local space = spaces.activeSpace()
  local screenUUID = spaces.spaceScreenUUID(space)
  local spacesForScreen = spaces.layout()[screenUUID]

  local startIndex
  local endIndex
  local iterator

  if backwards then
    startIndex = #spacesForScreen
    endIndex = 1
    iterator = -1
  else
    startIndex = 1
    endIndex = #spacesForScreen
    iterator = 1
  end

  local hasFoundSpace = false

  for spaceIndex = startIndex, endIndex, iterator do
    local currentSpace = spacesForScreen[spaceIndex]

     if hasFoundSpace then
       return currentSpace
     elseif currentSpace == space then
       hasFoundSpace = true
     end
   end

   return spacesForScreen[startIndex]
end