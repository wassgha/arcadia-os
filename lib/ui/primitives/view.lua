View = {}
View.__index = View

-- Helper function to draw a rounder rectangle mask
local function roundedRectangle(x, y, width, height, radius)
    love.graphics.arc("fill", x + radius, y + radius, radius, math.pi, 1.5 * math.pi) -- top-left corner
    love.graphics.arc("fill", x + width - radius, y + radius, radius, 1.5 * math.pi, 2 * math.pi) -- top-right corner
    love.graphics.arc("fill", x + radius, y + height - radius, radius, 0.5 * math.pi, math.pi) -- bottom-left corner
    love.graphics.arc("fill", x + width - radius, y + height - radius, radius, 0, 0.5 * math.pi) -- bottom-right corner
    love.graphics.rectangle("fill", x + radius, y, width - 2 * radius, height) -- top/bottom straight sections
    love.graphics.rectangle("fill", x, y + radius, width, height - 2 * radius) -- left/right straight sections
end

function View:new(props)
    local instance = setmetatable({}, self)
    instance.state = {}
    instance.children = props.children or {}
    local style = props.style or {}
    instance.margin = type(style.margin) == 'table' and style.margin or {style.margin or 0, style.margin or 0}
    instance.padding = type(style.padding) == 'table' and style.padding or {style.padding or 0, style.padding or 0}
    instance.radius = style.radius or 0
    instance.top = style.top or 0
    instance.left = style.left or 0
    instance.backgroundColor = style.backgroundColor or arcadia.theme.transparent
    instance.borderColor = style.borderColor or arcadia.theme.transparent
    instance.borderWidth = style.borderWidth or 0
    instance.width = style.width or props.width or 0
    instance.height = style.height or props.height or 0
    instance.gap = props.gap or 0
    instance.direction = props.horizontal and 'horizontal' or 'vertical'
    instance.position = style.position or 'relative'
    instance.overflow = style.overflow or 'visible'
    instance.layout = {
        top = instance.top or 0,
        left = instance.left or 0,
        padding = instance.padding,
        margin = instance.margin,
        width = instance.width + instance.padding[1] * 2,
        height = instance.height + instance.padding[2] * 2
    }
    instance:root()
    return instance
end

function View:root()
    self.layout = {
        top = self.top or 0,
        left = self.left or 0,
        margin = self.margin,
        padding = self.padding,
        width = self.width + self.padding[1] * 2,
        height = self.height + self.padding[2] * 2
    }

    local maxMainAxis, maxCrossAxis = self.layout.width, self.layout.height
    local totalMainAxis, totalCrossAxis = self.layout.width, self.layout.height
    local curMainAxis, curCrossAxis = self.layout.padding[1] + self.layout.margin[1],
        self.layout.padding[2] + self.layout.margin[2]

    for idx, child in ipairs(self.children) do
        if child.root then
            child.component = child:root()
        end

        if child.layout and child.position ~= 'absolute' then
            local childWidth = child.layout.width + child.layout.margin[1] * 2 +
                                   (idx == #self.children and 0 or self.gap)
            local childHeight = child.layout.height + child.layout.margin[2] * 2 +
                                    (idx == #self.children and 0 or self.gap)
            child.layout.top = self.layout.top + curCrossAxis
            child.layout.left = self.layout.left + curMainAxis

            totalMainAxis = totalMainAxis + childWidth
            totalCrossAxis = totalCrossAxis + childHeight
            curMainAxis = curMainAxis + childWidth
            curCrossAxis = curCrossAxis + childHeight

            maxMainAxis = math.max(maxMainAxis, self.padding[1] * 2 + child.layout.width + child.layout.margin[1] * 2)
            maxCrossAxis =
                math.max(maxCrossAxis, self.padding[2] * 2 + child.layout.height + child.layout.margin[2] * 2)
        end
    end

    if self.direction == 'horizontal' then
        self.layout.width = self.width ~= 0 and self.width + self.padding[1] * 2 or totalMainAxis
        self.layout.height = self.height ~= 0 and self.height + self.padding[2] * 2 or maxCrossAxis
    else
        self.layout.width = self.width ~= 0 and self.width + self.padding[1] * 2 or maxMainAxis
        self.layout.height = self.height ~= 0 and self.height + self.padding[2] * 2 or totalCrossAxis
    end
end

function View:render(pre, post)
    love.graphics.push()
    love.graphics.translate(self.margin[1], self.margin[2])

    if self.position == 'absolute' or self.position == 'relative' then
        love.graphics.translate(self.left, self.top)
    end

    love.graphics.setColor(self.backgroundColor)

    if self.layout.width > 0 and self.layout.height > 0 then
        love.graphics.rectangle('fill', 0, 0, self.layout.width, self.layout.height, self.radius)
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(self.borderWidth)
        love.graphics.rectangle('line', 0, 0, self.layout.width, self.layout.height, self.radius)
    end

    if pre then
        pre()
    end

    love.graphics.push()
    love.graphics.translate(self.padding[1], self.padding[2])

    if self.children then
        for _, child in ipairs(self.children) do
            if child.render then
                child:render()
            end

            -- Translate items
            if self.direction == 'horizontal' then
                love.graphics.translate(child.layout.width + self.gap, 0)
            else
                love.graphics.translate(0, child.layout.height + self.gap)
            end
        end
    end

    if post then
        post()
    end

    love.graphics.pop()

    love.graphics.pop()
end

return View
