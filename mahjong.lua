local core = require "cryspycore"
local ui = require "cryspyui"

local protocol = "LYMJ"
local hostname = "Naemha"
local remotehost = "MAIN"

local width, height = term.getSize()
local isRunning = true

ui.init()
core.init(protocol, hostname)
core.verifyRemoteHost(remotehost)

function fetch()
  rednet.send(hostID, "FETCH", protocol)
  id, msg = rednet.receive(protocol, 5)

  return msg
end

local currentInterface = "MAINMENU"
local mainMenu_position = 1

function renderMainMenu()
  term.setBackgroundColor(colors.pink)
  term.clear()

  local titleASCII = {}
  titleASCII[1] = "___  ___        _       _                      "
  titleASCII[2] = "|  \\/  |       | |     (_)                     "
  titleASCII[3] = "| .  . |  __ _ | |__    _   ___   _ __    __ _ "
  titleASCII[4] = "| |\\/| | / _` || '_ \\  | | / _ \\ | '_ \\  / _` |"
  titleASCII[5] = "| |  | || (_| || | | | | || (_) || | | || (_| |"
  titleASCII[6] = "\\_|  |_/ \\__,_||_| |_| | | \\___/ |_| |_| \\__, |"
  titleASCII[7] = "                       / |                __/ |"
  titleASCII[8] = "                     |__/                |___/ "

  for k, v in pairs(titleASCII) do
    drawUI(v, "0", "f77f", 3, 2 + k)
  end

  local menu = {}
  menu[1] = "  Find matches  "
  menu[2] = "    Set name    "
  menu[3] = "      Quit      "

  for k, v in pairs(menu) do
    if k == mainMenu_position then
      v = "["..string.sub(v, 2, #v -1 ).."]"
    end

    drawUI(v, "f", "2", 19, 13 + k)
  end
end

function mainMenu(key)
  if key == "up" and mainMenu_position > 1 then
    mainMenu_position = mainMenu_position - 1
  elseif key == "down" and mainMenu_position < 3 then
    mainMenu_position = mainMenu_position + 1
  elseif key == "enter" or key == "space" then
    if mainMenu_position == 3 then
      isRunning = false
    end
  end

  renderMainMenu()
end

function processKey(key)
  if currentInterface == "MAINMENU" then
    mainMenu(key)
  end
end

function run()
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