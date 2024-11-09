local Focusable = require('components.focusable')

Button = setmetatable({}, Focusable)
Button.__index = Button
Button.__name = 'Button'

function Button:new(props)
    local instance = Focusable.new(self, props)
    instance.style = instance.props.style or {}
    instance.gap = instance.props.gap or 12
    return instance
end

function Button:render()
    Focusable.render(self)
end

function Button:root()
    local props = self.props or {}
    local state = self.state or {}
    local gap = self.gap or self.props.gap or 12
    local width = props.width
    local height = props.height

    local leading = props.leading
    local label = props.label

    local children = {}

    if props.leading then
        table.insert(children, Image:new({
            color = state.focused and arcadia.theme.bg or arcadia.theme.text,
            key = 'button-leading-' .. props.key,
            size = props.size,
            src = props.leading
        }))
    end

    if props.label then
        table.insert(children, Text:new({
            key = 'button-label-' .. props.key,
            style = {
                color = state.focused and arcadia.theme.bg or arcadia.theme.text
            },
            size = props.size,
            text = label
        }))
    end

    return Focusable:new(table.join(props or {}, {
        key = 'button-' .. props.key,
        style = table.join(props.style or {}, {
            width = width,
            height = height
        }),
        gap = gap,
        horizontal = true,
        children = children
    }))
end

return Button
