-- icon_store.lua
local icons = {} -- The global icon store

local IconStore = {}

function IconStore.loadIcon(filename)
    if not icons[filename] then
        icons[filename] = love.graphics.newImage("assets/icons/" .. filename .. ".png")
    end
    return icons[filename]
end

return IconStore
