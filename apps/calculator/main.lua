local Calculator = setmetatable({}, {})
Calculator.__index = Calculator

local Operators = {
    ADD = '+',
    SUBTRACT = '-',
    MULTIPLY = '*',
    DIVIDE = '/'
}

function Calculator:new()
    local instance = setmetatable({}, self)
    instance.display = "0"
    instance.currentValue = ""
    instance.operator = nil
    instance.previousValue = nil
    instance.font = love.graphics.newFont("font.ttf", 140)
    return instance
end

function Calculator:reset()
    self.display = "0"
    self.currentValue = ""
    self.operator = nil
    self.previousValue = nil
end

function Calculator:update()
end

function Calculator:updateInput(key)
    if tonumber(key) or key == "0" then
        self.currentValue = self.currentValue .. key
        self.display = self.currentValue
    elseif key == 'X' then
        self.currentValue = self.currentValue:sub(1, -2)
        self.display = self.currentValue == "" and "0" or self.currentValue
    elseif key == "UP" then
        self.currentValue = tostring((tonumber(self.currentValue) or 0) + 1)
        self.display = self.currentValue
    elseif key == "DOWN" then
        self.currentValue = tostring((tonumber(self.currentValue) or 0) - 1)
        self.display = self.currentValue
    end
end

function Calculator:applyOperator(operator)
    if self.previousValue == nil then
        self.previousValue = self.currentValue
    else
        self:calculate()
    end
    self.currentValue = ""
    self.operator = operator
end

function Calculator:calculate()
    if self.operator and self.previousValue and self.currentValue ~= "" then
        local a = tonumber(self.previousValue)
        local b = tonumber(self.currentValue)
        local result

        if self.operator == Operators.ADD then
            result = a + b
        elseif self.operator == Operators.SUBTRACT then
            result = a - b
        elseif self.operator == Operators.MULTIPLY then
            result = a * b
        elseif self.operator == Operators.DIVIDE and b ~= 0 then
            result = a / b
        end

        self.display = tostring(result)
        self.previousValue = result
        self.currentValue = ""
        self.operator = nil
    end
end

function Calculator:keypressed(key)
    if key == "B" then
        screenManager:switchTo("Catalog")
    elseif key == "A" then
        self:calculate()
    elseif key == "Y" then
        self:reset()
    elseif key == "R1" then
        self:applyOperator(Operators.ADD)
    elseif key == "R2" then
        self:applyOperator(Operators.SUBTRACT)
    elseif key == "L1" then
        self:applyOperator(Operators.MULTIPLY)
    elseif key == "L2" then
        self:applyOperator(Operators.DIVIDE)
    else
        self:updateInput(key)
    end
end

function Calculator:draw()
    local centerX, centerY = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2

    love.graphics.clear(0, 0, 0)
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1)

    -- Get the width and height of the display text
    local displayWidth = self.font:getWidth(self.display)
    local displayHeight = self.font:getHeight(self.display)

    -- Draw the display text centered
    love.graphics.printf(self.display, centerX - displayWidth / 2, centerY - displayHeight / 2,
        love.graphics.getWidth(), "left")
    if self.operator then
        love.graphics.printf(self.operator, love.graphics.getWidth() - 86, centerY + displayHeight / 2,
            love.graphics.getWidth(), "left")
    end
end

function Calculator:load()
    ctrls:on(function(key)
        self:keypressed(key)
    end)
end

return Calculator
