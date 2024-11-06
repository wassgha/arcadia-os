Component = {}
Component.__index = Component

function Component:new(props)
    local instance = setmetatable({}, self)
    instance.props = props or {}
    instance.state = {}
    instance.children = instance.props.children or {}
    instance.component = instance:root()
    instance.layout = instance.component.layout
    return instance
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
