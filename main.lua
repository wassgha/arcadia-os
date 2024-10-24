local Controls = require("lib.controls")
ctrls = Controls.new()

local ScreenManager = require("lib.screen_manager")
local Screen = require("lib.screen")

-- Screens
local HomeScreen = require("screens.home")
local OptionsScreen = require("screens.options")
local AboutScreen = require("screens.about")
local GamesScreen = require("screens.games")
local UpdateScreen = require("screens.update")
local AppScreen = require("screens.app")
local PlaygroundScreen = require("screens.playground")
local CatalogScreen = require("screens.catalog")

-- Create a screen manager
screenManager = ScreenManager:new(crtls)

-- Create screens
local HomeScreen = HomeScreen:new()
local GamesScreen = GamesScreen:new()
local OptionsScreen = OptionsScreen:new()
local AboutScreen = AboutScreen:new()
local AppScreen = AppScreen:new()
local UpdateScreen = UpdateScreen:new()
local PlaygroundScreen = PlaygroundScreen:new()
local CatalogScreen = CatalogScreen:new()

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
    screenManager:addScreen("App", AppScreen)
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
