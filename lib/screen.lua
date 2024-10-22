Screen = {}
Screen.__index = Screen

function Screen:new(name, mgr, ctrls)
    local instance = setmetatable({}, Screen)
    instance.name = name
    instance.mgr = mgr
    instance.ctrls = ctrls
    return instance
end

function Screen:load()
    print(self.name .. " screen loaded")
end

function Screen:onEnter()
    print(self.name .. " screen entered.")
end

function Screen:onExit()
    print(self.name .. " screen exited.")
end

function Screen:update(dt)
    -- Update logic for the screen
end

function Screen:draw()
    -- Drawing logic for the screen
end

return Screen