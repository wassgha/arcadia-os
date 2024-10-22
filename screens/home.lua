local Menu = require("components.menu")
local Screen = require("lib.screen")

local HomeScreen = setmetatable({}, { __index = Screen })
HomeScreen.__index = HomeScreen

function HomeScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, "Home", mgr, ctrls), self)

    -- Define menu items
    local items = { "Games & Things", "Store Catalog", "Options", "Check for updates", "Donate", "Exit" }
    instance.menu = Menu:new(items, "font.ttf", 24, 42, 8)
    
    return instance
end

function HomeScreen:draw()
    love.graphics.clear(0.05,0.05,0.05)
    self.menu:draw(28, 28) -- Draw the menu
end

function HomeScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key) self.menu:keypressed(key) end)
    self.menu:onSelect(
        function(idx) 
            if idx == 4 then
                self.mgr:switchTo('Update')
            elseif idx == 6 then
                os.exit()
            else
                self.mgr:switchTo('Games')
            end
        end
    )
end


return HomeScreen