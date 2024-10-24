-- screen.lua
ScreenManager = {}
ScreenManager.__index = ScreenManager

function ScreenManager:new()
    local instance = setmetatable({}, ScreenManager)
    instance.screens = {}
    instance.currentScreen = nil
    instance.currentModal = nil
    return instance
end

function ScreenManager:addScreen(name, screen)
    self.screens[name] = screen
end

function ScreenManager:switchTo(name, params)
    if self.screens[name] and self.screens[name].options.presentation == ScreenPresentation.CARD then
        if self.currentScreen and self.currentScreen.onExit then
            self.currentScreen:onExit()
        end

        if self.currentModal and self.currentModal.onExit then
            self.currentModal:onExit()
        end

        self.currentModal = nil

        self.currentScreen = self.screens[name]
        if self.currentScreen.load then
            self.currentScreen:load(params)
        end

        if self.currentScreen.onEnter then
            self.currentScreen:onEnter()
        end
    elseif self.screens[name] and self.screens[name].options.presentation == ScreenPresentation.MODAL then
        self.currentModal = self.screens[name]
        if self.currentModal.load then
            self.currentModal:load(params)
        end

        if self.currentModal.onEnter then
            self.currentModal:onEnter()
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
    love.graphics.clear(0, 0, 0)
    if self.currentScreen and self.currentScreen.draw then
        self.currentScreen:draw()
    end
    if self.currentModal and self.currentModal.draw then
        love.graphics.setColor(0.1, 0.1, 0.1, 0.4)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(0.1, 0.1, 0.1, 0.95)
        love.graphics.rectangle('fill', 0, 0, 350, love.graphics.getHeight())
        self.currentModal:draw()
    end
end

return ScreenManager
