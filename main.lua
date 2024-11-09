arcadia = require("lib.arcadia")

local Screen = require("lib.screen")

-- Screens
local HomeScreen = require("screens.home")
local OptionsScreen = require("screens.options")
local AboutScreen = require("screens.about")
local CatalogScreen = require("screens.catalog")
local UpdateScreen = require("screens.update")
local AppScreen = require("screens.app")
local PlaygroundScreen = require("screens.playground")
local LauncherScreen = require("screens.launcher")
local SplashScreen = require("screens.splash")

-- Create screens
local SplashScreen = SplashScreen:new()
local HomeScreen = HomeScreen:new()
local CatalogScreen = CatalogScreen:new()
local OptionsScreen = OptionsScreen:new()
local AboutScreen = AboutScreen:new()
local AppScreen = AppScreen:new()
local UpdateScreen = UpdateScreen:new()
local PlaygroundScreen = PlaygroundScreen:new()
local LauncherScreen = LauncherScreen:new()

function love.load()
    -- Initialize Config
    arcadia.config:load()

    -- Initialize Theme
    arcadia.theme:load()

    -- Initialize Controls
    arcadia.controls:load()

    love.window.setMode(640, 480)
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Register Screens
    arcadia.navigation:addScreen("Splash", SplashScreen)
    arcadia.navigation:addScreen("Home", HomeScreen)
    arcadia.navigation:addScreen("Launcher", LauncherScreen)
    arcadia.navigation:addScreen("Catalog", CatalogScreen)
    arcadia.navigation:addScreen("Playground", PlaygroundScreen)
    arcadia.navigation:addScreen("Update", UpdateScreen)
    arcadia.navigation:addScreen("Options", OptionsScreen)
    arcadia.navigation:addScreen("App", AppScreen)
    arcadia.navigation:addScreen("About", AboutScreen)

    -- Switch to default screen
    arcadia.navigation:switchTo("Splash")
end

function love.keypressed(key)
    arcadia.controls:keypressed(key)
end

function love.update(dt)
    arcadia.controls:update(dt)
    arcadia.navigation:update(dt)
end

function love.draw()
    arcadia.navigation:draw()
end
