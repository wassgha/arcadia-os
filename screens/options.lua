local Menu = require("components.menu")
local Screen = require("lib.screen")
local OptionsScreen = setmetatable({}, {
    __index = Screen
})
OptionsScreen.__index = OptionsScreen

function OptionsScreen:new()
    local instance = setmetatable(Screen.new(self), self)
    instance.menu = nil
    return instance
end

function OptionsScreen:draw()
    if not self.menu then
        return
    end
    self.menu:draw(28, 28) -- Draw the menu
end

function OptionsScreen:load()
    local devMode = arcadia.config:get(ConfigKey.DEV_MODE)
    local startupScreen = arcadia.config:get(ConfigKey.STARTUP_SCREEN)
    local themeMode = arcadia.config:get(ConfigKey.THEME_MODE)
    -- Define menu items
    local items = {{
        label = devMode and "Disable developer tools" or "Enable developer tools",
        onSelect = function()
            local current = arcadia.config:get(ConfigKey.DEV_MODE) or false
            arcadia.config:set(ConfigKey.DEV_MODE, not current)
            self:load()
        end
    }, {
        label = "Startup screen: " .. startupScreen,
        onSelect = function()
            local current = arcadia.config:get(ConfigKey.STARTUP_SCREEN) or 'Home'
            arcadia.config:set(ConfigKey.STARTUP_SCREEN, current == 'Home' and 'Playground' or 'Home')
            self:load()
        end
    }, {
        label = "Dark Mode " .. (themeMode == 'DARK' and '(on)' or '(off)'),
        onSelect = function()
            local current = arcadia.config:get(ConfigKey.THEME_MODE) or 'DARK'
            arcadia.config:set(ConfigKey.THEME_MODE, current == 'DARK' and 'LIGHT' or 'DARK')
            arcadia.theme:load()
            self:load()
        end
    }, {
        label = "Back",
        onSelect = function()
            arcadia.navigation:switchTo('Home')
        end
    }}
    self.menu = Menu:new({
        style = {
            padding = 12
        },
        size = 20,
        items = items
    })

    -- Initialize controls
    arcadia.controls:on(function(key)
        if key == "B" then
            arcadia.navigation:switchTo("Home")
        else
            self.menu:keypressed(key)
        end
    end)
end

return OptionsScreen
