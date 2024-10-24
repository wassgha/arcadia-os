local Controls = require("lib.controls")
local Animation = require("lib.animation")

local arcadia = {}

arcadia.draw = nil
arcadia.update = nil
arcadia.keypressed = nil

-- Create a function to initialize Love2D callbacks with arcadia's versions
function arcadia.initialize()
    -- Reassign Love2D's callbacks to arcadia's
    function love.draw()
        if arcadia.draw then
            arcadia.draw() -- Call the user's custom draw function
        end
    end

    function love.update(dt)
        if arcadia.update then
            arcadia.update(dt) -- Call the user's custom update function
        end
    end

    -- Add other callbacks as needed
    function love.keypressed(key)
        if arcadia.keypressed then
            arcadia.keypressed(key) -- Call the user's custom keypressed function
        end
    end
end

-- Add arcadia specific modules
arcadia.controls = Controls.new()
arcadia.animation = Animation.new()
arcadia.components = nil -- TBD
arcadia.navigation = nil -- TBD

-- Re-export other Love2D modules like graphics, audio, etc.
arcadia.graphics = love.graphics
arcadia.audio = love.audio
arcadia.data = love.data
arcadia.event = love.event
arcadia.filesystem = love.filesystem
arcadia.font = love.font
arcadia.graphics = love.graphics
arcadia.image = love.image
arcadia.joystick = love.joystick
arcadia.keyboard = love.keyboard
arcadia.math = love.math
arcadia.mouse = love.mouse
arcadia.physics = love.physics
arcadia.sound = love.sound
arcadia.system = love.system
arcadia.thread = love.thread
arcadia.timer = love.timer
arcadia.touch = love.touch
arcadia.video = love.video
arcadia.window = love.window

return arcadia
