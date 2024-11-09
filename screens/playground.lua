local Button = require("components.button")
local Slider = require("components.slider")
local Scrollable = require("components.scrollable")
local Focusable = require("components.Focusable")
local Screen = require("lib.screen")

local PlaygroundScreen = setmetatable({}, {
    __index = Screen
})
PlaygroundScreen.__index = PlaygroundScreen

function PlaygroundScreen:new()
    local instance = setmetatable(Screen.new(self), self)
    instance.volume = 5
    instance.progress = 20 -- %
    instance.focused = 1
    instance.focusableElements = 6
    instance.cols = 1
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance:refresh()

    return instance
end

function PlaygroundScreen:draw()
    arcadia.graphics.clear(arcadia.theme.bg)
    self.slider:render()
    self.progressBar:render()
    self.scrollable:render()
end

function PlaygroundScreen:refresh()
    self.slider = Slider:new({
        key = 'slider-1',
        value = self.volume,
        min = 1,
        max = 10,
        horizontal = false
    })

    self.progressBar = Slider:new({
        key = 'slider-2',
        value = self.progress,
        min = 1,
        max = 100,
        horizontal = true,
        width = self.screenWidth - 8 - 24,
        height = 20,
        style = {
            position = 'absolute',
            top = 400,
            left = 0
        }
    })

    self.scrollable = Scrollable:new({
        key = 'scrollable-1',
        style = {
            top = 20,
            left = 100,
            overflow = 'hidden',
            radius = 12
        },
        gap = 12,
        height = 200,
        children = {Focusable:new({
            key = 'focusable-1',
            focused = self.focused == 1,
            variant = 'tertiary',
            children = {View:new({
                style = {
                    width = 100,
                    height = 40,
                    backgroundColor = arcadia.theme.transparent,
                    radius = 5
                }
            })}
        }), Focusable:new({
            key = 'focusable-2',
            focused = self.focused == 2,
            variant = 'tertiary',
            children = {View:new({
                style = {
                    width = 100,
                    height = 40,
                    backgroundColor = arcadia.theme.transparent,
                    radius = 5
                }
            })}
        }), Focusable:new({
            key = 'focusable-3',
            focused = self.focused == 3,
            variant = 'tertiary',
            children = {View:new({
                style = {
                    width = 100,
                    height = 40,
                    backgroundColor = arcadia.theme.transparent,
                    radius = 5
                }
            })}
        }), Focusable:new({
            key = 'focusable-4',
            focused = self.focused == 4,
            variant = 'tertiary',
            children = {View:new({
                style = {
                    width = 100,
                    height = 40,
                    backgroundColor = arcadia.theme.transparent,
                    radius = 5
                }
            })}
        }), Focusable:new({
            key = 'focusable-5',
            focused = self.focused == 5,
            variant = 'tertiary',
            children = {View:new({
                style = {
                    width = 100,
                    height = 40,
                    backgroundColor = arcadia.theme.transparent,
                    radius = 5
                }
            })}
        }), Focusable:new({
            key = 'focusable-6',
            focused = self.focused == 6,
            variant = 'tertiary',
            children = {View:new({
                style = {
                    width = 100,
                    height = 40,
                    backgroundColor = arcadia.theme.text,
                    radius = 5
                }
            })}
        })}
    })

    -- self.slider2 = Slider:new({
    --     value = self.volume,
    --     min = 1,
    --     max = 10,
    --     horizontal = true
    -- })
end

function PlaygroundScreen:update(dt)
    self.progress = self.progress + dt

    if self.progress > 100 then
        self.progress = 1
    end

    self.slider:update(dt)
    self.progressBar:update(dt)
    self.scrollable:update(dt)
end

function PlaygroundScreen:load()
    arcadia.controls:on(function(key)
        if key == 'B' then
            arcadia.navigation:switchTo("Home")
            return
        end

        -- Focus
        if key == 'RIGHT' then
            self.focused = self.focused + 1
            if self.focused > self.focusableElements then
                self.focused = 1
            end
        elseif key == 'DOWN' then
            self.focused = self.focused + self.cols
            if self.focused > self.focusableElements then
                self.focused = 1
            end
        elseif key == 'LEFT' then
            self.focused = self.focused - 1
            if self.focused < 1 then
                self.focused = self.focusableElements
            end
        elseif key == 'UP' then
            self.focused = self.focused - self.cols
            if self.focused < 1 then
                self.focused = self.focusableElements
            end
        end

        -- Volume Control 

        if key == 'UP' then
            self.volume = self.volume + 1
            if self.volume > 10 then
                self.volume = 10
            end
        elseif key == 'DOWN' then
            self.volume = self.volume - 1
            if self.volume < 1 then
                self.volume = 1
            end
        end

        self:refresh()
        self.scrollable:scrollTo(self.focused)
    end)
end

return PlaygroundScreen
