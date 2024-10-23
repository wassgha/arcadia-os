-- screen.lua

ScreenManager = {}
ScreenManager.__index = ScreenManager


function ScreenManager:new()
    local instance = setmetatable({}, ScreenManager)
    instance.screens = {}
    instance.currentScreen = nil
    return instance
end

function ScreenManager:addScreen(name, screen)
    self.screens[name] = screen
end

function ScreenManager:switchTo(name)
    if self.screens[name] then
        if self.currentScreen and self.currentScreen.onExit then
            self.currentScreen:onExit()
        end

        self.currentScreen = self.screens[name]
        if self.currentScreen.load then
            self.currentScreen:load()
        end    

        if self.currentScreen.onEnter then
            self.currentScreen:onEnter()
        end
    else
        error("Screen not found: " .. name)
    end
end

function ScreenManager:update(dt)
    if self.currentScreen and self.currentScreen.update then
        self.currentScreen:update(dt)
    end
end

function ScreenManager:draw()
    if self.currentScreen and self.currentScreen.draw then
        self.currentScreen:draw()
    end
end

return ScreenManager