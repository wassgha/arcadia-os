Theme = {}
Theme.__index = Theme

ThemeMode = {
    DARK = 'DARK',
    LIGHT = 'LIGHT'
}

function Theme:new(config)
    local instance = setmetatable({}, self)
    instance.config = config
    return instance
end

function Theme:load()
    self.mode = self.config:get(ConfigKey.THEME_MODE) or 'DARK'
    self.dark = self.mode == 'DARK'
    self.bg = self.dark and {0, 0, 0, 1} or {1, 1, 1, 1}
    self.focus = self.dark and {0.4, 0.4, 0.4, 1} or {0.6, 0.6, 0.6, 1}
    self.highlight = self.dark and {0.95, 0.95, 0.95, 1} or {0.1, 0.1, 0.1, 1}
    self.text = self.dark and {1, 1, 1, 1} or {0, 0, 0, 1}
    self.border = self.dark and {0.1, 0.1, 0.1, 1} or {0.9, 0.9, 0.9, 1}
    self.transparent = {0, 0, 0, 0}
end

return Theme
