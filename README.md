# cc-vcs
A mahjong system for ComputerCraft / CCTweaked.
## Installation
Two components are required.
### server.lua (host)
`wget https://raw.githubusercontent.com/ActualLily/cc-mahjong/main/server.lua /mahjong/server.lua`
### vcs.lua (client)
`wget https://raw.githubusercontent.com/ActualLily/cc-mahjong/main/mahjong.lua /mahjong/mahjong.lua`

## Usage
### Server
`/mahjong/server.lua`
Listens on the `LYMJ` protocol for protocol commands as documented in the `protocol` file

### Client
`mahjong/mahjong.lua`
The client has a GUI and will work you through itself.
It will not work if there is no server hosted.