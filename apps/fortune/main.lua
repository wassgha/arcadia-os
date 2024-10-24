local ImageStore = require("lib.image_store")
local Animation = require("lib.animation")

local Fortune = setmetatable({}, {})
Fortune.__index = Fortune

local background = ImageStore.loadImage("apps/fortune/cover.jpg")
local sprite = ImageStore.loadImage("apps/fortune/sprite.jpg")
local spriteAnimation

local fortunes = {"You will make a valuable discovery.", "An unexpected journey will soon begin.",
                  "Your creativity will open new doors for you.", "You will make a difference in someone’s life.",
                  "An exciting opportunity lies ahead.", "Your hard work will inspire others.",
                  "Change is coming—embrace it with open arms.", "A great adventure is waiting for you.",
                  "Luck is on your side this week.", "You will attract positive energy wherever you go.",
                  "A peaceful mind brings a peaceful life.", "Your ideas will bring you success.",
                  "Something you’ve been waiting for will soon arrive.",
                  "Opportunities will present themselves when you least expect.",
                  "A new chapter in your life is about to begin.", "You will find happiness in unexpected places.",
                  "Your perseverance will lead to great rewards.", "Someone is secretly inspired by you.",
                  "Good fortune is coming your way very soon.", "Your vision will become reality.",
                  "You are destined for greatness—believe it.", "Take the risk—success is closer than you think.",
                  "A new perspective will reveal hidden opportunities.", "You are on the verge of a breakthrough.",
                  "You will soon discover a hidden talent.", "New friends are coming into your life.",
                  "Something you lost will return to you.", "An unexpected event will bring you joy.",
                  "Your patience will bring the reward you seek.", "Good luck follows you wherever you go.",
                  "Your inner strength will carry you through tough times.",
                  "The answer you seek is just around the corner.", "You will gain recognition for your efforts.",
                  "The best is yet to come.", "Your next idea will bring you success.",
                  "A fresh start will bring you new insights.", "Your generosity will bring you new opportunities.",
                  "A close friend will help you achieve your goals.",
                  "You will soon achieve something you’ve been working hard for.",
                  "A new passion will ignite your spirit.", "You will be surrounded by positive energy.",
                  "An important decision will bring you great happiness.",
                  "Someone you admire will offer valuable advice.", "Trust in the journey, and the rewards will come.",
                  "You will find joy in life’s simple pleasures.", "Your greatest strength is yet to be revealed.",
                  "A challenge will test your resolve, but you will succeed.",
                  "Your curiosity will lead you to new opportunities.",
                  "You will soon receive good news from an unexpected source.",
                  "Success is just around the corner—keep going.", "Adventure awaits you in the near future.",
                  "You will soon receive pleasant news.", "Success is within your grasp.",
                  "A surprise gift will come your way.", "Your kindness will lead to unexpected rewards.",
                  "Now is the time to explore new horizons.", "Good fortune will be yours this week.",
                  "Happiness comes to those who wait.", "Trust yourself and success will follow.",
                  "A new friendship will bring joy.", "You will overcome a great challenge.",
                  "Your talents will lead you to prosperity.", "Believe in yourself and others will too.",
                  "Luck favors the bold.", "Your hard work will soon pay off.",
                  "The path to success is paved with determination.", "A new opportunity is on the horizon.",
                  "You will find the answers you seek.", "Love is closer than you think.",
                  "Great things are coming your way.", "Your next adventure will be unforgettable.",
                  "Trust the process, and rewards will follow.", "You will inspire others with your actions.",
                  "A small act of kindness will brighten your day.", "Your dreams are about to take flight.",
                  "Success is a journey, not a destination.", "An unexpected event will change your perspective.",
                  "Good things come to those who believe.", "Your positive energy attracts good fortune.",
                  "Patience will bring you peace.", "Your perseverance will soon be rewarded.",
                  "A creative idea will bring you joy.", "A change of scenery will do you good.",
                  "Trust your instincts; they will guide you well.", "The greatest risk is not taking one.",
                  "Your generosity will bring you happiness.", "A pleasant surprise is in store for you.",
                  "You will soon achieve your heart's desire.", "Success is closer than you think.",
                  "You will accomplish something great this year.", "An exciting adventure is coming your way.",
                  "New beginnings bring new opportunities.", "Good things come to those who act.",
                  "The road to success is always under construction.", "A new challenge will bring you strength.",
                  "Your intuition will guide you to success.", "Happiness comes from embracing the unexpected.",
                  "You are capable of achieving greatness.", "The journey is just as important as the destination.",
                  "Positive thinking will lead to positive outcomes.", "A new relationship will bring you happiness.",
                  "You will turn a dream into reality.", "Your efforts will soon be recognized by many.",
                  "Something unexpected will bring you great joy.", "New possibilities will open up for you.",
                  "You are closer to your goals than you realize.", "Your intuition will lead you to great success.",
                  "A small change will make a big difference.",
                  "Your kindness will create a ripple effect of positivity.",
                  "The next step you take will be life-changing."}
local x = (love.graphics.getWidth()) / 2
local y = (love.graphics.getHeight()) / 2

function Fortune:new()
    local instance = setmetatable({}, self)
    instance.font = love.graphics.newFont("font.ttf", 48)
    return instance
end

function Fortune:update(dt)
    spriteAnimation:update(dt)
end

function Fortune:draw()
    love.graphics.setFont(self.font)

    local box_padding = 20
    local box_margin = 30

    local box_width = love.graphics.getWidth() - box_margin * 2

    local _, wrappedText = self.font:getWrap(self.fortune, box_width - box_padding * 2)
    local box_height = #wrappedText * self.font:getHeight() + box_padding * 2

    local box_x = (love.graphics.getWidth() - box_width) / 2
    local box_y = box_margin

    love.graphics.clear(0.878, 0.769, 0.675)

    -- Draw the placeholder icon if provided
    if background then
        local scaleFactor = (love.graphics.getWidth() / 2) / background.getWidth(background)
        love.graphics.setColor(1, 1, 1, 1)
        spriteAnimation:draw(
            love.graphics.getWidth() - (background.getWidth(background) * scaleFactor) + box_margin * 2,
            love.graphics.getHeight() - (background.getHeight(background) * scaleFactor) + box_margin * 2, 0,
            scaleFactor, scaleFactor, 0, 0)
    end

    -- Draw outer border (2nd border)
    love.graphics.setColor(0.2, 0.2, 0.2) -- Dark grey for outer border
    love.graphics.setLineWidth(6)
    love.graphics.rectangle("line", box_x - 12, box_y - 12, box_width + 24, box_height + 24)

    -- Draw inner border (1st border)
    love.graphics.setColor(0.5, 0.5, 0.5) -- Light grey for inner border
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", box_x - 8, box_y - 8, box_width + 16, box_height + 16)

    -- Draw fortune box (background)
    love.graphics.setColor(0, 0, 0) -- White background
    love.graphics.rectangle("fill", box_x, box_y, box_width, box_height)

    -- Draw the fortune text
    love.graphics.setColor(255, 255, 255) -- Black text
    love.graphics.printf(self.fortune, box_x + box_padding, box_y + box_padding, box_width - box_padding * 2, "center")

end

function Fortune:load()
    math.randomseed(os.time())
    self.fortune = fortunes[math.random(1, #fortunes)]
    spriteAnimation = Animation:new(sprite, 2, 0.3)

    ctrls:on(function(key)
        screenManager:switchTo("Catalog")
        return
    end)
end

return Fortune
