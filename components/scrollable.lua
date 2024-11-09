local Component = require('lib.ui.primitives.component')

Scrollable = setmetatable({}, Component)
Scrollable.__index = Scrollable
Scrollable.__name = 'Scrollable'

local SCROLL_SPEED = 10

-- Helper function to draw a rounder rectangle mask
local function roundedRectangle(x, y, width, height, radius)
    love.graphics.arc("fill", x + radius, y + radius, radius, math.pi, 1.5 * math.pi) -- top-left corner
    love.graphics.arc("fill", x + width - radius, y + radius, radius, 1.5 * math.pi, 2 * math.pi) -- top-right corner
    love.graphics.arc("fill", x + radius, y + height - radius, radius, 0.5 * math.pi, math.pi) -- bottom-left corner
    love.graphics.arc("fill", x + width - radius, y + height - radius, radius, 0, 0.5 * math.pi) -- bottom-right corner
    love.graphics.rectangle("fill", x + radius, y, width - 2 * radius, height) -- top/bottom straight sections
    love.graphics.rectangle("fill", x, y + radius, width, height - 2 * radius) -- left/right straight sections
end

function Scrollable:new(props)
    local instance = Component.new(self, props)
    instance.offsetX = instance.offsetX or 0
    instance.offsetY = instance.offsetY or 0
    instance.targetOffsetY = instance.targetOffsetY or 0
    instance.scrollPosition = instance.scrollPosition or props.scrollPosition or 'auto'
    instance.style = instance.props.style or {}
    instance.gap = instance.props.gap or 12
    return instance
end

function Scrollable:render()
    Component.render(self, function()
        local function stencilFunction()
            roundedRectangle(0, 0, self.layout.width, self.layout.height, self.props.style.radius or 10)
        end

        love.graphics.stencil(stencilFunction, "replace", 1)
        love.graphics.setStencilTest("greater", 0)

        love.graphics.push()
        love.graphics.translate(self.offsetX, self.offsetY)
    end, function()
        love.graphics.pop()
        love.graphics.setStencilTest()
    end)
end

function Scrollable:update(dt)
    -- Smoothly move the current offsetY towards the targetOffsetY (scrolling animation)
    self.offsetY = self.offsetY + (self.targetOffsetY - self.offsetY) * math.min(SCROLL_SPEED * dt, 1)
end

function Scrollable:scrollTo(idx, animated)
    local children = self.props.children or {}
    local child = children[idx]
    if not child or not child.layout then
        return
    end

    if (self.scrollPosition == 'top') then
        -- Align child to the top of the container
        self.targetOffsetY = -(child.layout.top - (self.layout.top + self.layout.margin[2] + self.layout.padding[2]))
    elseif (self.scrollPosition == 'center') then
        -- Center child within the container
        self.targetOffsetY = -(child.layout.top -
                                 (self.layout.top + self.layout.margin[2] + self.layout.padding[2] +
                                     (self.layout.height - child.layout.height) / 2))
    elseif (self.scrollPosition == 'bottom') then
        -- Align child to the bottom of the container
        self.targetOffsetY = -(child.layout.top -
                                 (self.layout.top + self.layout.margin[2] + self.layout.padding[2] + self.layout.height -
                                     child.layout.height))
    elseif (self.scrollPosition == 'auto') then
        -- Only scroll when the child is about to go out of view
        local childTop = child.layout.top
        local childBottom = childTop + child.layout.height + child.layout.margin[2] + self.gap
        local containerTop = self.layout.top + self.layout.margin[2] + self.layout.padding[2]
        local containerBottom = containerTop + self.layout.height

        if (childTop + self.offsetY) < containerTop then
            -- Child is above the visible area, align it to the top
            self.targetOffsetY = -(childTop - containerTop)
        elseif (childBottom + self.offsetY) > containerBottom then
            -- Child is below the visible area, align it to the bottom
            self.targetOffsetY = -(childBottom - containerBottom)
        else
            -- Child is within view, no scrolling needed
            self.targetOffsetY = self.offsetY -- Preserve the current offset
        end

        if animated ~= nil and animated == false and self.offsetY ~= self.targetOffsetY then
            self.offsetY = self.targetOffsetY
        end
    end

end

function Scrollable:root()
    local props = self.props or {}
    local state = self.state or {}
    local gap = self.gap or self.props.gap or 12
    local horizontal = props.horizontal or false
    local width = props.width
    local height = props.height

    return Focusable:new({
        key = 'scrollable-container-' .. props.key,
        style = table.join(props.style or {}, {
            width = width,
            height = height,
            borderColor = arcadia.theme.text,
            borderWidth = 2,
            padding = 4
        }),
        gap = gap,
        horizontal = horizontal,
        children = props.children or {}
    })
end

return Scrollable
