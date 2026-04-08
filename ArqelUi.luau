--[[
 ________   ________   ________   _______    ___        ___  ___   ___     
|\   __  \ |\   __  \ |\   __  \ |\  ___ \  |\  \      |\  \|\  \ |\  \    
\ \  \|\  \\ \  \|\  \\ \  \|\  \\ \   __/| \ \  \     \ \  \\\  \\ \  \   
 \ \   __  \\ \   _  _\\ \  \\\  \\ \  \_|/__\ \  \     \ \  \\\  \\ \  \  
  \ \  \ \  \\ \  \\  \|\ \  \\\  \\ \  \_|\ \\ \  \____ \ \  \\\  \\ \  \ 
   \ \__\ \__\\ \__\\ _\ \ \_____  \\ \_______\\ \_______\\ \_______\\ \__\
    \|__|\|__| \|__|\|__| \|___| \__\\|_______| \|_______| \|_______| \|__|

     Github - https://github.com/Cobruhehe/expert-octo-doodle
     Author: Cobru (Cobruhehe, .cobru)
     License: MIT
]]

repeat task.wait() until game:IsLoaded()

local cloneref = cloneref or function(obj) return obj end
local gethui = gethui or function() return cloneref(game:GetService("CoreGui")) end

local hui = gethui()

if getgenv().ArqelLoaded and hui:FindFirstChild("ArqelKeySystem") then return getgenv().Arqel end
if getgenv().ArqelLoaded and hui:FindFirstChild("ArqelKeylessSystem") then return getgenv().Arqel end
getgenv().ArqelLoaded = true
getgenv().ArqelClosed = false

local BaseURL = "https://raw.githubusercontent.com/Nappypie/redesigned-fishstick/main/Modules/"

local function fetch(module)
    return loadstring(game:HttpGet(BaseURL .. module .. ".luau"))()
end

local Internal = {
    Junkie = nil,
    BlurEffect = nil,
    ValidateFunction = nil,
    IsJunkieMode = false,
    IconsLoaded = false
}

local Arqel = {}

Arqel.Appearance = {
    Title = "Arqel",
    Subtitle = "Enter your key to continue",
    Icon = "rbxassetid://95721401302279",
    IconSize = UDim2.new(0, 30, 0, 30)
}

Arqel.Links = {
    GetKey = "",
    Discord = ""
}

Arqel.Storage = {
    FileName = "Arqel_Key",
    Remember = true,
    AutoLoad = true
}

Arqel.Options = {
    Keyless = nil,
    KeylessUI = false,
    Blur = true,
    Draggable = true
}

Arqel.Theme = {
    Accent = Color3.fromRGB(139, 0, 0),
    AccentHover = Color3.fromRGB(170, 20, 20),
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(20, 20, 20),
    Input = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(120, 120, 120),
    Success = Color3.fromRGB(50, 205, 110),
    Error = Color3.fromRGB(245, 70, 90),
    Warning = Color3.fromRGB(255, 180, 50),
    StatusIdle = Color3.fromRGB(180, 80, 80),
    Discord = Color3.fromRGB(88, 101, 242),
    DiscordHover = Color3.fromRGB(114, 137, 218),
    Divider = Color3.fromRGB(45, 45, 70),
    Pending = Color3.fromRGB(60, 60, 60)
}

Arqel.Callbacks = {
    OnVerify = nil,
    OnSuccess = nil,
    OnFail = nil,
    OnClose = nil
}

Arqel.Changelog = {}

Arqel.Shop = {
    Enabled = false,
    Icon = "",
    Title = "Get Premium Access",
    Subtitle = "Instant delivery • 24/7 support",
    ButtonText = "Buy",
    Link = ""
}

--load modules
local Utils = fetch("Utils")
local FileSystem = fetch("FileSystem")
local Icons = fetch("Icons")
local Notify = fetch("Notify")
local LoadingScreen = fetch("LoadingScreen")
local UI = fetch("UI")
local Auth = fetch("Auth")

--init modules with shared refs
Utils._init(Internal, Arqel)
FileSystem._init(Arqel)
Icons._init(FileSystem, Arqel)
Notify._init(Arqel, Icons, hui)
LoadingScreen._init({Arqel = Arqel, Icons = Icons, FileSystem = FileSystem, Utils = Utils, hui = hui})
UI._init({Arqel = Arqel, Internal = Internal, Icons = Icons, Utils = Utils, Notify = Notify, FileSystem = FileSystem, hui = hui})
Auth._init({
    Arqel = Arqel, Internal = Internal, FileSystem = FileSystem,
    Icons = Icons, Utils = Utils, Notify = Notify,
    LoadingScreen = LoadingScreen,
    BuildKeyUI = UI.BuildKeyUI,
    BuildKeylessUI = UI.BuildKeylessUI
})

function Arqel:Notify(title, message, duration, iconType)
    Notify.send(title, message, duration, iconType)
end

function Arqel:Launch()
    Auth.Launch()
end

function Arqel:LaunchJunkie(config)
    Auth.LaunchJunkie(config)
end

function Arqel:GetSavedKey()
    return FileSystem.loadKey()
end

function Arqel:ClearSavedKey()
    return FileSystem.clearKey()
end

getgenv().Arqel = Arqel
return Arqel