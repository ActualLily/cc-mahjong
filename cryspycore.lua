local protocol = ""
local hostname = ""

function init(protocolToInit, hostnameToInit)
  protocol = protocolToInit
  hostname = hostnameToInit

  peripheral.find("modem", rednet.open)

  if rednet.isOpen() == false then
    term.clear()
    term.setCursorPos(1, 1)
    error("No modem connected")
    return false
  end

  rednet.host(protocol, hostname)
  return true
end

function verifyRemoteHost(remote)
  hostID = rednet.lookup(protocol, host)

  print(hostID)

  if hostID == nil then
    term.clear()
    term.setCursorPos(1, 1)
    error("Server "..host.." could not be reached")
    return false
  end

  return true
end

return { init = init, verifyRemoteHost = verifyRemoteHost }