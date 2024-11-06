-- image_cache.lua
local images = {} -- The global image store

local ImageCache = {}

function ImageCache.load(filename)
    if not images[filename] then
        images[filename] = love.graphics.newImage(filename)
    end
    return images[filename]
end

return ImageCache
