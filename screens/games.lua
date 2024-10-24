local Menu = require("components.menu")
local Screen = require("lib.screen")

local GamesScreen = setmetatable({}, {
    __index = Screen
})
GamesScreen.__index = GamesScreen

function GamesScreen:new()
    local instance = setmetatable(Screen.new(self), self)

    -- Define menu items
    local items = {{
        label = "Game 1"
    }, {
        label = "Game 2"
    }, {
        label = "Game 3"
    }, {
        label = "Game 4"
    }, {
        label = "Back",
        onSelect = function()
            screenManager:switchTo('Home')
        end
    }}
    instance.menu = Menu:new(items, 24, 42, 8)

    return instance
end

function GamesScreen:draw()
    self.menu:draw(28, 28) -- Draw the menu
end

function GamesScreen:load()
    -- Initialize controls
    ctrls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return GamesScreen
