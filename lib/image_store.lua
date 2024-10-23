-- image_store.lua
local images = {} -- The global image store

local ImageStore = {}

function ImageStore.loadImage(filename)
    if not images[filename] then
        images[filename] = love.graphics.newImage("assets/" .. filename)
    end
    return images[filename]
end

return ImageStore
