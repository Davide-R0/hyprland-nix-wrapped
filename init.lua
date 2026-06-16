local nixInfo = require('nix-info')

local lua_dir = nixInfo(nil, "lua_dir")
if lua_dir then
    package.path = package.path .. ";" .. lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua"
end

require('keybinds').apply(nixInfo)
require('options').apply(nixInfo)
--require('window').apply(nixInfo)
