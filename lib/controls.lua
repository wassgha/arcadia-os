Controls = {}
Controls.__index = Controls

local joystick
local pressed = {}

function Controls:new()
    local obj = setmetatable({}, Controls)
    obj.keyRepeat = false
    obj.callback = function()
        return
    end
    obj.joystickMapping = {
        [9] = "UP",
        [10] = "DOWN",
        [11] = "LEFT",
        [12] = "RIGHT",
        [4] = "Y",
        [2] = "A",
        [1] = "B",
        [3] = "X",
        [15] = "JOYSTICK_1",
        [16] = "JOYSTICK_2",
        [14] = "START",
        [13] = "SELECT",
        [6] = "R1",
        [8] = "R2",
        [7] = "L2",
        [5] = "L1"
    }
    obj.keyboardMapping = {
        ['up'] = "UP",
        ['down'] = "DOWN",
        ['left'] = "LEFT",
        ['right'] = "RIGHT",
        ['enter'] = "A",
        ['return'] = "A"
    }
    return obj
end

function Controls:load()
    self.callback = function()
        return
    end

    -- Select the first Joystick
    joysticks = love.joystick.getJoysticks()
    if #joysticks == 0 then
        print("No joystick found!")
    else
        joystick = joysticks[1]
    end
end

function Controls:on(callback, keyRepeat)
    if type(callback) == "function" then
        self.callback = callback
        self.keyRepeat = keyRepeat or false
        if self.keyRepeat then
            love.keyboard.setKeyRepeat(true)
        else
            love.keyboard.setKeyRepeat(false)
        end
    else
        error("Callback must be a function")
    end
end

function Controls:keypressed(key)
    self.callback(self:keyboard(key))
end

function Controls:keydown(key)
    self.callback(self:keyboard(key))
end

function Controls:update()
    -- Check if the joystick is connected
    if joystick then
        -- Check for button presses
        for button = 1, joystick:getButtonCount() do
            local curPressed = joystick:isDown(button)

            -- Check if the button was not previously pressed
            if curPressed and (not pressed[button] or self.keyRepeat) then
                -- Button is newly pressed, so handle the action
                self.callback(self:joystick(button))
            end

            -- Update the button state
            pressed[button] = curPressed
        end
    end
end

function Controls:joystick(scancode)
    return self.joystickMapping[tonumber(scancode)] or scancode
end

function Controls:keyboard(scancode)
    return self.keyboardMapping[scancode] or scancode
end

function Controls:joystickXY()
    -- Check if the joystick is connected
    if joystick then
        return joystick:getAxis(1), joystick:getAxis(2)
    end
    return 0, 0
end

return Controls
