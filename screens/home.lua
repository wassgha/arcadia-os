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
        icon = "gamepad",
        onSelect = function()
            mgr:switchTo('Games')
            return
        end
    }, {
        label = "Catalog",
        icon = "shopping-bag",
        onSelect = function()
            mgr:switchTo('Catalog')
            return
        end
    }, {
        label = "Options",
        icon = "command",
        onSelect = function()
            mgr:switchTo('Options')
            return
        end
    }, {
        label = "Developer Playground",
        icon = "debug",
        onSelect = function()
            mgr:switchTo('Playground')
            return
        end
    }, {
        label = "Update Arcadia",
        icon = "reload",
        onSelect = function()
            mgr:switchTo('Update')
            return
        end
    }, {
        label = "Donate",
        icon = "heart",
        onSelect = function()
            mgr:switchTo('Donate')
            return
        end
    }, {
        label = "About",
        icon = "info-box",
        onSelect = function()
            mgr:switchTo('About')
            return
        end
    }, {
        label = "Exit",
        icon = "logout",
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
