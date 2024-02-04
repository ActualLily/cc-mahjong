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

-- NETWORK FUNCTIONS

function fetch()
  rednet.send(hostID, "FETCH", protocol)
  id, msg = rednet.receive(protocol, 5)

  return msg
end

local currentName = core.grabConfig()["NAME"]
local currentInterface = "MAINMENU"

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
      print(remotehost)
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
  elseif key == "up" and matchMenuPosition > 3 then
    matchMenuPosition = matchMenuPosition - 1
  end

  renderMatchMenu()
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

run()