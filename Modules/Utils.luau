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

local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))

local Utils = {}

local Internal = nil
local Arqel = nil

function Utils._init(internalRef, arqelRef)
    Internal = internalRef
    Arqel = arqelRef
end

function Utils.isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function Utils.getScale()
    local viewport = workspace.CurrentCamera.ViewportSize
    return math.clamp(math.min(viewport.X, viewport.Y) / 900, 0.65, 1.3)
end

function Utils.getExecutorName()
    local success, name = pcall(identifyexecutor)
    if success and name then return tostring(name) end
    return "Unknown"
end

function Utils.getDeviceType()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local gamepad = UserInputService.GamepadEnabled
    if gamepad and not keyboard and not touch then return "Console"
    elseif touch and not keyboard then return "Mobile"
    elseif keyboard and touch then return "PC & Touch"
    elseif keyboard then return "PC"
    else return "Unknown" end
end

function Utils.getHWID()
    local hwid = nil
    pcall(function() if gethwid then hwid = gethwid() end end)
    if not hwid then pcall(function() if getgenv().HWID then hwid = getgenv().HWID end end) end
    if not hwid then pcall(function() if game.RobloxHWID then hwid = tostring(game.RobloxHWID) end end) end
    if not hwid then
        local player = cloneref(Players.LocalPlayer)
        hwid = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 32)
        if player then hwid = tostring(player.UserId) .. hwid:sub(1, 20) end
    end
    return hwid or "N/A"
end

function Utils.generateHiddenDots(availableWidth, charWidth)
    charWidth = charWidth or 5
    local count = math.floor(availableWidth / charWidth)
    count = math.max(count, 8)
    return string.rep("•", count)
end

function Utils.formatTime12()
    local hour = tonumber(os.date("%H"))
    local min = os.date("%M")
    local sec = os.date("%S")
    local period = "AM"
    if hour >= 12 then period = "PM" end
    if hour > 12 then hour = hour - 12 end
    if hour == 0 then hour = 12 end
    return string.format("%d:%s:%s %s", hour, min, sec, period)
end

function Utils.formatDate()
    return os.date("%b %d, %Y")
end

function Utils.enableBlur()
    if not Arqel.Options.Blur then return end
    local existing = Lighting:FindFirstChild("ArqelKeySystemBlur")
    if existing then existing:Destroy() end
    Internal.BlurEffect = Instance.new("BlurEffect")
    Internal.BlurEffect.Name = "ArqelKeySystemBlur"
    Internal.BlurEffect.Size = 0
    Internal.BlurEffect.Parent = Lighting
    TweenService:Create(Internal.BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = 24}):Play()
end

function Utils.disableBlur()
    if Internal.BlurEffect and Internal.BlurEffect.Parent then
        TweenService:Create(Internal.BlurEffect, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = 0}):Play()
        task.delay(0.3, function()
            if Internal.BlurEffect and Internal.BlurEffect.Parent then
                Internal.BlurEffect:Destroy()
                Internal.BlurEffect = nil
            end
        end)
    else
        local existing = Lighting:FindFirstChild("ArqelKeySystemBlur")
        if existing then existing:Destroy() end
        Internal.BlurEffect = nil
    end
end

function Utils.fullCleanup()
    getgenv().ArqelLoaded = false
    getgenv().ArqelClosed = true
    Utils.disableBlur()
    local hui = gethui()
    local gui1 = hui:FindFirstChild("ArqelKeySystem")
    local gui2 = hui:FindFirstChild("ArqelKeylessSystem")
    local gui3 = hui:FindFirstChild("ArqelLoadingScreen")
    if gui1 then gui1:Destroy() end
    if gui2 then gui2:Destroy() end
    if gui3 then gui3:Destroy() end
end

function Utils.setupDragging(header, main)
    if not Arqel.Options.Draggable then return end
    local dragging, dragStart, startPos, dragInput
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if dragInput == input then dragging = false dragInput = nil end
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif input.UserInputType == Enum.UserInputType.Touch then
            if input == dragInput then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

return Utils