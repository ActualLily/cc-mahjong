local core = require "cryspycore"
local ui = require "cryspyui"

ui.init(colors.pink)

local protocol = core.grabConfig()["PROTOCOL"]
local hostname = core.grabConfig()["NAME"]
local remotehost = core.grabConfig()["HOST"]

local width, height = term.getSize()
local isRunning = true
local isConnected = false

core.init(protocol, hostname)
core.verifyRemoteHost(remotehost)
local currentName = core.grabConfig()["NAME"]
local currentInterface = "MAINMENU"

-- NETWORK FUNCTIONS

function fetch()
  rednet.send(hostID, "FETCH", protocol)
  id, msg = rednet.receive(protocol, 5)

  return msg
end

function status(matchid)
  rednet.send(hostID, "STATUS/"..matchid.."/"..currentName, protocol)
  id, msg = rednet.receive(protocol, 5)

  return msg
end

-- MAIN MENU FUNCTIONS

local mainMenuPosition = 1

function renderMainMenu()
  local funnyBackgroundColor = "6"
  local funnyForegroundColor = "e"
  
  local titleASCII = {}

  if currentName == "CUTIE" or currentName == "FLOWER" or currentName == "DOROTHY" then
    term.setPaletteColour(colors.lime, 0xC2FFC9)
    funnyBackgroundColor = "5"
    funnyForegroundColor = "d"
    ui.renderMonochromeBackground(colors.lime)
    titleASCII[1]  = "           ,                           "
    titleASCII[2]  = "       /\\^/`\\                          "
    titleASCII[3]  = "      | \\/   |                         "
    titleASCII[4]  = "      | |    |                         "
    titleASCII[5]  = "      \\ \\    /                         "
    titleASCII[6]  = "       '\\\\//'                          "
    titleASCII[7]  = "         ||                            "
    titleASCII[8]  = "         ||                            "
    titleASCII[9]  = "         ||                            "
    titleASCII[10] = "         ||                            "
    titleASCII[11] = "         ||  ,                         "
    titleASCII[12] = "     |\\  ||  |\\      _____     _   _     __"
    titleASCII[13] = "     | | ||  | |    |     |_ _| |_|_|___|  |"
    titleASCII[14] = "     | | || / /     |   --| | |  _| | -_|__|"
    titleASCII[15] = "      \\ \\||/ /      |_____|___|_| |_|___|__|"
    titleASCII[16] = "       `\\\\//`                          "
    titleASCII[17] = "      ^^^^^^^^                         "
  else
    ui.renderMonochromeBackground(colors.pink)
    titleASCII[1]  = "         -###-                                      "
    titleASCII[2]  = "          ###                                       "
    titleASCII[3]  = "          ###                                       "
    titleASCII[4]  = "          ###                                       "
    titleASCII[5]  = ":.    .::=######*#**####:                           "
    titleASCII[6]  = "=###*=:   ###       ####:                           "
    titleASCII[7]  = " *#=      ###      -###                             "
    titleASCII[8]  = " -#*      ###      *##                              "
    titleASCII[9]  = " .#*      ### .::==##:                              "
    titleASCII[10] = "  #############******=                              "
    titleASCII[11] = "  .*      ###                                       "
    titleASCII[12] = "          ###      _____  _  _       _    _         "
    titleASCII[13] = "          ##*     | __  ||_||_| ___ | |_ |_|        "
    titleASCII[14] = "          ##*     |    -|| || ||  _||   || |        "
    titleASCII[15] = "          ##*     |__|__||_||_||___||_|_||_|        "
    titleASCII[16] = "          ##-                                       "
    titleASCII[17] = "          ##                                        "
  end
  
  for k, v in pairs(titleASCII) do
    ui.drawUI(v, funnyForegroundColor, funnyBackgroundColor, 2, 1 + k)
  end

  ui.drawUI("Welcome, "..currentName.."!", funnyForegroundColor, funnyBackgroundColor, 31, 5)

  local mainMenuOptions = {}
  mainMenuOptions[1] = "  Find matches  "
  mainMenuOptions[2] = "    Set name    "
  mainMenuOptions[3] = "      Quit      "

  for k, v in pairs(mainMenuOptions) do
    if k == mainMenuPosition then
      v = ui.surroundInBrackets(v)
    end

    ui.drawUI(v, "0", "2aaaaaaaaaaaaaa2", 31, 6 + k)

  end
end

function mainMenu(key)
  if key == "up" and mainMenuPosition > 1 then
    mainMenuPosition = mainMenuPosition - 1
  elseif key == "down" and mainMenuPosition < 3 then
    mainMenuPosition = mainMenuPosition + 1
  elseif key == "enter" or key == "space" then
    if mainMenuPosition == 1 then
      core.verifyRemoteHost(remotehost)
      initMatchMenu()
      currentInterface = "MATCHMENU"
      renderMatchMenu()
      return
    elseif mainMenuPosition == 2 then
      currentInterface = "NAMESELECT"
      renderNameSelect()
      return
    elseif mainMenuPosition == 3 then
      isRunning = false
    end
  end

  renderMainMenu()
