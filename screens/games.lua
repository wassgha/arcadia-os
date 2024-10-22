local Menu = require("components.menu")
local Screen = require("lib.screen")

local GamesScreen = setmetatable({}, { __index = Screen })
GamesScreen.__index = GamesScreen

function GamesScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, "Games", mgr, ctrls), self)

    -- Define menu items
    local items = { "Game 1", "Game 2", "Game 3", "Game 4", "Back" }
    instance.menu = Menu:new(items, "font.ttf", 24, 42, 8)
    
    return instance
end

function GamesScreen:draw()
    love.graphics.clear(0.05,0.05,0.05)
    self.menu:draw(28, 28) -- Draw the menu
end

function GamesScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key) self.menu:keypressed(key) end)
    self.menu:onSelect(function(item) self.mgr:switchTo('Home') end)
end


return GamesScreen