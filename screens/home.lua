local Menu = require("components.menu")
local Screen = require("lib.screen")

local HomeScreen = setmetatable({}, {
    __index = Screen
})
HomeScreen.__index = HomeScreen

function HomeScreen:new()
    local instance = setmetatable(Screen.new(self), self)

    -- Define menu items
    local items = {{
        label = "Games & Things",
        icon = "gamepad",
        onSelect = function()
            screenManager:switchTo('Games')
            return
        end
    }, {
        label = "Catalog",
        icon = "shopping-bag",
        onSelect = function()
            screenManager:switchTo('Catalog')
            return
        end
    }, {
        label = "Options",
        icon = "command",
        onSelect = function()
            screenManager:switchTo('Options')
            return
        end
    }, {
        label = "Developer Playground",
        icon = "debug",
        onSelect = function()
            screenManager:switchTo('Playground')
            return
        end
    }, {
        label = "Update Arcadia",
        icon = "reload",
        onSelect = function()
            screenManager:switchTo('Update')
            return
        end
    }, {
        label = "Donate",
        icon = "heart",
        onSelect = function()
            screenManager:switchTo('Donate')
            return
        end
    }, {
        label = "About",
        icon = "info-box",
        onSelect = function()
            screenManager:switchTo('About')
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
    self.menu:draw(28, 28) -- Draw the menu
end

function HomeScreen:load()
    -- Initialize controls
    ctrls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return HomeScreen
