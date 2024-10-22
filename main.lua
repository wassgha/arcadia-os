local Controls = require("lib.controls")
local ScreenManager = require("lib.screenmanager")
local Screen = require("lib.screen")

-- Screens
local HomeScreen = require("screens.home")
local GamesScreen = require("screens.games")
local UpdateScreen = require("screens.update")

local ctrls = Controls.new()

-- Create a screen manager
local screenManager = ScreenManager:new(crtls)

-- Create screens
local HomeScreen = HomeScreen:new(screenManager, ctrls)
local GamesScreen = GamesScreen:new(screenManager, ctrls)
local UpdateScreen = UpdateScreen:new(screenManager, ctrls)
local OptionsScreen = Screen:new("Options", screenManager, ctrls)

function love.load()
    -- Initialize Controls
    ctrls:load()

	love.window.setMode(640, 480)
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Register Screens
    screenManager:addScreen("Home", HomeScreen)
    screenManager:addScreen("Games", GamesScreen)
    screenManager:addScreen("Update", UpdateScreen)
    screenManager:addScreen("Options", OptionsScreen)

    -- Switch to home by default
    screenManager:switchTo("Home")
end

function love.keypressed(key)
    ctrls:keypressed(key)
end

function love.update()
    ctrls:update()
    screenManager:update()
end

function love.draw()
    screenManager:draw()
end
