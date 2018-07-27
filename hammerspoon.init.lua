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

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "l", function()
  moveFocusedWindowToSpaceAndFocusNextWindow(getAdjacentSpace())
end)

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "h", function()
  moveFocusedWindowToSpaceAndFocusNextWindow(getAdjacentSpace(true))
end)

function bindIndex(keyIndex)
  hs.hotkey.bind({ "alt", "ctrl", "shift" }, tostring(keyIndex), function()
    moveFocusedWindowToSpaceAndFocusNextWindow(getSpaceAtIndex(keyIndex))
  end)

  hs.hotkey.bind({ "cmd", "ctrl", "shift" }, tostring(keyIndex), function()
    navigateToSpace(getSpaceAtIndex(keyIndex))
  end)
end

for i = 1, 8 do
  bindIndex(i)
end

hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "l", function()
  navigateToSpace(getAdjacentSpace())
end)

hs.hotkey.bind({ "cmd", "ctrl", "shift" }, "h", function()
  navigateToSpace(getAdjacentSpace(true))
end)

function moveFocusedWindowToSpaceAndFocusNextWindow(space)
  local prevSpace = spaces.activeSpace()
  local window = hs.window.focusedWindow()

  window:spacesMoveTo(space)

  local targetScreenUUID = spaces.spaceScreenUUID(space)
  local screen = getScreenFromUUID(targetScreenUUID)
  if (window:screen() ~= screen) then
    window:moveToScreen(screen)
    window:moveToUnit(hs.layout.maximized)
  end

  local win = spaces.allWindowsForSpace(prevSpace)[1]
  if win ~= nil then
    win:focus()
  end
end

function navigateToSpace(space)
  spaces.changeToSpace(space)
end

function getAvailableSpaces()
  local availableSpaces = {}
  local allScreens = hs.screen.allScreens()
  local spacesByScreen = spaces.layout()

  for i = 1, #allScreens do
    local screenSpacesUUID = allScreens[i]:spacesUUID()
    local spacesForScreen = spacesByScreen[screenSpacesUUID]

    for j = 1, #spacesForScreen do
      table.insert(availableSpaces, spacesForScreen[j])
    end
  end

  return availableSpaces
end

function getSpaceAtIndex(inputIndex)
  -- skip first space since it's used by mac
  local index = inputIndex + 1

  local availableSpaces = getAvailableSpaces()
  if index > #availableSpaces then
    return availableSpaces[#availableSpaces]
  else
    return availableSpaces[index]
  end
end

function getAdjacentSpace(backwards)
  local space = spaces.activeSpace()
  local availableSpaces = getAvailableSpaces()

  local startIndex
  local endIndex
  local iterator

  -- skip first space since it's used by mac
  if backwards then
    startIndex = #availableSpaces
    endIndex = 2
    iterator = -1
  else
    startIndex = 2
    endIndex = #availableSpaces
    iterator = 1
  end

  local hasFoundSpace = false

  for spaceIndex = startIndex, endIndex, iterator do
    local currentSpace = availableSpaces[spaceIndex]

     if hasFoundSpace then
       return currentSpace
     elseif currentSpace == space then
       hasFoundSpace = true
     end
   end

   return availableSpaces[startIndex]
end

local spaceKeys = { "u", "i", "o", "p", "n", "m", ",", "." }

local keyToSingleScreenSpaceMap = {}
keyToSingleScreenSpaceMap["u"] = 2
keyToSingleScreenSpaceMap["i"] = 3
keyToSingleScreenSpaceMap["o"] = 4
keyToSingleScreenSpaceMap["p"] = 5
keyToSingleScreenSpaceMap["n"] = 1
keyToSingleScreenSpaceMap["m"] = 6
keyToSingleScreenSpaceMap[","] = 7
keyToSingleScreenSpaceMap["."] = 8

local keyToMultiScreenSpaceMap = {}
keyToMultiScreenSpaceMap["u"] = 2
keyToMultiScreenSpaceMap["i"] = 3
keyToMultiScreenSpaceMap["o"] = 4
keyToMultiScreenSpaceMap["p"] = 5
keyToMultiScreenSpaceMap["n"] = 6
keyToMultiScreenSpaceMap["m"] = 7
keyToMultiScreenSpaceMap[","] = 8
keyToMultiScreenSpaceMap["."] = 9

function isMultiScreen()
   return #hs.screen.allScreens() > 1
end

function getSpaceFromNavKey(navKey)
    local availableSpaces = getAvailableSpaces()
    local map = isMultiScreen() and keyToMultiScreenSpaceMap or keyToSingleScreenSpaceMap
    return availableSpaces[map[navKey]]
end

function getScreenFromUUID(screenUUID)
   local allScreens = hs.screen.allScreens()
   for i = 1, #allScreens do
      local screen = allScreens[i]
      if screen:spacesUUID() == screenUUID then
         return screen
      end
   end
end

function bindSpaceNavKey(i)
   hs.hotkey.bind({ "cmd", "ctrl" }, spaceKeys[i], function()
      local targetSpace = getSpaceFromNavKey(spaceKeys[i])
      local targetScreenUUID = spaces.spaceScreenUUID(targetSpace)

      local focusTargetWindow

      if targetScreenUUID ~= spaces.spaceScreenUUID(spaces.activeSpace()) then
         local screen = getScreenFromUUID(targetScreenUUID)

         if screen == nil then
            print("ERROR: no matching screen found for", spaceKeys[i], targetSpace, targetScreenUUID)
            return
         end

         local windows = hs.window.filter.default:getWindows()

         for i = 1, #windows do
            local window = windows[i]
            if window:screen() == screen then
               local spaces = window:spaces()
               for j = 1, #spaces do
                  if spaces[j] == targetSpace then
                     focusTargetWindow = window
                     break
                  end
               end
            end
         end

         if focusTargetWindow ~= nil then
            focusTargetWindow:focus()
         end

         if spaces.activeSpace() == targetSpace then
            return
         end
      end

      navigateToSpace(getSpaceFromNavKey(spaceKeys[i]))

      forceRefocusToFightChromeNavigation(focusTargetWindow)
   end)

   hs.hotkey.bind({ "alt", "ctrl" }, spaceKeys[i], function()
      moveFocusedWindowToSpaceAndFocusNextWindow(getSpaceFromNavKey(spaceKeys[i]))
   end)
end

function forceRefocusToFightChromeNavigation(focusTargetWindow)
   hs.timer.doAfter(.005, function()
      if focusTargetWindow ~= nil and focusTargetWindow ~= hs.window.focusedWindow() then
         focusTargetWindow:focus()
      end
   end)
end

for i = 1, #spaceKeys do
   bindSpaceNavKey(i)
end
