local Component = require('lib.ui.primitives.component')

Slider = setmetatable({}, Component)
Slider.__index = Slider
Slider.__name = 'Slider'

function Slider:new(props)
    return Component.new(self, props)
end

function Slider:root()
    local props = self.props or {}
    local state = self.state or {}
    local horizontal = props.horizontal or false
    local width = props.width or (horizontal and 100 or 40)
    local height = props.height or (horizontal and 40 or 100)
    local size = arcadia.math.mapClamp(props.value or 0, props.min or 0, props.max or 0, 0,
        horizontal and width or height)

    return View:new({
        style = table.join(props.style or {}, {
            borderColor = arcadia.theme.text,
            borderWidth = 3,
            padding = 4,
            margin = 12,
            radius = 10,
            width = width,
            height = height
        }),
        horizontal = horizontal,
        children = {View:new({
            style = {
                position = 'absolute',
                top = horizontal and 0 or height - size,
                width = horizontal and size or width,
                height = horizontal and height or size,
                backgroundColor = arcadia.theme.text,
                radius = 8
            }
        })}
    })
end

return Slider
