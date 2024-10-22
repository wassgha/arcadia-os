local Menu = require("components.menu")
local Screen = require("lib.screen")

local HomeScreen = setmetatable({}, {
    __index = Screen
})
HomeScreen.__index = HomeScreen

function HomeScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, mgr, ctrls), self)

    -- Define menu items
    local items = {{
        label = "Games & Things",
        onSelect = function()
            return
        end
    }, {
        label = "Store Catalog",
        onSelect = function()
            mgr:switchTo('Games')
            return
        end
    }, {
        label = "Options",
        onSelect = function()
            mgr:switchTo('Options')
            return
        end
    }, {
        label = "Playground (Dev)",
        onSelect = function()
            mgr:switchTo('Playground')
            return
        end
    }, {
        label = "Check for updates",
        onSelect = function()
            mgr:switchTo('Update')
            return
        end
    }, {
        label = "Donate",
        onSelect = function()
            mgr:switchTo('Donate')
            return
        end
    }, {
        label = "Exit",
        onSelect = function()
            os.exit()
            return
        end
    }}
    instance.menu = Menu:new(items, 24, 42, 8)

    return instance
end

function HomeScreen:draw()
    love.graphics.clear(0.05, 0.05, 0.05)
    self.menu:draw(28, 28) -- Draw the menu
end

function HomeScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return HomeScreen
