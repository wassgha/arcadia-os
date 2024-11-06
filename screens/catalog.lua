local Button = require("components.button")
local Screen = require("lib.screen")

local CatalogScreen = setmetatable({}, {
    __index = Screen
})
CatalogScreen.__index = CatalogScreen

function CatalogScreen:new()
    local instance = setmetatable(Screen.new(self), self)

    instance.button = Button:new('Coming soon. Stay tuned!', 28, 'PRIMARY', 8, 'cake')

    return instance
end

function CatalogScreen:draw()
    self.button:draw(love.graphics.getWidth() / 2 - 190, love.graphics.getHeight() / 2 - 20) -- Draw the menu
end

function CatalogScreen:load()
    -- Initialize controls
    arcadia.controls:on(function(key)
        if key == 'B' then
            arcadia.navigation:switchTo("Home")
            return
        end
    end)
end

return CatalogScreen
