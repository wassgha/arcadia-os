local Clock = setmetatable({}, {})
Clock.__index = Clock

function Clock:new()
    local instance = setmetatable({}, self)
    instance.currentTime = os.date("%H:%M:%S")
    instance.font = love.graphics.newFont("font.ttf", 80)
    return instance
end

function Clock:update()
    self.currentTime = os.date("%H:%M:%S")
end

function Clock:draw()
    love.graphics.setFont(self.font)
    love.graphics.clear(0.05, 0.05, 0.05)
    -- Set the background color
    love.graphics.clear(0.1, 0.1, 0.1) -- Dark background

    -- Set text color
    love.graphics.setColor(1, 1, 1) -- White text

    -- Get the width and height of the current time text
    local timeWidth = math.ceil(self.font:getWidth(self.currentTime) / 50) * 50
    local timeHeight = self.font:getHeight(self.currentTime)

    -- Calculate the position to center the text
    local x = (love.graphics.getWidth() - timeWidth) / 2
    local y = (love.graphics.getHeight() - timeHeight) / 2

    -- Draw the current time
    love.graphics.printf(self.currentTime, x, y, love.graphics.getWidth(), "left")

    -- Draw decorative elements (optional)
    love.graphics.setColor(1, 0.8, 0) -- Gold color for decoration
    love.graphics.rectangle("fill", x - 10, y + timeHeight + 5, timeWidth + 20, 10) -- Decorative line below time
    love.graphics.setColor(1, 0.5, 0) -- Orange color for border
    love.graphics.rectangle("line", x - 20, y - 20, timeWidth + 40, timeHeight + 40) -- Border around the time
end

function Clock:load()
end

return Clock
