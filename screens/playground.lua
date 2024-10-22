local Button = require("components.button")
local Screen = require("lib.screen")

local PlaygroundScreen = setmetatable({}, {
    __index = Screen
})
PlaygroundScreen.__index = PlaygroundScreen

function PlaygroundScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, mgr, ctrls), self)
    instance.button = Button:new("Hello", 24, 'secondary', 8)

    return instance
end

function PlaygroundScreen:draw()
    love.graphics.clear(0.05, 0.05, 0.05)
    self.button:draw(28, 28) -- Draw the menu
end

function PlaygroundScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key)
        if key == 'A' then
            if self.button:isFocused() then
                self.button:blur()
            else
                self.button:focus()
            end
        else
            self.mgr:switchTo("Home")
        end
    end)
end

return PlaygroundScreen
