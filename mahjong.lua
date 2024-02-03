local core = require "cryspycore"
local ui = require "cryspyui"

local protocol = core.grabConfig()["PROTOCOL"]
local hostname = core.grabConfig()["NAME"]
local remotehost = core.grabConfig()["HOST"]

local width, height = term.getSize()
local isRunning = true
local isConnected = false

ui.init(colors.pink)

-- NETWORK FUNCTIONS

function ensureConnection()
  if isConnected == false then
    core.init(protocol, hostname)
    core.verifyRemoteHost(remotehost)
    isConnected = core.verifyRemoteHost(remotehost)
    return isConnected
  end
end

local availableMatches = ""

function fetch()
  rednet.send(hostID, "FETCH", protocol)
  id, msg = rednet.receive(protocol, 5)

  availableMatches = msg
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
      v = "["..string.sub(v, 2, #v -1 ).."]"
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
      ensureConnection()

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

function loadMatchMenu()
  local cofetch = coroutine.create(fetch)
  cofetch.resume()

  while cofetch.status() == "running" do
    wait(100)
  end

  renderMatchMenu()
end

function renderMatchMenu()
  ui.renderMonochromeBackground(colors.pink)
  matchMenuOptions = {}
  matchMenuOptions[1] = "  NEW  "
  matchMenuOptions[2] = "  REFRESH  "
  matchMenuOptions[3] = "  BACK  "
  matchMenuOptions[4] = " LOADING..."
  ui.drawUI()
end

function matchMenu(key)
  -- 1 2 3
  -- 44444
  -- 55555

  if key == "left" and matchMenuPosition > 1 and matchMenuPosition < 4 then
    matchMenuPosition = matchMenuPosition - 1
  elseif key == "right" and matchMenuPosition < 3 then
    matchMenuPosition = matchMenuPosition + 1
  elseif key == "down" and matchMenuPosition < #matchMenuPosition then
    matchMenuPosition = matchMenuPosition + 1
  elseif key == "up" and matchMenuPosition > 3 then
    matchMenuPosition = 1
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

  print(currentInterface, currentName)
  renderNameSelect()

end

-- APPLICATION FUNCTIONS

function processKey(key)
  if currentInterface == "MAINMENU" then
    mainMenu(key)
  elseif currentInterface == "NAMESELECT" then
    nameSelect(key)
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
    coprocKey = coroutine.create(processKey)
    coroutine.resume(coprocKey, keys.getName(key))
  end

  rednet.unhost(protocol)
  term.setBackgroundColor(colors.black)
  term.setCursorPos(1,1)
  term.clear()
end

run()