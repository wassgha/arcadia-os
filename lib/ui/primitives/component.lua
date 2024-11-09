Component = {}
Component.__index = Component
Component.__name = 'Component'

ComponentRegistry = {}

function Component:new(props)
    props = props or {}
    local cachedInstance = ComponentRegistry[self.__name .. (props.key or '')]
    if cachedInstance and
        table.deepEquals(table.omit(cachedInstance.props, {'children'}), table.omit(props, {'children'})) then
        -- if children changed
        if not table.deepEquals(cachedInstance.props.children, props.children) then
            cachedInstance.props = props or {}
            cachedInstance.children = props.children or {}
            cachedInstance.component = cachedInstance.root(cachedInstance)
            cachedInstance.layout = cachedInstance.component.layout
        end
        return cachedInstance
    end
    local instance = setmetatable({}, self)
    instance.props = props or {}
    instance.state = instance:derivedStateFromProps(props) or {}
    instance.children = instance.props.children or {}
    instance.component = instance:root()
    instance.layout = instance.component.layout
    ComponentRegistry[self.__name .. (instance.props.key or '')] = instance
    return instance
end

function Component:derivedStateFromProps(props)
    return {}
end

function Component:setState(newState)
    local resolvedState = newState
    if type(newState) == 'function' then
        resolvedState = newState(self.state)
    end

    for k, v in pairs(resolvedState) do
        self.state[k] = v
    end

    -- Trigger a re-render
    self.component = self:root()
    self.layout = self.component.layout
end

function Component:render(pre, post)
    -- Each component will define its own render logic
    if self.component then
        self.component:render(pre, post)
    end
end

function Component:root()
    return {}
end

function Component:update(dt)
end

return Component
