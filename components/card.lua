local Focusable = require("components.focusable")
local IconStore = require("lib.icon_store")

Card = setmetatable({}, {
    __index = Focusable
})
Card.__index = Card

-- Constructor for the Menu class
function Card:new(variant, padding, icon)
    local instance = setmetatable(Focusable.new(variant), self)

    -- Initialize the menu properties
    instance.icon = icon or nil
    instance.padding = padding
    instance.variant = variant or Variant.PRIMARY
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()

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

    -- Draw the leading icon if provided
    if self.icon then
        local icon = IconStore.loadIcon("pixelarticons/light/" .. self.icon)
        local scaleFactor = iconSize / icon.getWidth(icon)
        if icon then
            love.graphics.draw(icon, startX + cardWidth / 2 - iconSize / 2, startY + cardHeight / 2 - iconSize / 2, 0,
                scaleFactor, scaleFactor, 0, 0)
        end
    end
end

return Card
