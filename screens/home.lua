local Menu = require("components.menu")
local Screen = require("lib.screen")

local HomeScreen = setmetatable({}, {
    __index = Screen
})
HomeScreen.__index = HomeScreen

function HomeScreen:new()
    local instance = setmetatable(Screen.new(self), self)
    instance.menu = nil
    return instance
end

function HomeScreen:draw()
    if not self.menu then
        return
    end
    self.menu:render() -- Render the menu
end

function HomeScreen:load()
    local devMode = arcadia.config:get(ConfigKey.DEV_MODE)

    -- Define menu items
    local items = {}
    table.add(items, {{
        label = "Games & Things",
        icon = "gamepad",
        onSelect = function()
            arcadia.navigation:switchTo('Launcher')
            return
        end
    }, {
        label = "Catalog",
        icon = "shopping-bag",
        onSelect = function()
            arcadia.navigation:switchTo('Catalog')
            return
        end
    }, {
        label = "Options",
        icon = "command",
        onSelect = function()
            arcadia.navigation:switchTo('Options')
            return
        end
    }})
    if devMode then
        table.insert(items, {
            label = "Developer Playground",
            icon = "debug",
            onSelect = function()
                arcadia.navigation:switchTo('Playground')
                return
            end
        })
    end

    table.add(items, {{
        label = "Update Arcadia",
        icon = "reload",
        onSelect = function()
            arcadia.navigation:switchTo('Update')
            return
        end
    }, {
        label = "Donate",
        icon = "heart",
        onSelect = function()
            arcadia.navigation:switchTo('Donate')
            return
        end
    }, {
        label = "About",
        icon = "info-box",
        onSelect = function()
            arcadia.navigation:switchTo('About')
            return
        end
    }, {
        label = "Exit",
        icon = "logout",
        onSelect = function()
            os.exit()
            return
        end
    }})

    -- Create a menu
    self.menu = Menu:new({
        style = {
            padding = 12
        },
        size = 20,
        items = items
    })

    -- Initialize controls
    arcadia.controls:on(function(key)
        self.menu:keypressed(key)
    end)
end

return HomeScreen
