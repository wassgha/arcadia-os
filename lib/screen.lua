Screen = {}
Screen.__index = Screen

ScreenPresentation = {
    MODAL = 'modal',
    CARD = 'card'
}

function Screen:new(options)
    local instance = setmetatable({}, Screen)
    instance.options = options or {
        presentation = ScreenPresentation.CARD
    }
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
