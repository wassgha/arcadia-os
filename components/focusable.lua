local Component = require('lib.ui.primitives.component')
require('helpers.pretty')

Focusable = setmetatable({}, Component)
Focusable.__index = Focusable
Focusable.__name = 'Focusable'

local Variant = {
    PRIMARY = 'primary',
    SECONDARY = 'secondary',
    TERTIARY = 'tertiary'
}

function Focusable:new(props)
    return Component.new(self, props)
end

function Focusable:derivedStateFromProps(props)
    return {
        focused = props.focused or false
    }
end

function Focusable:focus()
    self:setState({
        focused = true
    })
end

function Focusable:blur()
    self:setState({
        focused = false
    })
end

function Focusable:focused()
    local state = self.state or {}
    return state.focused or false
end

function Focusable:root()
    local props = self.props or {}
    local state = self.state or {}
    local onPress = props.onPress or function()
        return
    end

    local style = {}
    if props.variant == Variant.PRIMARY then
        style = table.join(style, {
            backgroundColor = state.focused and arcadia.theme.text or arcadia.theme.bg,
            radius = 8,
            margin = 3
        })
    elseif props.variant == Variant.SECONDARY then
        style = table.join(style, {
            padding = 3,
            radius = 8,
            borderWidth = 3,
            borderColor = state.focused and arcadia.theme.text or arcadia.theme.transparent,
            backgroundColor = state.focused and arcadia.theme.bg or arcadia.theme.transparent
        })
    elseif props.variant == Variant.TERTIARY then
        style = table.join(style, {
            padding = 3,
            radius = 8,
            borderWidth = 3,
            borderColor = state.focused and arcadia.theme.text or arcadia.theme.border
        })
    end

    return View:new(table.join(props or {}, {
        style = table.join(props.style or {}, style),
        horizontal = props.horizontal,
        children = props.children or {}
    }))
end

return Focusable
