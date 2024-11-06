Config = {}
Config.__index = Config

ConfigKey = {
    DEV_MODE = 'DEV_MODE',
    STARTUP_SCREEN = 'STARTUP_SCREEN',
    THEME_MODE = 'THEME_MODE'
}

function Config:new(filename)
    local instance = setmetatable({}, self)
    instance.filename = filename or "config.bin" -- Default config file
    instance.config = {
        [ConfigKey.DEV_MODE] = false,
        [ConfigKey.STARTUP_SCREEN] = 'Home',
        [ConfigKey.THEME_MODE] = 'DARK'
    } -- Holds user preferences
    return instance
end

-- Load configuration from file
function Config:load()
    if love.filesystem.getInfo(self.filename) then
        local data = love.filesystem.read(self.filename)
        local unpacked = love.data.unpack("s", data)
        local deserialized = self:deserialize(unpacked)
        table.add(self.config, deserialized)
    else
        print("Config file not found, using default settings.")
    end
end

-- Save configuration to file
function Config:save()
    local packedData = love.data.pack("data", "s", self:serialize(self.config))
    love.filesystem.write(self.filename, packedData)
end

-- Get a preference value
function Config:get(key, default)
    if self.config[key] ~= nil then
        return self.config[key]
    else
        return default
    end
end

-- Set a preference value
function Config:set(key, value)
    self.config[key] = value
    self:save()
end

function Config:serialize(tbl, indent)
    local serialized = ""
    for k, v in pairs(tbl) do
        local vType = type(v)
        if vType == "table" then
            serialized = serialized .. string.format("table:%s:%s;", k, self:serialize(v)) -- Serialize nested tables
        else
            serialized = serialized .. string.format("%s:%s:%s;", vType, tostring(k), tostring(v))
        end
    end
    return serialized
end

function Config:deserialize(str)
    local tbl = {}
    for entry in string.gmatch(str, "([^;]+);") do
        local vType, k, v = entry:match("(%a+):([^:]+):(.*)")
        if vType == "table" then
            tbl[k] = self:deserialize(v) -- Recursively deserialize nested tables
        elseif vType == "boolean" then
            tbl[k] = (v == "true")
        elseif vType == "number" then
            tbl[k] = tonumber(v)
        elseif vType == "string" then
            tbl[k] = v
        end
    end
    return tbl
end

return Config
