local Focusable = require("components.focusable")
local IconStore = require("lib.icon_store")
local ImageStore = require("lib.image_store")

Card = setmetatable({}, {
    __index = Focusable
})
Card.__index = Card

-- Helper function to draw a rounder rectangle mask
local function roundedRectangle(x, y, width, height, radius)
    love.graphics.arc("fill", x + radius, y + radius, radius, math.pi, 1.5 * math.pi) -- top-left corner
    love.graphics.arc("fill", x + width - radius, y + radius, radius, 1.5 * math.pi, 2 * math.pi) -- top-right corner
    love.graphics.arc("fill", x + radius, y + height - radius, radius, 0.5 * math.pi, math.pi) -- bottom-left corner
    love.graphics.arc("fill", x + width - radius, y + height - radius, radius, 0, 0.5 * math.pi) -- bottom-right corner
    love.graphics.rectangle("fill", x + radius, y, width - 2 * radius, height) -- top/bottom straight sections
    love.graphics.rectangle("fill", x, y + radius, width, height - 2 * radius) -- left/right straight sections
end

-- Constructor for the Menu class
function Card:new(label, variant, padding, icon, cover)
    local instance = setmetatable(Focusable.new(variant), self)

    -- Initialize the menu properties
    instance.icon = icon or nil
    instance.cover = cover or nil
    instance.padding = padding
    instance.variant = variant or Variant.PRIMARY
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    if label ~= "" then
        instance.label = Button:new(label, 24, "primary", 8)
        instance.label:focus()
    end

    return instance
end

-- Render the button on the screen
function Card:draw(x, y, width, height)
    local startX = x
    local startY = y
    local radius = 8

    local cardWidth = width
    local cardHeight = height

    local iconSize = self.icon and 48 or 0

    Focusable.draw(self, startX, startY, cardWidth, cardHeight, self.padding)

    local function stencilFunction()
        roundedRectangle(startX + 1, startY + 1, cardWidth - 2, cardHeight - 2, radius / 2)
    end

    love.graphics.stencil(stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- Draw the placeholder icon if provided
    if self.icon then
        local icon = IconStore.loadIcon("pixelarticons/light/" .. self.icon)
        local scaleFactor = iconSize / icon.getWidth(icon)
        if icon then
            love.graphics.draw(icon, startX + cardWidth / 2 - iconSize / 2, startY + cardHeight / 2 - iconSize / 2, 0,
                scaleFactor, scaleFactor, 0, 0)
        end
    end

    -- Draw the placeholder icon if provided
    if self.cover then
        local cover = ImageStore.loadImage(self.cover)
        local scaleFactor = cardWidth / cover.getWidth(cover)
        if cover then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(cover, startX, startY + cardHeight / 2 - (cover.getHeight(cover) * scaleFactor) / 2, 0,
                scaleFactor, scaleFactor, 0, 0)
        end
    end

    if self.label ~= nil then
        self.label:draw(startX + 18, startY + cardHeight - 40)
    end

    love.graphics.setStencilTest()
end

return Card
