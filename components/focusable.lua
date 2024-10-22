-- focusable.lua
Focusable = {}
Focusable.__index = Focusable

local Variant = {
    PRIMARY = 'primary',
    SECONDARY = 'secondary',
    TERTIARY = 'tertiary'
}

function Focusable:new(variant)
    local instance = setmetatable({}, Focusable)

    instance.variant = variant or Variant.PRIMARY
    instance.focused = false
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance.onPress = function()
        return
    end

    return instance
end

function Focusable:onPress(callback)
    if type(callback) == "function" then
        self.onPress = callback
    else
        error("Callback must be a function")
    end
end

function Focusable:focus()
    self.focused = true
end

function Focusable:blur()
    self.focused = false
end

function Focusable:focused()
    return self.focused
end

function Focusable:draw(x, y, width, height, padding)
    local startX = x
    local startY = y
    local radius = 8
    local paddingX = padding
    local paddingY = padding

    love.graphics.setColor(0.9, 0.9, 0.9)

    if self.focused then
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(3)
        if self.variant == Variant.PRIMARY then
            love.graphics.rectangle('fill', startX - paddingX, startY - paddingY, width + 2 * paddingX,
                height + 2 * paddingY, radius, radius)
            love.graphics.setColor(0, 0, 0)
        elseif self.variant == Variant.SECONDARY or self.variant == Variant.TERTIARY then
            love.graphics.rectangle('line', startX - paddingX, startY - paddingY, width + 2 * paddingX,
                height + 2 * paddingY, radius, radius)
            love.graphics.setColor(1, 1, 1)
        end
    else
        love.graphics.setColor(1, 1, 1)
    end

    if self.variant == Variant.TERTIARY then
        love.graphics.setLineWidth(1)
        love.graphics.setColor(0.4, 0.4, 0.4)
        love.graphics.rectangle('line', startX, startY, width, height, radius / 2, radius / 2)
    end

    -- Render contents
end

return Focusable
