local Button = require("components.button")

Menu = setmetatable({}, Component)
Menu.__index = Menu
Menu.__name = 'Menu'

function Menu:new(props)
    return Component.new(self, props)
end

-- Handle keyboard input for the menu
function Menu:keypressed(key)
    local state = self.state or {}
    local props = self.props or {}
    local selectedIndex = state.selectedIndex or 1
    local items = props.items or {}
    if key == "DOWN" then
        selectedIndex = selectedIndex + 1
        if selectedIndex > #items then
            selectedIndex = 1 -- Loop back to the first item
        end
    elseif key == "UP" then
        selectedIndex = selectedIndex - 1
        if selectedIndex < 1 then
            selectedIndex = #items -- Loop to the last item
        end
    elseif key == "A" then
        if type(items[selectedIndex].onSelect) == "function" then
            items[selectedIndex].onSelect()
        end
    end
    self:setState({
        selectedIndex = selectedIndex
    })
end

function Menu:root()
    local props = self.props or {}
    local state = self.state or {}
    local items = props.items or {}
    local selectedIndex = state.selectedIndex or 1
    local radius = 8
    local size = props.size or 20
    local buttons = {}

    for i, item in ipairs(items) do
        local button = Button:new({
            key = 'menu-item-' .. i,
            label = item.label,
            size = size,
            variant = 'primary',
            focused = i == selectedIndex,
            style = {
                radius = radius,
                padding = size / 4
            },
            leading = item.icon
        })

        table.insert(buttons, button)
    end

    return View:new({
        key = 'menu',
        style = table.join(props.style or {}, {}),
        gap = props.gap or 12,
        children = buttons
    })
end

return Menu
