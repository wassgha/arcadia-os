local Menu = require("components.menu")
local Screen = require("lib.screen")
local http = require("socket.http")

local current_version = "1.0.0"

function download(url, savePath)
    local body, code, headers, status = http.request(url)
    if code == 200 then
        local file = io.open(savePath, "wb")
        file:write(body)
        file:close()
        print("File downloaded successfully.")
        return true
    else
        print("Failed to download file. Status code:", code)
        return false
    end
end

function checkForUpdates()
    local remote_version_url = "http://example.com/build.version"
    local remote_version = http.request(remote_version_url)
    if remote_version and remote_version > current_version then
        print("New version available: " .. remote_version)
        return true
    else
        print("No new updates.")
        return false
    end
end


local UpdateScreen = setmetatable({}, { __index = Screen })
UpdateScreen.__index = UpdateScreen

function UpdateScreen:new(mgr, ctrls)
    local instance = setmetatable(Screen.new(self, "Update", mgr, ctrls), self)
    return instance
end

function UpdateScreen:draw()
end

function UpdateScreen:load()
    checkForUpdates()
    download("http://example.com/build.version", "test.love")
end


return UpdateScreen