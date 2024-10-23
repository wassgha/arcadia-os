local Calculator = setmetatable({}, {})
Calculator.__index = Calculator

local Button = {}
Button.__index = Button

function Button:new(label, x, y, width, height, onClick)
    local btn = setmetatable({}, Button)
    btn.label = label
    btn.x = x
    btn.y = y
    btn.width = width
    btn.height = height
    btn.onClick = onClick
    return btn
end

function Button:draw()
    love.graphics.setColor(1, 1, 1) -- White background
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0) -- Black text
    love.graphics.printf(self.label, self.x, self.y + self.height / 4, self.width, "center")
end

function Button:isPressed(mx, my)
    return mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height
end

local currentInput = ""
local buttons = {}
local screenFont

function Calculator:new()
    local instance = setmetatable({}, self)
    instance.currentTime = os.date("%H:%M:%S")
    instance.font = love.graphics.newFont("font.ttf", 80)
    return instance
end

function Calculator:update()
end

function Calculator:draw()
    -- Draw the input display area
    love.graphics.setColor(1, 1, 1) -- White background
    love.graphics.rectangle("fill", 20, 20, love.graphics.getWidth() - 40, 80)
    love.graphics.setColor(0, 0, 0) -- Black text
    love.graphics.setFont(screenFont)
    love.graphics.printf(currentInput, 30, 40, love.graphics.getWidth() - 60, "right")

    -- Draw all buttons
    for _, btn in ipairs(buttons) do
        btn:draw()
    end
end

function Calculator:load()
    -- Set up the font for the calculator display
    screenFont = love.graphics.newFont(32)

    -- Define buttons
    local buttonWidth, buttonHeight = 100, 60
    local xOffset, yOffset = 20, 120
    local gap = 10

    -- Number buttons
    for i = 0, 9 do
        local x = (i % 3) * (buttonWidth + gap) + xOffset
        local y = math.floor(i / 3) * (buttonHeight + gap) + yOffset
        if i == 0 then
            x = xOffset + (buttonWidth + gap) -- Position "0" button at the bottom
            y = y + buttonHeight + gap
        end
        table.insert(buttons, Button:new(tostring(i), x, y, buttonWidth, buttonHeight, function()
            currentInput = currentInput .. tostring(i)
        end))
    end

    -- Operator buttons
    local operators = {"+", "-", "*", "/"}
    for i, op in ipairs(operators) do
        local x = 3 * (buttonWidth + gap) + xOffset -- Right column
        local y = (i - 1) * (buttonHeight + gap) + yOffset
        table.insert(buttons, Button:new(op, x, y, buttonWidth, buttonHeight, function()
            currentInput = currentInput .. op
        end))
    end

    -- Clear button
    table.insert(buttons,
        Button:new("C", xOffset, yOffset + 3 * (buttonHeight + gap) + buttonHeight + gap, buttonWidth, buttonHeight,
            function()
                currentInput = ""
            end))

    -- Equal button
    table.insert(buttons,
        Button:new("=", xOffset + buttonWidth + gap, yOffset + 3 * (buttonHeight + gap) + buttonHeight + gap,
            buttonWidth * 2 + gap, buttonHeight, function()
                local result = load("return " .. currentInput)() -- Unsafe for external inputs!
                if result then
                    currentInput = tostring(result)
                else
                    currentInput = "Error"
                end
            end))
end

return Calculator
