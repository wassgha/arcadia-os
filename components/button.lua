local Focusable = require("components.focusable")
local IconStore = require("lib.icon_store")

Button = setmetatable({}, {
    __index = Focusable
})
Button.__index = Button

-- Constructor for the Menu class
function Button:new(label, size, variant, padding, icon)
    local instance = setmetatable(Focusable.new(variant), self)

    -- Initialize the menu properties
    instance.label = label or ""
    instance.icon = icon or nil
    instance.padding = padding
    instance.size = size
    instance.font = love.graphics.newFont("font.ttf", size)
    instance.variant = variant or Variant.PRIMARY
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()

    return instance
end

-- Render the button on the screen
function Button:draw(x, y)
    love.graphics.setFont(self.font)

    local startX = x
    local startY = y
    local radius = 8

    local iconSize = self.icon and self.size or 0
    local iconGap = self.icon and 12 or 0

    local buttonWidth = self.font:getWidth(self.label) + iconSize + iconGap
    local buttonHeight = self.font:getHeight(self.label) + self.font:getDescent(self.label)

    Focusable.draw(self, startX, startY, buttonWidth, buttonHeight, self.padding)

    -- Draw the leading icon if provided
    if self.icon then
        local icon = IconStore.loadIcon("pixelarticons/light/" .. self.icon)
        local scaleFactor = iconSize / icon.getWidth(icon)
        if icon then
            love.graphics
                .draw(icon, startX, startY + buttonHeight / 2 - iconSize / 2, 0, scaleFactor, scaleFactor, 0, 0)
        end
    end

    -- Draw the button label
    love.graphics.printf(self.label, startX + iconSize + iconGap, startY, self.screenWidth, "left")
end

return Button