end

-- GAME FUNCTIONS

function separateMatchProtocol()
  -- Please refer to /docs/protocol
  local matchArray = core.splitBySeparator(currentMatch, "/")

  mRoundInformation = core.splitBySeparator(matchArray[2], ":")
  -- [1] Round Wind | [2] Round # | [3] Honba count | [4] Riichi count
  mDoraInformation = core.splitBySeparator(matchArray[3], ":")
  -- [1] Dpra tiles | [2] Ura tiles
  mWallInformation = core.splitBySeparator(matchArray[4], ":")
  -- [1] Wall | [2] Dead Wall
  mPlayerNames = core.splitBySeparator(matchArray[5], ":")
  -- [1/2/3/4] E/S/W/N Playername
  mPoints = core.splitBySeparator(matchArray[6], ":")
  -- [1/2/3/4] E/S/W/N Player Points
  mHands = core.splitBySeparator(matchArray[7], ":")
  -- [1/2/3/4] E/S/W/N Player Hand
  mDiscards = core.splitBySeparator(matchArray[8], ":")
  -- [1/2/3/4] E/S/W/N Discards
  mOpened = core.splitBySeparator(matchArray[9], ":")
  -- [1/2/3/4] E/S/W/N Opened
  mOpened = core.splitBySeparator(matchArray[10], ":")
  -- [1/2/3/4] E/S/W/N Riichi Status
end

function renderBaseInterface()
  ui.renderMonochromeBackground(colors.gray)
  ui.drawUI(" .        >        ^        <       ", "f", "0", 1, 1)
  ui.drawUI("                                    ", "f", "0", 1, 2)
  ui.drawUI("        ", "f", "0", 22, 10)
  ui.drawUI("        ", "f", "08888880", 22, 11)
  ui.drawUI("        ", "f", "0", 22, 12)
end

function renderRoundInformation()
  ui.drawUI(mRoundInformation[1]..mRoundInformation[2], "f", "8", 23, 11)
  ui.drawUI("H"..mRoundInformation[3], "e", "7", 38, 1)
  ui.drawUI("R"..mRoundInformation[4], "e", "7", 38, 2)
end

function renderDoraInformation()
  ui.drawUI("DORA", "0", "7", 41, 1)
  ui.drawUI("URA", "0", "7", 42, 2)
  for i = 1, 5 do
    local tileToConvert = string.sub(mDoraInformation[1], (i * 2) - 1, (i * 2))
    ui.drawUI(ui.convertTileToDrawParams(tileToConvert, 45 + i, 1))
  end
  for i = 1, 5 do
    local tileToConvert = string.sub(mDoraInformation[2], (i * 2) - 1, (i * 2))
    ui.drawUI(ui.convertTileToDrawParams(tileToConvert, 45 + i, 2))
  end
end

