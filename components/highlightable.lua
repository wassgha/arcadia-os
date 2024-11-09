local Component = require('lib.ui.primitives.component')
require('helpers.pretty')

Highlightable = setmetatable({}, Component)
Highlightable.__index = Highlightable
Highlightable.__name = 'Highlightable'

local Variant = {
    PRIMARY = 'primary',
    SECONDARY = 'secondary',
    TERTIARY = 'tertiary'
}

function Highlightable:new(props)
    return Component.new(self, props)
end

function Highlightable:root()
    local props = self.props or {}
    local state = self.state or {}
    local focused = props.focused or false
    local onTap = props.onTap or function()
        return
    end

    local style = {}
    if props.variant == Variant.PRIMARY then
        style = table.join(style, {
            backgroundColor = focused and arcadia.theme.text or arcadia.theme.bg,
            radius = 8,
            margin = 3
        })
    elseif props.variant == Variant.SECONDARY then
        style = table.join(style, {
            padding = 3,
            radius = 8,
            borderWidth = 3,
            borderColor = focused and arcadia.theme.text or arcadia.theme.transparent,
            backgroundColor = focused and arcadia.theme.bg or arcadia.theme.transparent
        })
    elseif props.variant == Variant.TERTIARY then
        style = table.join(style, {
            padding = 3,
            radius = 8,
            borderWidth = 3,
            borderColor = focused and arcadia.theme.text or arcadia.theme.border
        })
    end

    return View:new(table.join(props or {}, {
        style = table.join(props.style or {}, style),
        horizontal = props.horizontal,
        children = props.children or {}
    }))
end

return Highlightable
