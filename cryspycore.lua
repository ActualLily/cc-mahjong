function init(protocolToInit, hostnameToInit)
  peripheral.find("modem", rednet.open)

  if rednet.isOpen() == false then
    term.clear()
    term.setCursorPos(1, 1)
    error("No modem connected")
    return false
  end

  rednet.host(protocolToInit, hostnameToInit)
  return true
end


function splitBySeparator(inputstr, sep)
  if sep == nil then
    sep = "/"
  end

  local array = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(array, str)
  end

  return array
end


function findAfterLastSlash(str)
  local lastSlash = 0

  for i = 1, string.len(str) do
    if string.sub(str, i, i) == "/" then
      lastSlash = i
    end
  end

  return string.sub(str, lastSlash + 1)
end

function verifyRemoteHost(remote)
  hostID = rednet.lookup("LYMJ", remote)

  if hostID == nil then
    term.clear()
    term.setCursorPos(1, 1)
    error("Server "..remote.." could not be reached")
    return false
  end
  print(hostID)
  return hostID
end

function saveConfig(key, value)
  local config = grabConfig()
  config[key] = value

  local configFile = fs.open("/mahjong/config", "w")
  for k,v in pairs(config) do
    configFile.write(k.."="..v.."\n")
  end

  configFile.flush()
  configFile.close()
end

function grabConfig()
  local configFile = fs.open("/mahjong/config", "r")
  local configValues = string.upper(configFile.readAll())
  configFile.close()

  local indexedArray = splitBySeparator(configValues, "\n")
  
  local configArray = {} 

  for k,v in pairs(indexedArray) do
    local keypair = splitBySeparator(v:gsub("%s+", ""), "=")

    if keypair[2] == nil then
      keypair[2] = ""
    end

    configArray[keypair[1]] = keypair[2]
  end

  return configArray
end

return { init = init, verifyRemoteHost = verifyRemoteHost, grabConfig = grabConfig, saveConfig = saveConfig, splitBySeparator = splitBySeparator }