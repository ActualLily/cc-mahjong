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
    isConnected = true
  end
end

function fetch()
  rednet.send(hostID, "FETCH", protocol)
  id, msg = rednet.receive(protocol, 5)

  return msg
end
local currentName = core.grabConfig()["NAME"]
local currentInterface = "MAINMENU"
local mainMenu_position = 1

-- MAIN MENU FUNCTIONS

function renderMainMenu()
  ui.renderMonochromeBackground(colors.pink)

  local titleASCII = {}
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

  for k, v in pairs(titleASCII) do
    ui.drawUI(v, "e", "6", 2, 1 + k)
  end

  ui.drawUI("Welcome, "..currentName.."!", "e", "6", 31, 5)

  local menu = {}
  menu[1] = "  Find matches  "
  menu[2] = "    Set name    "
  menu[3] = "      Quit      "

  for k, v in pairs(menu) do
    if k == mainMenu_position then
      v = "["..string.sub(v, 2, #v -1 ).."]"
    end

    ui.drawUI(v, "0", "2aaaaaaaaaaaaaa2", 31, 6 + k)
  end
end

function mainMenu(key)
  if key == "up" and mainMenu_position > 1 then
    mainMenu_position = mainMenu_position - 1
  elseif key == "down" and mainMenu_position < 3 then
    mainMenu_position = mainMenu_position + 1
  elseif key == "enter" or key == "space" then
    if mainMenu_position == 1 then
      -- do findmatches
    elseif mainMenu_position == 2 then
      currentInterface = "NAMESELECT"
      renderNameSelect()
      return
    elseif mainMenu_position == 3 then
      isRunning = false
    end
  end

  renderMainMenu()
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
    return44
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