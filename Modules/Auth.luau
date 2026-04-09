local Auth = {}

local Arqel = nil
local Internal = nil
local FileSystem = nil
local Icons = nil
local Utils = nil
local Notify = nil
local LoadingScreen = nil
local BuildKeyUI = nil
local BuildKeylessUI = nil

local SessionID = nil

function Auth._init(deps)
    Arqel = deps.Arqel
    Internal = deps.Internal
    FileSystem = deps.FileSystem
    Icons = deps.Icons
    Utils = deps.Utils
    Notify = deps.Notify
    LoadingScreen = deps.LoadingScreen
    BuildKeyUI = deps.BuildKeyUI
    BuildKeylessUI = deps.BuildKeylessUI
end

local function getSessionKey() return "SCRIPT_KEY_" .. SessionID end
local function getSessionLoaded() return "ArqelLoaded_" .. SessionID end
local function getSessionClosed() return "ArqelClosed_" .. SessionID end

local function setKey(val)
    getgenv()[getSessionKey()] = val
    getgenv().SCRIPT_KEY = val --backwards compat
end

local function getKey()
    return getgenv()[getSessionKey()]
end

local function setClosed(val)
    getgenv()[getSessionClosed()] = val
    getgenv().ArqelClosed = val --backwards compat
end

local function setLoaded(val)
    getgenv()[getSessionLoaded()] = val
    getgenv().ArqelLoaded = val --backwards compat
end

function Auth.validateKey(key, validateFunc)
    if not validateFunc or not key or key == "" then return false end
    local success, result = pcall(validateFunc, key)
    if not success then return false end
    if type(result) == "table" then return result.valid == true end
    if type(result) == "boolean" then return result end
    return false
end

function Auth.handleKeylessSkip()
    setKey("KEYLESS")
    setLoaded(false)
    Notify.send("Access Granted", "Keyless access approved!", 3, "success")
    task.wait(0.3)
    if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
end

function Auth.EnsureIconsReady(callback)
    if Icons.allIconsCached() then
        Icons.loadAllIconsFromCache()
        if callback then callback() end
    else
        LoadingScreen.Show(callback)
    end
end

function Auth.tryAutoLoad()
    if not Arqel.Storage.AutoLoad or not Internal.ValidateFunction then return false end
    local savedKey = FileSystem.loadKey()
    if not savedKey or savedKey == "" then return false end
    Notify.send("Checking", "Validating saved key...", 2, "shield")
    task.wait(0.5)
    if Auth.validateKey(savedKey, Internal.ValidateFunction) then
        setKey(savedKey)
        Notify.send("Welcome Back", "Key validated!", 2, "success")
        if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
        return true
    end
    FileSystem.clearKey()
    Notify.send("Expired", "Saved key is no longer valid", 3, "warning")
    task.wait(1)
    return false
end

function Auth.tryAutoLoadJunkie(checkKeyFn)
    if not Arqel.Storage.AutoLoad then return false end
    local savedKey = FileSystem.loadKey()
    if not savedKey or savedKey == "" then return false end
    Notify.send("Checking", "Validating saved key...", 2, "shield")
    task.wait(0.5)
    local vs, vr = pcall(checkKeyFn, savedKey)
    if vs and vr and vr.valid then
        setKey(savedKey)
        Notify.send("Welcome Back", "Key validated!", 2, "success")
        if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
        return true
    end
    FileSystem.clearKey()
    Notify.send("Expired", "Saved key is no longer valid", 3, "warning")
    task.wait(1)
    return false
end

function Auth.Launch()
    SessionID = game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
    Internal.IsJunkieMode = false
    Internal.ValidateFunction = Arqel.Callbacks.OnVerify

    local existingKey = getKey()
    if existingKey and existingKey ~= "" then
        if existingKey == "KEYLESS" then
            Notify.send("Executed", "Script loaded successfully!", 2, "success")
            if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
            return
        elseif Internal.ValidateFunction and Auth.validateKey(existingKey, Internal.ValidateFunction) then
            Notify.send("Executed", "Script loaded successfully!", 2, "success")
            if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
            return
        end
        setKey(nil)
    end

    setClosed(false)
    setLoaded(true)

    Auth.EnsureIconsReady(function()
        if Arqel.Options.Keyless == true then
            if Arqel.Options.KeylessUI == false then Auth.handleKeylessSkip() return end
            BuildKeylessUI()
            while not getKey() do task.wait(0.1) end
            return
        end
        if Auth.tryAutoLoad() then return end
        BuildKeyUI()
        while not getKey() do task.wait(0.1) end
    end)
end

function Auth.LaunchJunkie(config)
    assert(config and config.Service and config.Identifier and config.Provider, "Config required: Service, Identifier, Provider")
    SessionID = game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
    Internal.IsJunkieMode = true

    local existingKey = getKey()
    if existingKey and existingKey ~= "" then
        Notify.send("Executed", "Script loaded successfully!", 2, "success")
        if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
        return
    end

    setClosed(false)
    setLoaded(true)

    Auth.EnsureIconsReady(function()
        local success, Junkie = pcall(function() return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))() end)
        if not success or not Junkie then
            Notify.send("Error", "Failed to load Junkie SDK", 5, "error")
            return
        end

        Junkie.service = config.Service
        Junkie.identifier = config.Identifier
        Junkie.provider = config.Provider
        Internal.Junkie = Junkie

        if Arqel.Links.GetKey == "" then
            pcall(function() Arqel.Links.GetKey = Junkie.get_key_link() end)
        end

        Internal.ValidateFunction = function(key) return Junkie.check_key(key) end

        if Arqel.Options.Keyless == nil then
            local ks, kr = pcall(function() return Junkie.check_key("KEYLESS") end)
            if ks and kr and kr.valid then
                if Arqel.Options.KeylessUI == false then Auth.handleKeylessSkip() return end
                BuildKeylessUI()
                while not getKey() do task.wait(0.1) end
                return
            end
        elseif Arqel.Options.Keyless == true then
            if Arqel.Options.KeylessUI == false then Auth.handleKeylessSkip() return end
            BuildKeylessUI()
            while not getKey() do task.wait(0.1) end
            return
        end

        if Auth.tryAutoLoadJunkie(Junkie.check_key) then return end
        BuildKeyUI()
        while not getKey() do task.wait(0.1) end
    end)
end

function Auth.getKey() return getKey() end

return Auth
