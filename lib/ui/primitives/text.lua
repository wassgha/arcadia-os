local Component = require('lib.ui.primitives.component')

Text = setmetatable({}, Component)
Text.__index = Text
Text.__name = 'Text'

function Text:new(props)
    return Component.new(self, props)
end

function Text:render()
    Component.render(self, function()
    end, function()
        love.graphics.setLineStyle('rough')
        love.graphics.setFont(self.font)
        love.graphics.setColor(self.color)
        love.graphics.printf(self.text, 0,
            math.floor(self.component.layout.height / 2 - self.textHeight / 2 - self.textDescent / 2),
            math.floor(self.textWidth), "left")
    end)
end

function Text:root()
    local props = self.props or {}
    local state = self.state or {}
    local style = props.style or {}
    local size = props.size or 14
    self.text = props.text or ''
    self.color = style.color or arcadia.theme.text
    self.font = love.graphics.newFont("font.ttf", size)
    self.textWidth = self.font:getWidth(self.text)
    self.textHeight = self.font:getHeight(self.text)
    self.textAscent = self.font:getAscent(self.text)
    self.textDescent = self.font:getDescent(self.text)

    return View:new({
        style = table.join(props.style or {}, {
            width = self.textWidth,
            height = self.textHeight
        })
    })
end

return Text
