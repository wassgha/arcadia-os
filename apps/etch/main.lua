local Etch = setmetatable({}, {})
Etch.__index = Etch

local points = {}
local x = (love.graphics.getWidth()) / 2
local y = (love.graphics.getHeight()) / 2

function Etch:new()
    local instance = setmetatable({}, self)
    return instance
end

function Etch:update()
    dx, dy = arcadia.controls:joystickXY()

    if dx ~= 0 then
        x = x + dx
    end
    if dy ~= 0 then
        y = y + dy
    end

    if dx ~= 0 or dy ~= 0 then
        table.insert(points, {
            x = x,
            y = y
        })
    end
end

function Etch:draw()
    -- Draw the points
    love.graphics.clear(arcadia.theme.bg)
    love.graphics.setColor(arcadia.theme.text)
    for i = 1, #points - 1 do
        love.graphics.line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y)
    end
end

function Etch:load()
    love.graphics.setBackgroundColor(arcadia.theme.bg)
    arcadia.controls:on(function(key)
        if key == 'B' then
            arcadia.navigation:switchTo("Launcher")
            return
        end
        if key == 'A' then
            points = {}
            return
        end
        if key == 'RIGHT' then
            x = x + 1
        elseif key == 'LEFT' then
            x = x - 1
        elseif key == 'UP' then
            y = y - 1
        elseif key == 'DOWN' then
            y = y + 1
        end
        table.insert(points, {
            x = x,
            y = y
        })
    end, true)
end

return Etch
