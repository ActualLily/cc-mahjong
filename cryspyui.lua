termx, termy = term.getSize()

function init(color)
  term.setBackgroundColor(colors.pink)
  term.setCursorPos(21, 10)
  term.clear()
  term.blit("LOADING...", "FFFFFFFFFF", "0000000000")
end

function renderDebug(debugMessage)
    term.setCursorPos(1, height)
    local spacedmessage = debugMessage..string.rep(" ", 10 - #debugMessage)
  
    term.blit(extendPattern(spacedmessage, "f", "7"))
end

function extendPattern(text, pattern)
  if #text > #pattern then
    local patternsize = #pattern
    for i = patternsize, #text - 1 do
        pattern = pattern .. string.sub(pattern, (i % patternsize) + 1, (i % patternsize) + 1)
    end
  end

  return pattern
end

function drawUI(text, bg, fg, x, y)
  x = x or termx
  y = y or termy
 
  bg = extendPattern(text, bg)
  fg = extendPattern(text, fg)

  term.setCursorPos(x, y)
  term.blit(text, bg, fg)
end


return { init = init, renderDebug = renderDebug }