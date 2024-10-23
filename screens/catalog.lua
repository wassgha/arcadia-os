local Button = require("components.button")
local Card = require("components.card")
local Screen = require("lib.screen")

local CatalogScreen = setmetatable({}, {
    __index = Screen
})
CatalogScreen.__index = CatalogScreen

local SCROLL_SPEED = 10

function CatalogScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, mgr, ctrls), self)
    instance.focused = 1
    instance.cols = 2
    instance.gap = 12
    instance.offsetX = 0
    instance.offsetY = 0
    instance.targetOffsetY = 0
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance.children = {Card:new("Clock", "secondary", 5, "clock", "apps/clock/cover.jpg"),
                         Card:new("Calculator", "secondary", 5, "clock", "apps/calculator/cover.jpg"),
                         Card:new("Sketch", "secondary", 5, "clock", "apps/etch/cover.jpg"),
                         Card:new("Fortune", "secondary", 5, "clock", "apps/fortune/cover.jpg"),
                         Card:new("", "tertiary", 5, "clock"), Card:new("", "tertiary", 5, "clock"),
                         Card:new("", "tertiary", 5, "clock"), Card:new("", "tertiary", 5, "clock"),
                         Card:new("", "tertiary", 5, "clock"), Card:new("", "tertiary", 5, "clock"),
                         Card:new("", "tertiary", 5, "clock")}

    return instance
end

function CatalogScreen:draw()
    love.graphics.clear(0.00001, 0.000001, 0.000001)
    local itemWidth = math.floor((self.screenWidth - self.gap) / self.cols) - self.gap
    local itemHeight = itemWidth * (2 / 3)
    for i, child in ipairs(self.children) do
        local col = (i - 1) % self.cols
        local row = math.floor((i - 1) / self.cols)
        child:draw(self.gap + (itemWidth + self.gap) * col - self.offsetX,
            self.gap + (itemHeight + self.gap) * row - self.offsetY, itemWidth, itemHeight, 6)
    end
end

function CatalogScreen:update(dt)
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

function CatalogScreen:load()
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
        elseif key == 'A' then
            if self.focused == 1 then
                self.mgr:switchTo("App", {
                    appName = 'clock'
                })
            elseif self.focused == 2 then
                self.mgr:switchTo("App", {
                    appName = 'calculator'
                })
            elseif self.focused == 3 then
                self.mgr:switchTo("App", {
                    appName = 'etch'
                })
            elseif self.focused == 4 then
                self.mgr:switchTo("App", {
                    appName = 'fortune'
                })
            end
        else
            self.mgr:switchTo("Home")
        end
    end)
end

return CatalogScreen
