-- Disable JIT
jit.off()

-- Augment Lua Language
require('lib.lang_extras')

-- Import Arcadia libraries
local Controls = require("lib.controls")
local Animation = require("lib.animation")
local Config = require("lib.config")
local Navigation = require("lib.navigation")
local ImageCache = require("lib.image_cache")
local IconCache = require("lib.icon_cache")
local Primitives = require("lib.ui.primitives.index")
local Theme = require("lib.theme")

local arcadia = {}

arcadia.draw = nil
arcadia.update = nil
arcadia.keypressed = nil

-- Create a function to initialize Love2D callbacks with arcadia's versions
function arcadia.initialize()
    function love.load()
        if arcadia.load then
            arcadia.load()
        end
    end

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
arcadia.controls = Controls:new()
arcadia.animation = Animation

arcadia.config = Config:new()
arcadia.config:load()

arcadia.theme = Theme:new(arcadia.config)
arcadia.theme:load()

arcadia.navigation = Navigation:new(arcadia.controls)
arcadia.cache = ImageCache
arcadia.icons = IconCache
arcadia.ui = {}
arcadia.ui.primitives = Primitives

-- Unwrap primitives to be top-level
for name, primitive in pairs(arcadia.ui.primitives) do
    _G[name] = primitive
end

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
