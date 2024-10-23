local Controls = require("lib.controls")
local ScreenManager = require("lib.screen_manager")
local Screen = require("lib.screen")

-- Screens
local HomeScreen = require("screens.home")
local OptionsScreen = require("screens.options")
local AboutScreen = require("screens.about")
local GamesScreen = require("screens.games")
local UpdateScreen = require("screens.update")
local ClockScreen = require("screens.clock")
local PlaygroundScreen = require("screens.playground")
local CatalogScreen = require("screens.catalog")

local ctrls = Controls.new()

-- Create a screen manager
local screenManager = ScreenManager:new(crtls)

-- Create screens
local HomeScreen = HomeScreen:new(screenManager, ctrls)
local GamesScreen = GamesScreen:new(screenManager, ctrls)
local OptionsScreen = OptionsScreen:new(screenManager, ctrls)
local AboutScreen = AboutScreen:new(screenManager, ctrls)
local ClockScreen = ClockScreen:new(screenManager, ctrls)
local UpdateScreen = UpdateScreen:new(screenManager, ctrls)
local PlaygroundScreen = PlaygroundScreen:new(screenManager, ctrls)
local CatalogScreen = CatalogScreen:new(screenManager, ctrls)

function love.load()
    -- Initialize Controls
    ctrls:load()

    love.window.setMode(640, 480)
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Register Screens
    screenManager:addScreen("Home", HomeScreen)
    screenManager:addScreen("Games", GamesScreen)
    screenManager:addScreen("Catalog", CatalogScreen)
    screenManager:addScreen("Playground", PlaygroundScreen)
    screenManager:addScreen("Update", UpdateScreen)
    screenManager:addScreen("Options", OptionsScreen)
    screenManager:addScreen("Clock", ClockScreen)
    screenManager:addScreen("About", AboutScreen)

    -- Switch to home by default
    screenManager:switchTo("Home")
end

function love.keypressed(key)
    ctrls:keypressed(key)
end

function love.update(dt)
    ctrls:update(dt)
    screenManager:update(dt)
end

function love.draw()
    screenManager:draw()
end
