local Menu = require("components.menu")
local Screen = require("lib.screen")

local OptionsScreen = setmetatable({}, {
    __index = Screen
})
OptionsScreen.__index = OptionsScreen

function OptionsScreen:new()
    local instance = setmetatable(Screen.new(self), self)

    -- Define menu items
    local items = {{
        label = "Option 1"
    }, {
        label = "Option 2"
    }, {
        label = "Option 3"
    }, {
        label = "Option 4"
    }, {
        label = "Back",
        onSelect = function()
            screenManager:switchTo('Home')
        end
    }}
    instance.menu = Menu:new(items, 24, 42, 8)

    return instance
end

function OptionsScreen:draw()
    self.menu:draw(28, 28) -- Draw the menu
end

function OptionsScreen:load()
    -- Initialize controls
    ctrls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return OptionsScreen
