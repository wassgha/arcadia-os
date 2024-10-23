local Clock = setmetatable({}, {})
Clock.__index = Clock

local ClockFaces = {
    DIGITAL = 'digital',
    ANALOG = 'analog',
    FLIP = 'flip'
}

function Clock:new()
    local instance = setmetatable({}, self)
    instance.currentTime = os.date("*t")
    instance.font = love.graphics.newFont("font.ttf", 140)
    instance.face = ClockFaces.DIGITAL
    return instance
end

function Clock:update()
    self.currentTime = os.date("*t")
end

function Clock:draw()
    local hour = self.currentTime.hour
    local minute = self.currentTime.min
    local second = self.currentTime.sec

    local centerX, centerY = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2

    if self.face == ClockFaces.DIGITAL then
        love.graphics.setFont(self.font)
        love.graphics.clear(0, 0, 0)

        -- Set text color
        love.graphics.setColor(1, 1, 1) -- White text

        local timeText = string.format("%02d:%02d:%02d", hour, minute, second)

        -- Get the width and height of the current time text
        local timeWidth = self.font:getWidth('88:88:88')
        local timeHeight = self.font:getHeight('88:88:88')

        -- Calculate the position to center the text
        local x = centerX - (timeWidth / 2)
        local y = centerY - (timeHeight / 2)

        -- Draw the current time
        love.graphics.printf(timeText, x, y, love.graphics.getWidth(), "left")
    elseif self.face == ClockFaces.ANALOG then
        local radius = (3 * love.graphics.getHeight() / 4) / 2

        -- Draw analog clock
        love.graphics.setColor(1, 1, 1) -- Reset color to white
        -- Draw analog clock using arcs for each hour
        love.graphics.setLineWidth(5)
        for i = 0, 11 do
            local alpha = (((hour - i) % 12) / 12)
            local angle = math.rad(i * 30 - 90) -- Angle for each hour
            local dotX = centerX + (radius + 10) * math.cos(angle) -- Position X for the dot
            local dotY = centerY + (radius + 10) * math.sin(angle) -- Position Y for the dot
            love.graphics.setColor(alpha, alpha, alpha) -- White color for the dots
            love.graphics.circle("fill", dotX, dotY, 4) -- Draw the dot
        end

        love.graphics.setColor(1, 1, 1) -- Reset color to white

        -- Draw hour hand
        local hourAngle = math.rad((hour % 12) * 30 + (minute / 60) * 30)
        local hourHandLength = radius * 0.5
        love.graphics.setLineStyle('rough')
        love.graphics.setLineJoin("bevel")
        love.graphics.setLineWidth(10)
        love.graphics.line(centerX, centerY, centerX + hourHandLength * math.cos(hourAngle - math.pi / 2),
            centerY + hourHandLength * math.sin(hourAngle - math.pi / 2))

        -- Draw minute hand
        local minuteAngle = math.rad(minute * 6)
        local minuteHandLength = radius * 0.8
        love.graphics.setLineWidth(6)
        love.graphics.line(centerX, centerY, centerX + minuteHandLength * math.cos(minuteAngle - math.pi / 2),
            centerY + minuteHandLength * math.sin(minuteAngle - math.pi / 2))

        -- Draw second hand
        local secondAngle = math.rad(second * 6)
        local secondHandLength = radius * 0.9
        love.graphics.setColor(1, 0, 0) -- Red color for the second hand
        love.graphics.line(centerX, centerY, centerX + secondHandLength * math.cos(secondAngle - math.pi / 2),
            centerY + secondHandLength * math.sin(secondAngle - math.pi / 2))
    elseif self.face == ClockFaces.FLIP then
        love.graphics.push()
        local scaleFactor = 0.7
        love.graphics.scale(scaleFactor, scaleFactor)
        local centerX, centerY = love.graphics.getWidth() / scaleFactor / 2, love.graphics.getHeight() / scaleFactor / 2

        -- Format time components
        local hourString = string.format("%02d", hour)
        local minuteString = string.format("%02d", minute)
        local secondString = string.format("%02d", second)

        -- Draw flip clock face
        local boxWidth = 100
        local boxHeight = 160
        local gap = 10
        local digits = {hourString:sub(1, 1), hourString:sub(2, 2), ":", minuteString:sub(1, 1), minuteString:sub(2, 2),
                        ":", secondString:sub(1, 1), secondString:sub(2, 2)}

        for i, digit in ipairs(digits) do
            love.graphics.setColor(0.1, 0.1, 0.1) -- Dark background for flip boxes
            local x = centerX + (i - 1) * (boxWidth + gap) - (8 * (boxWidth + gap)) / 2 -- Calculate x position
            love.graphics.rectangle("fill", x, centerY - boxHeight / 2, boxWidth, boxHeight) -- Draw the box
            love.graphics.setColor(1, 1, 1) -- White color for numbers
            love.graphics.printf(digit, x + 5, centerY - boxHeight / 2 + 30, boxWidth, "center") -- Draw the digit
            love.graphics.setColor(0, 0, 0) -- Black color for divider
            love.graphics.setLineWidth(4)
            love.graphics.line(x, centerY + 2, x + boxWidth, centerY + 2)
            love.graphics.setColor(0.2, 0.2, 0.2) -- Black color for divider
            love.graphics.setLineWidth(4)
            love.graphics.line(x, centerY - 2, x + boxWidth, centerY - 2)
        end

        love.graphics.pop()
    end
end

function Clock:load()
    ctrls:on(function(key)
        if key == 'B' then
            screenManager:switchTo("Home")
            return
        end
        if key == 'A' then
            if self.face == ClockFaces.DIGITAL then
                self.face = ClockFaces.ANALOG
            elseif self.face == ClockFaces.ANALOG then
                self.face = ClockFaces.FLIP
            elseif self.face == ClockFaces.FLIP then
                self.face = ClockFaces.DIGITAL
            end
            return
        end
    end)
end

return Clock