function renderWallInformation()
  local tileAmountLeft = tostring(#mWallInformation[1] / 2)
  ui.drawUI(tileAmountLeft, "f", "8", 29 - #tileAmountLeft, 11)
end

function reorderArrayStartingDown(array)
  local playerNumber = 1

  for k, v in pairs(mPlayerNames) do
    if v == currentName then
      playerNumber = k
    end
  end

  local newArray = {}
  for i = 1, 4 do
    local currentPlayer = (i + playerNumber - 1) % 4
    if currentPlayer == 0 then currentPlayer = 4 end
    newArray[i] = array[currentPlayer]
  end

  return newArray
end

function renderPlayerInformation()
  for k, v in pairs(reorderArrayStartingDown(mPlayerNames)) do
    ui.drawUI(v, "a", "0", (9 * k) - #v, 2) 
  end
  for k, v in pairs(reorderArrayStartingDown(mPoints)) do
    ui.drawUI(v, "f", "0", (9 * k) - #v, 1) 
  end
end

function renderPlayerHands()
  -- . HAND
  for i = 1, #mHands[1] / 2 do
    local tileToConvert = string.sub(mHands[1], (i * 2) - 1, (i * 2))
    ui.drawUI(convertTileToDrawParams(tileToConvert, 18 + i, 18))
  end

  -- > HAND
  for i = 1, #mHands[2] / 2 do
    local tileToConvert = string.sub(mHands[2], (i * 2) - 1, (i * 2))
    ui.drawUI(convertTileToDrawParams(tileToConvert, 48, 19 - i))
  end

  -- ^ HAND
  for i = 1, #mHands[3] / 2 do
    local tileToConvert = string.sub(mHands[3], (i * 2) - 1, (i * 2))
    ui.drawUI(convertTileToDrawParams(tileToConvert, 32 - i, 4))
  end

  -- < HAND
  for i = 1, #mHands[2] / 2 do
    local tileToConvert = string.sub(mHands[4], (i * 2) - 1, (i * 2))
    ui.drawUI(convertTileToDrawParams(tileToConvert, 4, 3 + i))
  end
end


function renderGame()
  renderBaseInterface()
  renderRoundInformation()
  renderDoraInformation()
  renderWallInformation()
  renderPlayerInformation()
  renderPlayerHands()
end

function game()
  renderGame()
end

-- MATCH MENU FUNCTIONS

local matchMenuPosition = 1

function initMatchMenu()
  local availableMatches = core.splitBySeparator(fetch(), ":")
  matchMenuOptions = {}

  matchMenuOptions[1] = "  NEW  "
  matchMenuOptions[2] = "  REFRESH  "
  matchMenuOptions[3] = "  BACK  "

  for k,v in pairs(availableMatches) do
    matchMenuOptions[3 + k] = v
  end

  renderMatchMenu()
end

function renderMatchMenu()
  ui.renderMonochromeBackground(colors.pink)

  local currentHorizontalPosition = 2

  for k, v in pairs(matchMenuOptions) do
    if k > 3 then
      v = "  "..v.."  "
    end

    if k == matchMenuPosition then
      v = ui.surroundInBrackets(v)
    end

    if k < 4 then
      ui.drawUI(v, "0", "2", currentHorizontalPosition, 2)
      currentHorizontalPosition = currentHorizontalPosition + #v + 2
    else 
      ui.drawUI(v..string.rep(" ", 49 - #v), "0", "2", 2, k)
    end
  end

  ui.drawUI("Playing: "..currentName, "e", "6", currentHorizontalPosition, 2)

end

function matchMenu(key)
  -- 1 2 3
  -- 44444
  -- 55555

  if key == "left" and matchMenuPosition > 1 and matchMenuPosition < 4 then
    matchMenuPosition = matchMenuPosition - 1
  elseif key == "right" and matchMenuPosition < 3 then
    matchMenuPosition = matchMenuPosition + 1
  elseif key == "down" then
    if matchMenuPosition < 4 then
      matchMenuPosition = 4
    elseif matchMenuPosition < #matchMenuOptions then
      matchMenuPosition = matchMenuPosition + 1
    end
  elseif key == "up" then
    if matchMenuPosition > 4 then
      matchMenuPosition = matchMenuPosition - 1
    else
      matchMenuPosition = 1
    end
  elseif key == "enter" then
    if matchMenuPosition == 1 then
    elseif matchMenuPosition == 2 then
      initMatchMenu()
    elseif matchMenuPosition == 3 then
      currentInterface = "MAINMENU"
      renderMainMenu()
      return
    elseif matchMenuPosition > 3 then
      currentMatch = status(matchMenuOptions[matchMenuPosition])
      separateMatchProtocol()
      currentInterface = "GAME"
      renderGame()
      return
    end
  end

  renderMatchMenu()
  term.setCursorPos(1, 9)
end

-- NAME SELECT FUNCTIONS

function renderNameSelect()
  ui.renderMonochromeBackground(colors.gray)
  ui.drawUI("Please enter your name", "0", "7", 16, 9)
  ui.drawUI(currentName..string.rep(" ", 7 - #currentName), "0", "8", 23, 10)
end

function nameSelect(key)
  if string.match(key, "%w") and #key == 1 and #currentName < 7 then
    currentName = currentName..string.upper(key)
  elseif string.match(key, "backspace") then
    currentName = string.sub(currentName, 1, #currentName - 1)
  elseif string.match(key, "enter") and #currentName > 0 then
    core.saveConfig("NAME", currentName)
    currentInterface = "MAINMENU"
    renderMainMenu()
    return
  end

  renderNameSelect()

end

-- APPLICATION FUNCTIONS

function processKey(key)
  if currentInterface == "MAINMENU" then
    mainMenu(key)
  elseif currentInterface == "NAMESELECT" then
    nameSelect(key)
  elseif currentInterface == "MATCHMENU" then
    matchMenu(key)
  elseif currentInterface == "GAME" then
    game()
  end
end

function run()
  if currentName == "" then
    currentInterface = "NAMESELECT"
    renderNameSelect()
  else 
    renderMainMenu()
  end
  
  while isRunning do
    local event, key, is_held = os.pullEvent("key")
    processKey(keys.getName(key))
  end

  rednet.unhost(protocol)
  term.setBackgroundColor(colors.black)
  term.setCursorPos(1,1)
  term.clear()
end

currentInterface = "MATCHMENU"
initMatchMenu()
matchMenuPosition = 4
run()