local Menu = require("components.menu")
local Screen = require("lib.screen")

local HomeScreen = setmetatable({}, { __index = Screen })
HomeScreen.__index = HomeScreen

function HomeScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, "Home", mgr, ctrls), self)

    -- Define menu items
    local items = { "My Things", "Catalog", "Options", "Check for updates", "Donate", "Exit" }
    instance.menu = Menu:new(items, "font.ttf", 24, 42, 8)
    
    return instance
end

function HomeScreen:draw()
    self.menu:draw(28, 28) -- Draw the menu
end

function HomeScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key) self.menu:keypressed(key) end)
    self.menu:onSelect(function(item) self.mgr:switchTo('Games') end)
end


return HomeScreen