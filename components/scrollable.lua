local Component = require('lib.ui.primitives.component')

Scrollable = setmetatable({}, Component)
Scrollable.__index = Scrollable

local SCROLL_SPEED = 10

function Scrollable:new(props)
    local instance = setmetatable(Component.new(self, props), self)
    instance.offsetX = 0
    instance.offsetY = 0
    instance.targetOffsetY = 0
    instance.scrollPosition = props.scrollPosition or 'auto'
    return instance
end

function Scrollable:render()
    Component.render(self, function()
        love.graphics.push()
        love.graphics.translate(self.offsetX, self.offsetY)
    end, function()
        love.graphics.pop()
    end)
end

function Scrollable:update(dt)
    -- Smoothly move the current offsetY towards the targetOffsetY (scrolling animation)
    self.offsetY = self.offsetY + (self.targetOffsetY - self.offsetY) * math.min(SCROLL_SPEED * dt, 1)
end

function Scrollable:scrollTo(idx)
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
        local childBottom = childTop + child.layout.height
        local containerTop = self.layout.top + self.layout.margin[2] + self.layout.padding[2]
        local containerBottom = containerTop + self.layout.height

        if childTop < containerTop then
            -- Child is above the visible area, align it to the top
            self.targetOffsetY = -(childTop - containerTop)
        elseif childBottom > containerBottom then
            -- Child is below the visible area, align it to the bottom
            self.targetOffsetY = -(childBottom - containerBottom)
        else
            -- Child is within view, no scrolling needed
            self.targetOffsetY = self.offsetY -- Preserve the current offset
        end
    end

end

function Scrollable:root()
    local props = self.props or {}
    local state = self.state or {}
    local horizontal = props.horizontal or false
    local width = props.width
    local height = props.height

    return Highlightable:new({
        style = table.join(props.style or {}, {
            borderColor = arcadia.theme.text,
            borderWidth = 3,
            padding = 4,
            margin = 12,
            radius = 10,
            width = width,
            height = height
        }),
        gap = 12,
        horizontal = horizontal,
        children = props.children or {}
    })
end

return Scrollable
