local cloneref = cloneref or function(obj) return obj end

local TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))

local Notify = {}

local Arqel = nil
local Icons = nil
local hui = nil
local NotificationList = {}

function Notify._init(arqelRef, iconsRef, huiRef)
    Arqel = arqelRef
    Icons = iconsRef
    hui = huiRef
end

function Notify.send(title, message, duration, iconType)
    duration = duration or 5
    iconType = iconType or "info"
    local scale = 1
    local width = math.clamp(320 * scale, 260, 380)
    local height = math.clamp(80 * scale, 75, 105)

    local notifGui = Instance.new("ScreenGui")
    notifGui.ResetOnSpawn = false
    notifGui.DisplayOrder = 999999
    notifGui.Parent = hui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(1, width + 20, 1, -15)
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.BackgroundColor3 = Arqel.Theme.Header
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Arqel.Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, 0, 0, 2)
    progressBg.Position = UDim2.new(0, 0, 1, -2)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Arqel.Theme.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg

    local iconSize = height - 35
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, iconSize, 0, iconSize)
    icon.Position = UDim2.new(0, 14, 0.5, -2)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = frame

    local iconMap = {
        success = {"check", Arqel.Theme.Success}, error = {"alert", Arqel.Theme.Error},
        warning = {"alert", Arqel.Theme.Warning}, shield = {"shield", Arqel.Theme.Accent},
        info = {"shield", Arqel.Theme.Accent}, key = {"key", Arqel.Theme.Accent},
        copy = {"copy", Arqel.Theme.Success}, discord = {"discord", Arqel.Theme.Discord},
        close = {"close", Arqel.Theme.Error}
    }

    if iconMap[iconType] then
        icon.Image = Icons.getIcon(iconMap[iconType][1])
        icon.ImageColor3 = iconMap[iconType][2]
    else
        icon.Image = Icons.getLogoIcon()
        icon.ImageColor3 = Arqel.Theme.Text
    end

    local textX = 14 + iconSize + 14

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -(textX + 14), 0, 24)
    titleLabel.Position = UDim2.new(0, textX, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.ArimoBold
    titleLabel.TextSize = math.clamp(15 * scale, 13, 18)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = Arqel.Theme.Text
    titleLabel.Text = title
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -(textX + 14), 0, 22)
    messageLabel.Position = UDim2.new(0, textX, 0, 38)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.ArimoBold
    messageLabel.TextSize = math.clamp(13 * scale, 11, 15)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextColor3 = Arqel.Theme.TextDim
    messageLabel.Text = message
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.Parent = frame

    local id = tick() .. HttpService:GenerateGUID(false)
    table.insert(NotificationList, {id = id, frame = frame, gui = notifGui, height = height})

    local function restack()
        local yOffset = 0
        for i = #NotificationList, 1, -1 do
            local n = NotificationList[i]
            if n and n.frame and n.frame.Parent then
                TweenService:Create(n.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -15, 1, -15 - yOffset)}):Play()
                yOffset = yOffset + n.height + 12
            end
        end
    end

    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -15, 1, -15)}):Play()
    task.wait(0.1)
    restack()

    local function dismiss()
        for i, n in ipairs(NotificationList) do
            if n.id == id then table.remove(NotificationList, i) break end
        end
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, width + 20, frame.Position.Y.Scale, frame.Position.Y.Offset)}):Play()
        task.wait(0.3)
        notifGui:Destroy()
        restack()
    end

    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    task.delay(duration, dismiss)

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = frame
    clickBtn.MouseButton1Click:Connect(dismiss)
end

return Notify