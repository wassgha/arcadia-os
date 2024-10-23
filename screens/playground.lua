local Button = require("components.button")
local Focusable = require("components.focusable")
local Screen = require("lib.screen")

local PlaygroundScreen = setmetatable({}, {
    __index = Screen
})
PlaygroundScreen.__index = PlaygroundScreen

local SCROLL_SPEED = 10

function PlaygroundScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, mgr, ctrls), self)
    instance.focused = 1
    instance.cols = 2
    instance.gap = 12
    instance.offsetX = 0
    instance.offsetY = 0
    instance.targetOffsetY = 0
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance.children = {Focusable:new("tertiary"), Focusable:new("tertiary"), Focusable:new("tertiary"),
                         Focusable:new("tertiary"), Focusable:new("tertiary"), Focusable:new("tertiary"),
                         Focusable:new("tertiary"), Focusable:new("tertiary"), Focusable:new("tertiary"),
                         Focusable:new("tertiary"), Focusable:new("tertiary")}

    return instance
end

function PlaygroundScreen:draw()
    love.graphics.clear(0.05, 0.05, 0.05)
    local itemWidth = math.floor((self.screenWidth - self.gap) / self.cols) - self.gap
    local itemHeight = itemWidth * (2 / 3)
    for i, child in ipairs(self.children) do
        local col = (i - 1) % self.cols
        local row = math.floor((i - 1) / self.cols)
        child:draw(self.gap + (itemWidth + self.gap) * col - self.offsetX,
            self.gap + (itemHeight + self.gap) * row - self.offsetY, itemWidth, itemHeight, 6)
    end
end

function PlaygroundScreen:update(dt)
    local itemWidth = math.floor((self.screenWidth - self.gap) / self.cols) - self.gap
    local itemHeight = itemWidth * (2 / 3)

    local viewportTop = self.targetOffsetY
    local viewportBottom = self.targetOffsetY + self.screenHeight

    for i, child in ipairs(self.children) do
        if self.focused == i then
            child:focus()
            self.offsetX = 0

            local row = math.floor((i - 1) / self.cols)
            local itemTop = (itemHeight + self.gap) * row
            local itemBottom = itemTop + 2 * self.gap + itemHeight

            -- Scroll up if the focused element is above the viewport
            if itemTop < viewportTop then
                self.targetOffsetY = itemTop
                -- Scroll down if the focused element is below the viewport
            elseif itemBottom > viewportBottom then
                self.targetOffsetY = itemBottom - self.screenHeight
            end
        else
            child:blur()
        end
    end

    -- Smoothly move the current offsetY towards the targetOffsetY (scrolling animation)
    self.offsetY = self.offsetY + (self.targetOffsetY - self.offsetY) * math.min(SCROLL_SPEED * dt, 1)
end

function PlaygroundScreen:load()
    -- Initialize controls
    self.ctrls:on(function(key)
        if key == 'RIGHT' then
            self.focused = self.focused + 1
            if self.focused > #self.children then
                self.focused = 1
            end
        elseif key == 'DOWN' then
            self.focused = self.focused + self.cols
            if self.focused > #self.children then
                self.focused = 1
            end
        elseif key == 'LEFT' then
            self.focused = self.focused - 1
            if self.focused < 1 then
                self.focused = #self.children
            end
        elseif key == 'UP' then
            self.focused = self.focused - self.cols
            if self.focused < 1 then
                self.focused = #self.children
            end
        else
            self.mgr:switchTo("Home")
        end
    end)
end

return PlaygroundScreen
