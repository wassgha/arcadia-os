local Menu = require("components.menu")
local Screen = require("lib.screen")

local AboutScreen = setmetatable({}, {
    __index = Screen
})
AboutScreen.__index = AboutScreen

function AboutScreen:new()
    local instance = setmetatable(Screen.new(self), self)

    -- Define menu items
    local items = {{
        label = "Made with LOVE (lua/love2d)"
    }, {
        label = "Icons by PixelartIcons (github/halfmage)"
    }, {
        label = "Back",
        onSelect = function()
            arcadia.navigation:switchTo('Home')
        end
    }}
    instance.menu = Menu:new({
        style = {
            padding = 12
        },
        size = 20,
        items = items
    })

    return instance
end

function AboutScreen:draw()
    self.menu:render() -- Draw the menu
end

function AboutScreen:load()
    -- Initialize controls
    arcadia.controls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return AboutScreen
