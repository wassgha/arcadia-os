local Menu = require("components.menu")
local Screen = require("lib.screen")

local AboutScreen = setmetatable({}, {
    __index = Screen
})
AboutScreen.__index = AboutScreen

function AboutScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, mgr, ctrls), self)

    -- Define menu items
    local items = {{
        label = "Made with LOVE (lua/love2d)"
    }, {
        label = "Icons by PixelartIcons (github/halfmage)"
    }, {
        label = "Back",
        onSelect = function()
            mgr:switchTo('Home')
        end
    }}
    instance.menu = Menu:new(items, 24, 42, 8)

    return instance
end

function AboutScreen:draw()
    love.graphics.clear(0.05, 0.05, 0.05)
    self.menu:draw(28, 28) -- Draw the menu
end

function AboutScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return AboutScreen
