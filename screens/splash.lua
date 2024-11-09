local Screen = require("lib.screen")

local SplashScreen = setmetatable({}, {
    __index = Screen
})
SplashScreen.__index = SplashScreen

function SplashScreen:new()
    local instance = setmetatable(Screen.new(self), self)
    instance.cubeSize = 0
    instance.maxCubeSize = love.graphics.getHeight() / 2
    instance.cubeSpeed = love.graphics.getHeight() / 2
    instance.rotation = 0
    instance.rotationSpeed = 5
    instance.font = love.graphics.newFont("font.ttf", 20)
    instance.startupScreen = "Home"
    return instance
end

function SplashScreen:load()
    self.startupScreen = arcadia.config:get(ConfigKey.STARTUP_SCREEN) == 'Home' and 'Home' or 'Playground'
end

function SplashScreen:update(dt)
    if self.cubeSize < self.maxCubeSize then
        self.cubeSize = self.cubeSize + self.cubeSpeed * dt
    else
        self.cubeSize = self.maxCubeSize
        arcadia.navigation:switchTo(self.startupScreen)
    end
    self.rotation = self.rotation + self.rotationSpeed * dt
end

function SplashScreen:draw()
    love.graphics.clear(arcadia.theme.bg)
    love.graphics.setFont(self.font)
    love.graphics.setColor(arcadia.theme.text)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(3)
    local cx, cy = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2

    local halfSize = self.cubeSize / 2
    local points = {{-halfSize, -halfSize, -halfSize}, {halfSize, -halfSize, -halfSize},
                    {halfSize, halfSize, -halfSize}, {-halfSize, halfSize, -halfSize}, {-halfSize, -halfSize, halfSize},
                    {halfSize, -halfSize, halfSize}, {halfSize, halfSize, halfSize}, {-halfSize, halfSize, halfSize}}

    local function rotateY(x, z, angle)
        local cosAngle = math.cos(angle)
        local sinAngle = math.sin(angle)
        return x * cosAngle - z * sinAngle, x * sinAngle + z * cosAngle
    end

    for i = 1, #points do
        points[i][1], points[i][3] = rotateY(points[i][1], points[i][3], self.rotation)
    end

    local projectedPoints = {}
    for i, p in ipairs(points) do
        -- Project points only if they are in front of the camera (z > -200)
        local scale = 200 / (200 + p[3])
        local x = cx + p[1] * scale
        local y = cy + p[2] * scale
        table.insert(projectedPoints, {
            x = x,
            y = y,
            valid = scale > 0 and true or false
        })
    end

    local edges = {{1, 2}, {2, 3}, {3, 4}, {4, 1}, {5, 6}, {6, 7}, {7, 8}, {8, 5}, {1, 5}, {2, 6}, {3, 7}, {4, 8}}
    for _, edge in ipairs(edges) do
        local p1 = projectedPoints[edge[1]]
        local p2 = projectedPoints[edge[2]]

        -- Only draw the edge if both points are valid (in front of the camera)
        if p1.valid and p2.valid then
            love.graphics.line(p1.x, p1.y, p2.x, p2.y)
        end
    end

    local text = 'Arcadia © 2024'
    local centerX = love.graphics.getWidth() / 2
    local textWidth, textHeight = self.font:getWidth(text), self.font:getHeight(text)
    love.graphics.printf(text, centerX - textWidth / 2, love.graphics.getHeight() - 2 * textHeight,
        love.graphics.getWidth(), "left")
end

return SplashScreen
