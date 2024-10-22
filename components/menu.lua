local Button = require("components.button")

-- menu.lua
Menu = {}
Menu.__index = Menu

-- Constructor for the Menu class
function Menu:new(items, size, spacing, padding)
    local instance = setmetatable({}, Menu)

    -- Initialize the menu properties
    instance.items = items or {}
    instance.selectedIndex = 1
    instance.size = size
    instance.padding = padding
    instance.spacing = spacing or 100 -- Default spacing between items
    instance.screenWidth, instance.screenHeight = love.graphics.getDimensions()
    instance.onSelect = function()
        return
    end

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
        print("A pressed")
        if type(self.items[self.selectedIndex].onSelect) == "function" then
            self.items[self.selectedIndex].onSelect()
        end
        self.onSelect(self.selectedIndex)
    end
end

function Menu:onSelect(callback)
    if type(callback) == "function" then
        self.onSelect = callback
    else
        error("Callback must be a function")
    end
end

-- Render the menu on the screen
function Menu:draw(x, y)
    local startX = x
    local startY = y
    local paddingX = self.padding
    local paddingY = self.padding
    local radius = 8

    for i, item in ipairs(self.items) do
        local curY = startY + (i - 1) * self.spacing

        local button = Button:new(item.label, self.size, 'primary', radius)
        if i == self.selectedIndex then
            button:focus()
        else
            button:blur()
        end
        button:draw(startX, curY)
    end
end

return Menu
