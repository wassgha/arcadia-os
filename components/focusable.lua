-- focusable.lua
Focusable = {}
Focusable.__index = Focusable

Variant = {
    PRIMARY = 'primary',
    SECONDARY = 'secondary',
    TERTIARY = 'tertiary'
}

function Focusable:new()
    local instance = setmetatable({}, Focusable)

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

function Focusable:draw(x, y, width, height, padding, variant)
    local startX = x
    local startY = y
    local radius = 8
    local paddingX = padding
    local paddingY = padding
    local variant = variant or Variant.PRIMARY

    love.graphics.setColor(arcadia.theme.highlight)

    if self.focused then
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(3)
        if variant == Variant.PRIMARY then
            love.graphics.rectangle('fill', startX - paddingX, startY - paddingY, width + 2 * paddingX,
                height + 2 * paddingY, radius, radius)
            love.graphics.setColor(arcadia.theme.bg)
        elseif variant == Variant.SECONDARY or variant == Variant.TERTIARY then
            love.graphics.rectangle('line', startX - paddingX, startY - paddingY, width + 2 * paddingX,
                height + 2 * paddingY, radius, radius)
            love.graphics.setColor(arcadia.theme.text)
        end
    else
        love.graphics.setColor(arcadia.theme.text)
    end

    if variant == Variant.TERTIARY then
        love.graphics.setLineWidth(1)
        love.graphics.setColor(arcadia.theme.focus)
        love.graphics.rectangle('line', startX, startY, width, height, (radius + 2) / 2, (radius + 2) / 2)
    end

    -- Render contents
end

return Focusable
