local Menu = require("components.menu")
local Screen = require("lib.screen")
local http = require("socket.http")

local SERVER_URL = "http://10.0.0.122:3000"
local CURRENT_VERSION = "1.0.0"

local TEMP_FILE = "temp.love"

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
    local remote_version_url = SERVER_URL .. "/VERSION"
    local remote_version, code, headers, status = http.request(remote_version_url)
    if code == 200 then
        print("Checked remote, latest version: " .. remote_version)
        if remote_version and remote_version ~= CURRENT_VERSION then
            print("New version available: " .. remote_version)
            download(SERVER_URL .. "/store.love", TEMP_FILE)
            if checkHash() then
                local success, errorMessage = os.rename(TEMP_FILE, "store.love")

                if success then
                    print("File renamed successfully.")
                    return true
                else
                    print("Error renaming file: " .. errorMessage)
                end
            else
                print("Could not verify hash.")
            end
        else
            print("No new updates.")
            return false
        end
    else
        print("Update server down, try again later. Status code:", code)
    end
end

function getRemoteHash()
    local remote_hash_url = SERVER_URL .. "/HASH"
    local hash, code, headers, status = http.request(remote_hash_url)
    if code == 200 then
        print("Checked remote, latest hash: " .. hash)
        return hash
    else
        print("Cloudn't get remote hash")
        return nil
    end
end


function checkHash()
    local file = io.open(TEMP_FILE, "rb")
    if not file then return false end

    local content = file:read("*all")
    file:close()
    
    local local_hash = string.gsub(love.data.encode("string", "hex", love.data.hash('md5', content)), "%s+", "")
    local remote_hash = string.gsub(getRemoteHash(), "%s+", "")
    print("Local hash: " .. local_hash)
    if remote_hash == local_hash then
        return true
    else
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
    if checkForUpdates() then
        love.event.quit('restart')
    end
    self.mgr:switchTo('Home')
end


return UpdateScreen