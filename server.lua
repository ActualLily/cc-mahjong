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

function getMatchStatus(id)
  local match = fs.open("/mahjong/match/"..id, "r")
  line = match.readLine()
  match.close()
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
    local protocolrequest = msglist[1]

    if protocolrequest == "FETCH" then
      local fetch = coroutine.create(returnMatches)
      coroutine.resume(fetch, id)
    end
  end
end

host()