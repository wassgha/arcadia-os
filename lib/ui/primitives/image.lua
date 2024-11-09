local Component = require('lib.ui.primitives.component')

Image = setmetatable({}, Component)
Image.__index = Image
Image.__name = 'Image'

function Image:new(props)
    return Component.new(self, props)
end

function Image:render()
    local props = self.props or {}
    local size = props.size or 16
    local color = props.color or arcadia.theme.text
    Component.render(self, function()
    end, function()
        -- Draw the leading icon if provided
        if props.src then
            local icon = arcadia.icons.load("pixelarticons/light/" .. props.src)
            local scaleFactor = size / icon.getWidth(icon)
            love.graphics.setColor(color)
            if icon then
                love.graphics.draw(icon, self.component.layout.width / 2 - size / 2,
                    self.component.layout.height / 2 - size / 2, 0, scaleFactor, scaleFactor, 0, 0)
            end
        end
    end)
end

function Image:root()
    local props = self.props or {}
    local state = self.state or {}
    local size = props.size or 16

    return View:new({
        style = table.join(props.style or {}, {
            radius = 10,
            width = size,
            height = size
        })
    })
end

return Image
