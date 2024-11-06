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
    -- Any initialization logic
end

function Screen:onEnter()
    -- Handle logic for transitioning into the screen
end

function Screen:onExit()
    -- Handle logic before exiting the screen
end

function Screen:update(dt)
    -- Update logic for the screen
end

function Screen:draw()
    -- Drawing logic for the screen
end

return Screen
