termx, termy = term.getSize()
term.setPaletteColor(colors.lightGray, 0xBBBBBB)

function init(color)
  term.setBackgroundColor(colors.pink)
  term.setTextColor(colors.black)
  term.setCursorPos(21, 10)
  term.clear()
  term.blit("LOADING...", "FFFFFFFFFF", "0000000000")
end

function renderDebug(debugMessage)
    term.setCursorPos(1, termy)
    local spacedmessage = debugMessage..string.rep(" ", 10 - #debugMessage)
  
    term.blit(extendPattern(spacedmessage, "f", "7"))
end

function renderMonochromeBackground(color)
  term.setBackgroundColor(color)
  term.clear()
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

function surroundInBrackets(text)
  return "["..string.sub(text, 2, #text -1 ).."]"
end

function drawUI(text, bg, fg, x, y)
  bg = extendPattern(text, bg)
  fg = extendPattern(text, fg)

  term.setCursorPos(x, y)
  term.blit(text, bg, fg)
end

function convertTileToDrawParams(tile, tilex, tiley)
  local tileNumber = string.sub(tile, 1, 1)
  local tileSuit = string.sub(tile, 2, 2)

  -- DEFAULT TO BLANK
  local tileForeground = " "
  -- FOREGROUNDS
  -- DRAGON
  if tile == "5z" then
    tileForeground = "0"
    tileNumber = "W"
  elseif tile == "6z" then
    tileForeground = "d"
    tileNumber = "G"
  elseif tile == "7z" then
    tileForeground = "e"
    tileNumber = "R"
  -- WINDS  
  elseif tileSuit == "z" then
    tileForeground = "9"
    if tileNumber == "1" then
      tileNumber = "E"
    elseif tileNumber == "2" then
      tileNumber = "S"
    elseif tileNumber == "3" then
      tileNumber = "W"
    elseif tileNumber == "4" then
      tileNumber = "N"
    end
  -- CHARACTER
  elseif tileSuit == "m" then
    tileForeground = "e"
  -- PIN
  elseif tileSuit == "p" then
    tileForeground = "b"
  -- BAMBOO
  elseif tileSuit == "s" then
    tileForeground = "d"
  end

  -- DEFAULT TO BLANK
  local tileBackground = "7"
  -- BACKGROUND
  -- HIDDEN TILE
  if tileNumber == "x" then
    tileNumber = " "
    if (tilex + tiley) % 2 == 0 then
      tileBackground = "5"
    else
      tileBackground = "d"
    end
  -- VISIBLE TILE
  else
    -- DORA (UPPERCASE)
    if string.gmatch(tileSuit, "%u") == true then
      tileBackground = "2"
    else
      if (tilex + tiley) % 2 == 0 then
        tileBackground = "0"
      else
        tileBackground = "8"
      end
    end
  end

  return tileNumber, tileForeground, tileBackground, tilex, tiley
end

return { 
  init = init, 
  renderDebug = renderDebug, 
  renderMonochromeBackground = renderMonochromeBackground, 
  drawUI = drawUI, 
  surroundInBrackets = surroundInBrackets, 
  convertTileToDrawParams = convertTileToDrawParams
}