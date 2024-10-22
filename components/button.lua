local Focusable = require("components.focusable")

Button = setmetatable({}, {
    __index = Focusable
})
Button.__index = Button

local Variant = {
    PRIMARY = 'primary',
    SECONDARY = 'secondary',
    TERTIARY = 'tertiary'
}

-- Constructor for the Menu class
function Button:new(label, size, variant, padding)
    local instance = setmetatable(Focusable.new(variant), self)

    -- Initialize the menu properties
    instance.label = label or ""
    instance.padding = padding
    instance.font = love.graphics.newFont("font.ttf", size)
    instance.variant = variant or Variant.PRIMARY
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()

    return instance
end

-- Render the menu on the screen
function Button:draw(x, y)
    love.graphics.setFont(self.font)

    local startX = x
    local startY = y
    local radius = 8

    local textWidth = self.font:getWidth(self.label)
    local textHeight = self.font:getHeight(self.label) + self.font:getDescent(self.label)

    Focusable.draw(self, startX, startY, textWidth, textHeight, self.padding)

    love.graphics.printf(self.label, startX, startY, self.screenWidth, "left")
end

return Button
