Animation = {}
Animation.__index = Animation

function Animation:new(spriteSheet, frameWidth, frameHeight, numFrames, animationSpeed)
    local this = {
        spriteSheet = spriteSheet,
        frameWidth = frameWidth,
        frameHeight = frameHeight,
        frames = {},
        currentFrame = 1,
        animationTimer = 0,
        animationSpeed = animationSpeed
    }

    for i = 0, numFrames - 1 do
        table.insert(this.frames,
            love.graphics.newQuad(i * frameWidth, 0, frameWidth, frameHeight, spriteSheet:getDimensions()))
    end

    setmetatable(this, self)
    return this
end

function Animation:update(dt)
    self.animationTimer = self.animationTimer + dt

    if self.animationTimer >= self.animationSpeed then
        self.animationTimer = self.animationTimer - self.animationSpeed
        self.currentFrame = self.currentFrame + 1

        if self.currentFrame > #self.frames then
            self.currentFrame = 1
        end
    end
end

function Animation:draw(x, y)
    love.graphics.draw(self.spriteSheet, self.frames[self.currentFrame], x, y)
end
