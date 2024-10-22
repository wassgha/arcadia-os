-- button.lua
Button = {}
Button.__index = Button

local State = {
    FOCUSED = 'focused',
    BLURRED = 'blurred',
    ACTIVE = 'active'
}

local Variant = {
    PRIMARY = 'primary',
    SECONDARY = 'secondary',
    TERTIARY = 'tertiary'
}

-- Constructor for the Menu class
function Button:new(label, size, variant, padding)
    local instance = setmetatable({}, Button)

    -- Initialize the menu properties
    instance.label = label or ""
    instance.font = love.graphics.newFont("font.ttf", size)
    instance.padding = padding
    instance.variant = variant or Variant.PRIMARY
    instance.state = State.BLURRED
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance.onSelect = function()
        return
    end

    return instance
end

function Button:onSelect(callback)
    if type(callback) == "function" then
        self.onSelect = callback
    else
        error("Callback must be a function")
    end
end

function Button:focus()
    self.state = State.FOCUSED
end

function Button:blur()
    self.state = State.BLURRED
end

function Button:isFocused()
    return self.state == State.FOCUSED
end

-- Render the menu on the screen
function Button:draw(x, y)
    love.graphics.setFont(self.font)

    local startX = x
    local startY = y
    local paddingX = self.padding
    local paddingY = self.padding
    local radius = 8

    local textWidth = self.font:getWidth(self.label)
    local textHeight = self.font:getHeight(self.label) + self.font:getDescent(self.label)

    love.graphics.setColor(0.9, 0.9, 0.9)
    if self.state == State.FOCUSED then
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(3)
        if self.variant == Variant.PRIMARY then
            love.graphics.rectangle('fill', startX - paddingX, startY - paddingY, textWidth + 2 * paddingX,
                textHeight + 2 * paddingY, radius, radius)
            love.graphics.setColor(0, 0, 0)
        elseif self.variant == Variant.SECONDARY then
            love.graphics.rectangle('line', startX - paddingX, startY - paddingY, textWidth + 2 * paddingX,
                textHeight + 2 * paddingY, radius, radius)
            love.graphics.setColor(1, 1, 1)
        end
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.printf(self.label, startX, startY, self.screenWidth, "left")
end

return Button
