local protocol = "LYMJ"
local hostname = "MAIN"

term.setCursorPos(1, 1)
term.clear()
peripheral.find("modem", rednet.open)

if rednet.isOpen() == false then
  error("No modem connected")
end

function getSplitList(input, separator)
  separator = separator or "/"
  local array = {}

  for item in string.gmatch(input, "([^"..separator.."]+)") do
    table.insert(array, item)
  end

  return array
end

function getMatches()
  matches = fs.find("mahjong/match/*")
  for i = 1, #matches do
    matches[i] = getSplitList(matches[i], "/")[3]
  end

  return matches
end

function getMatchStatus(id, matchid, name)
  local match = fs.open("/mahjong/match/"..matchid, "r")
  line = match.readLine()
  match.close()

  print("STATUS     "..name.." requested \""..matchid.."\"")
  rednet.send(id, line, protocol)
  return line
end

function returnMatches(id)
  local matches = getMatches()
  local catMatches = table.concat(matches, ":")
  print("FETCH      #"..id.." requested matches ("..#matches.." found)")
  rednet.send(id, catMatches, protocol)
end

function host()
  rednet.host(protocol, hostname)
  print(protocol.."://"..hostname.." LISTENING...")

  while true do
    local id, msg = rednet.receive(protocol)
    local msglist = getSplitList(msg)
    local protocolRequest = msglist[1]

    if protocolRequest == "FETCH" then
      returnMatches(id)
    elseif protocolRequest == "STATUS" then
      local matchName = msglist[2]
      local playerName = msglist[3]
      local matchStatus = getMatchStatus(id, matchName, playerName)
    end

  end
end

host()