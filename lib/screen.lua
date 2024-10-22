Screen = {}
Screen.__index = Screen

function Screen:new(mgr, ctrls)
    local instance = setmetatable({}, Screen)
    instance.mgr = mgr
    instance.ctrls = ctrls
    return instance
end

function Screen:load()
    print("Screen loaded")
end

function Screen:onEnter()
    print("Screen entered.")
end

function Screen:onExit()
    print("Screen exited.")
end

function Screen:update(dt)
    -- Update logic for the screen
end

function Screen:draw()
    -- Drawing logic for the screen
end

return Screen
