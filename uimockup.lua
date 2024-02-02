x, y = term.getSize()
defaultForeground = "0"
defaultBackground = "7"

term.setPaletteColor(colors.lightGray, 0xBBBBBB)

function getAllMatrix(set, x, y)
    local matrix = {}
    
    for i = 1, y do
        matrix[y] = string.rep(set, x)
    end
    
    return matrix
end

function render()
    for i = 1, y do
        bg[i] = string.gsub(bg[i], " ", defaultBackground)
        fg[i] = string.gsub(fg[i], " ", defaultForeground)
        
        term.setCursorPos(1, i)
        term.blit(tx[i], fg[i], bg[i])
    end
end

fg = getAllMatrix(defaultForeground, x, y)
bg = getAllMatrix(defaultBackground, x, y)
tx = getAllMatrix(" ", x, y)

          ---------------------------------------------------
tx[1] =  " . 25000  > 25000  ^ 25000  < 25000    DORA 8      "
tx[2] =  "  NAEMHA   MADOKA   HOMURA   SAYAKA     URA        "
tx[3] =  "                                                   "
tx[4] =  "                                                   "
tx[5] =  "                                                   "
tx[6] =  "                      232H49                       "
tx[7] =  "                      241335                       "
tx[8] =  "                      8E                           "
tx[9] =  "                                                   "
tx[10] = "            671498       E      8WW796             "
tx[11] = "            224377   S  23  N   4794R8             "
tx[12] = "            S2           W      58                 "
tx[13] = "                                                   "
tx[14] = "                      NGS12E                       "
tx[15] = "                      997851                       "
tx[16] = "                      2R5                          "
tx[17] = "                                                   "
tx[18] = "                  1236665645677 5                  "
tx[19] = "                  -^----------- -                  "
          ---------------------------------------------------
fg[1] =  " FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF         EEEEE  "
fg[2] =  " AAAAAAA666666666666666666666666666         EEEEE  "
fg[3] =  "                                                   "
fg[4] =  "                                                   "
fg[5] =  "                                                   "
fg[6] =  "                      EBEABE                       "
fg[7] =  "                      BEEBBE                       "
fg[8] =  "                      BA                           "
fg[9] =  "                                                   "
fg[10] = "            DBDEBE   AAAAAAAA   DA0EEB             "
fg[11] = "            BDDEBD   A FFF  A   BBBEAB             "
fg[12] = "            AB       AAAAAAAA   DD                 "
fg[13] = "                                                   "
fg[14] = "                      AAADBA                       "
fg[15] = "                      DDEEDE                       "
fg[16] = "                      DAE                          "
fg[17] = "                                                   "
fg[18] = "                  EEEEEEBBDDDDD E                  "
fg[19] = "                                                   "
          ---------------------------------------------------
bg[1] =  "000000000000000000000000000000000000        0D5D5  "
bg[2] =  "000000000000000000000000000000000000        D5D5D  "
bg[3] =  "                                                   "
bg[4] =  "                  D5D5D5D5D5D5D                    "
bg[5] =  "   D                                           D   "
bg[6] =  "   5                  080808                   5   "
bg[7] =  "   D                  808080                   D   "
bg[8] =  "   5                  08                       5   "
bg[9] =  "   D                                           D   "
bg[10] = "   5        080808   00000000   080808         5   "
bg[11] = "   D        808080   08888880   808080         D   "
bg[12] = "   5        08       00000000   68             5   "
bg[13] = "   D                                           D   "
bg[14] = "   5                  080808                   5   "
bg[15] = "   D                  808080                   D   "
bg[16] = "   5                  080                      5   "
bg[17] = "   D                                           D   "
bg[18] = "                  0808080806080 8                  "
bg[19] = "                                                   "

render()
read()
term.setCursorPos(1, 1)
term.clear()
