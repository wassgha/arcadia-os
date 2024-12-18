local Screen = require("lib.screen")

local AppScreen = setmetatable({}, {
    __index = Screen
})
AppScreen.__index = AppScreen

function AppScreen:new()
    local instance = setmetatable(Screen.new(self), self)
    instance.app = nil
    instance.appName = nil
    return instance
end

function AppScreen:update(dt)
    if not self.app or not self.app.update then
        return
    end
    self.app:update(dt)
end

function AppScreen:draw()
    if not self.app or not self.app.draw then
        return
    end
    self.app:draw()
end

function AppScreen:loadApp(name)
    self.appName = name
    self.load()
end

function AppScreen:load(params)
    if not params.appName then
        return
    end
    self.appName = params.appName
    self.app = require('apps.' .. self.appName .. '.main'):new()
    if self.app.load then
        self.app:load()
    end
end

return AppScreen
