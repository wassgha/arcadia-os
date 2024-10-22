-- menu.lua

Menu = {}
Menu.__index = Menu

-- Constructor for the Menu class
function Menu:new(items, fontPath, fontSize, spacing, padding)
    local instance = setmetatable({}, Menu)
    
    -- Initialize the menu properties
    instance.items = items or {}
    instance.selectedIndex = 1
    instance.font = love.graphics.newFont(fontPath, fontSize)
    instance.padding = padding
    instance.spacing = spacing or 100 -- Default spacing between items
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance.callback = function () return end
    
    return instance
end

-- Handle keyboard input for the menu
function Menu:keypressed(key)
    if key == "DOWN" then
        self.selectedIndex = self.selectedIndex + 1
        if self.selectedIndex > #self.items then
            self.selectedIndex = 1 -- Loop back to the first item
        end
    elseif key == "UP" then
        self.selectedIndex = self.selectedIndex - 1
        if self.selectedIndex < 1 then
            self.selectedIndex = #self.items -- Loop to the last item
        end
    elseif key == "A" then
        print( "A pressed")
        self.callback(self.selectedIndex)
    end
end

function Menu:onSelect(callback)
    if type(callback) == "function" then
        self.callback = callback
    else
        error("Callback must be a function")
    end
end

-- Render the menu on the screen
function Menu:draw(x, y)    
    love.graphics.setFont(self.font)

    local startX = x
    local startY = y
    local paddingX = self.padding
    local paddingY = self.padding
    local radius = 8
    
    for i, item in ipairs(self.items) do
        local curY = startY + (i - 1) * self.spacing
        local textWidth = self.font:getWidth(item)
        local textHeight = self.font:getHeight(item) + self.font:getDescent(item)
        
        love.graphics.setColor(0.9, 0.9, 0.9)
        if i == self.selectedIndex then
            love.graphics.rectangle('fill', startX - paddingX, curY - paddingY, textWidth + 2 * paddingX, textHeight + 2 * paddingY, radius, radius)
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(item, startX, curY, self.screenWidth, "left")
    end
end

return Menu