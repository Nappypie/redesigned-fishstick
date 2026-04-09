local cloneref = cloneref or function(obj) return obj end

local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local UI = {}

local Arqel = nil
local Internal = nil
local Icons = nil
local Utils = nil
local Notify = nil
local FileSystem = nil
local hui = nil

function UI._init(deps)
    Arqel = deps.Arqel
    Internal = deps.Internal
    Icons = deps.Icons
    Utils = deps.Utils
    Notify = deps.Notify
    FileSystem = deps.FileSystem
    hui = deps.hui
end

local function CreateDoorOverlay(parentFrame, width, height)
    local overlay = Instance.new("Frame")
    overlay.Name = "DoorOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.ClipsDescendants = true
    overlay.ZIndex = 50
    overlay.Parent = parentFrame

    local leftDoor = Instance.new("Frame")
    leftDoor.Name = "LeftDoor"
    leftDoor.Size = UDim2.new(0.5, 0, 1, 0)
    leftDoor.Position = UDim2.new(0, 0, 0, 0)
    leftDoor.BackgroundColor3 = Arqel.Theme.Header
    leftDoor.BorderSizePixel = 0
    leftDoor.ZIndex = 51
    leftDoor.Parent = overlay

    local rightDoor = Instance.new("Frame")
    rightDoor.Name = "RightDoor"
    rightDoor.Size = UDim2.new(0.5, 0, 1, 0)
    rightDoor.Position = UDim2.new(0.5, 0, 0, 0)
    rightDoor.BackgroundColor3 = Arqel.Theme.Header
    rightDoor.BorderSizePixel = 0
    rightDoor.ZIndex = 51
    rightDoor.Parent = overlay

    local logoSize = math.min(width, height) * 0.28
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "DoorLogo"
    logoImage.Size = UDim2.new(0, logoSize, 0, logoSize)
    logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = Icons.getLogoIcon()
    logoImage.ImageColor3 = Arqel.Theme.Text
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.ZIndex = 54
    logoImage.Parent = overlay

    local halfWidth = math.ceil(width / 2)

    local function openDoors(callback)
        TweenService:Create(logoImage, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {ImageTransparency = 1}):Play()
        task.wait(0.25)
        TweenService:Create(leftDoor, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, -halfWidth, 0, 0)}):Play()
        TweenService:Create(rightDoor, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.45)
        overlay.Visible = false
        if callback then callback() end
    end

    local function closeDoors(callback)
        overlay.Visible = true
        leftDoor.Position = UDim2.new(0, -halfWidth, 0, 0)
        rightDoor.Position = UDim2.new(1, 0, 0, 0)
        logoImage.ImageTransparency = 1
        TweenService:Create(leftDoor, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(rightDoor, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 0)}):Play()
        task.wait(0.38)
        TweenService:Create(logoImage, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {ImageTransparency = 0}):Play()
        task.wait(0.3)
        if callback then callback() end
    end

    return {overlay = overlay, open = openDoors, close = closeDoors}
end

local function CreateChangelogPanel(parent, windowWidth, panelHeight, panelWidth, mainFrame, gap)
    panelWidth = panelWidth or 220
    local isOpen = false

    local panel = Instance.new("Frame")
    panel.Name = "ChangelogPanel"
    panel.Size = UDim2.new(0, 0, 0, panelHeight)
    panel.Position = UDim2.new(1, gap, 0, 0)
    panel.BackgroundColor3 = Arqel.Theme.Background
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Parent = mainFrame
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 4)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Arqel.Theme.Accent
    panelStroke.Thickness = 2
    panelStroke.Transparency = 1

    local panelHeader = Instance.new("Frame")
    panelHeader.Size = UDim2.new(1, 0, 0, 50)
    panelHeader.BackgroundColor3 = Arqel.Theme.Header
    panelHeader.BorderSizePixel = 0
    panelHeader.Parent = panel
    Instance.new("UICorner", panelHeader).CornerRadius = UDim.new(0, 4)

    local panelHeaderFix = Instance.new("Frame")
    panelHeaderFix.Size = UDim2.new(1, 0, 0, 8)
    panelHeaderFix.Position = UDim2.new(0, 0, 1, -8)
    panelHeaderFix.BackgroundColor3 = Arqel.Theme.Header
    panelHeaderFix.BorderSizePixel = 0
    panelHeaderFix.Parent = panelHeader

    local panelHeaderLine = Instance.new("Frame")
    panelHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    panelHeaderLine.Position = UDim2.new(0, 0, 1, 0)
    panelHeaderLine.BackgroundColor3 = Arqel.Theme.Accent
    panelHeaderLine.BackgroundTransparency = 0.6
    panelHeaderLine.BorderSizePixel = 0
    panelHeaderLine.Parent = panelHeader

    local panelHeaderIcon = Instance.new("ImageLabel")
    panelHeaderIcon.Size = UDim2.new(0, 16, 0, 16)
    panelHeaderIcon.Position = UDim2.new(0, 12, 0.5, 0)
    panelHeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    panelHeaderIcon.BackgroundTransparency = 1
    panelHeaderIcon.Image = Icons.getIcon("changelog")
    panelHeaderIcon.ImageColor3 = Arqel.Theme.Accent
    panelHeaderIcon.ScaleType = Enum.ScaleType.Fit
    panelHeaderIcon.Parent = panelHeader

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -65, 1, 0)
    panelTitle.Position = UDim2.new(0, 34, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "Changelog"
    panelTitle.TextColor3 = Arqel.Theme.Text
    panelTitle.TextSize = 16
    panelTitle.Font = Enum.Font.ArimoBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelHeader

    local panelClose = Instance.new("ImageButton")
    panelClose.Size = UDim2.new(0, 20, 0, 20)
    panelClose.Position = UDim2.new(1, -14, 0.5, 0)
    panelClose.AnchorPoint = Vector2.new(1, 0.5)
    panelClose.BackgroundTransparency = 1
    panelClose.Image = Icons.getIcon("close")
    panelClose.ImageColor3 = Arqel.Theme.TextDim
    panelClose.ScaleType = Enum.ScaleType.Fit
    panelClose.Parent = panelHeader
    panelClose.MouseEnter:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    panelClose.MouseLeave:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -55)
    scrollFrame.Position = UDim2.new(0, 0, 0, 55)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Arqel.Theme.Accent
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = panel

    local scrollPadding = Instance.new("UIPadding", scrollFrame)
    scrollPadding.PaddingLeft = UDim.new(0, 10)
    scrollPadding.PaddingRight = UDim.new(0, 10)
    scrollPadding.PaddingTop = UDim.new(0, 5)
    scrollPadding.PaddingBottom = UDim.new(0, 5)

    local contentLayout = Instance.new("UIListLayout", scrollFrame)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for i, update in ipairs(Arqel.Changelog) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, 0, 0, 0)
        entry.AutomaticSize = Enum.AutomaticSize.Y
        entry.BackgroundTransparency = 1
        entry.LayoutOrder = i * 2
        entry.Parent = scrollFrame

        local entryLayout = Instance.new("UIListLayout", entry)
        entryLayout.Padding = UDim.new(0, 5)

        local versionLabel = Instance.new("TextLabel")
        versionLabel.Size = UDim2.new(1, 0, 0, 22)
        versionLabel.BackgroundTransparency = 1
        versionLabel.Text = update.Version .. "  •  " .. update.Date
        versionLabel.TextColor3 = Arqel.Theme.Accent
        versionLabel.TextSize = 14
        versionLabel.Font = Enum.Font.ArimoBold
        versionLabel.TextXAlignment = Enum.TextXAlignment.Left
        versionLabel.LayoutOrder = 1
        versionLabel.Parent = entry

        for j, change in ipairs(update.Changes) do
            local changeLabel = Instance.new("TextLabel")
            changeLabel.Size = UDim2.new(1, 0, 0, 0)
            changeLabel.AutomaticSize = Enum.AutomaticSize.Y
            changeLabel.BackgroundTransparency = 1
            changeLabel.Text = "  •  " .. change
            changeLabel.TextColor3 = Arqel.Theme.TextDim
            changeLabel.TextSize = 12
            changeLabel.Font = Enum.Font.ArimoBold
            changeLabel.TextXAlignment = Enum.TextXAlignment.Left
            changeLabel.TextWrapped = true
            changeLabel.LayoutOrder = j + 1
            changeLabel.Parent = entry
        end

        if i < #Arqel.Changelog then
            local divWrapper = Instance.new("Frame")
            divWrapper.Size = UDim2.new(1, 0, 0, 2)
            divWrapper.BackgroundTransparency = 1
            divWrapper.LayoutOrder = i * 2 + 1
            divWrapper.Parent = scrollFrame

            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 2)
            div.BackgroundColor3 = Arqel.Theme.Divider
            div.BorderSizePixel = 0
            div.Parent = divWrapper
        end
    end

    local function toggle(changelogIcon, container, currentContainerWidth)
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, panelWidth, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, currentContainerWidth + gap + panelWidth, 0, panelHeight)}):Play()
            if changelogIcon then TweenService:Create(changelogIcon, TweenInfo.new(0.3), {Rotation = 180}):Play() end
        else
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, currentContainerWidth, 0, panelHeight)}):Play()
            if changelogIcon then TweenService:Create(changelogIcon, TweenInfo.new(0.3), {Rotation = 0}):Play() end
        end
    end

    panelClose.MouseButton1Click:Connect(function() if isOpen then toggle(nil, parent, windowWidth) end end)
    return panel, toggle, function() return isOpen end, panelWidth
end

local function CreateUserInfoPanel(parent, windowWidth, panelHeight, panelWidth, mainFrame, gap, startOpen)
    panelWidth = panelWidth or 180
    local isOpen = startOpen or false
    local isCompact = panelHeight < 300
    local avatarSize = isCompact and 42 or 55
    local fieldHeight = isCompact and 24 or 28
    local titleSize = isCompact and 8 or 9
    local valueSize = isCompact and 10 or 11
    local welcomeSize = isCompact and 11 or 12
    local spacing = isCompact and 3 or 5

    local panel = Instance.new("Frame")
    panel.Name = "UserInfoPanel"
    panel.Size = UDim2.new(0, isOpen and panelWidth or 0, 0, panelHeight)
    panel.Position = UDim2.new(0, -(gap), 0, 0)
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.BackgroundColor3 = Arqel.Theme.Background
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Parent = mainFrame
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 4)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Arqel.Theme.Accent
    panelStroke.Thickness = 2
    panelStroke.Transparency = isOpen and 0.4 or 1

    local panelHeader = Instance.new("Frame")
    panelHeader.Size = UDim2.new(1, 0, 0, 50)
    panelHeader.BackgroundColor3 = Arqel.Theme.Header
    panelHeader.BorderSizePixel = 0
    panelHeader.Parent = panel
    Instance.new("UICorner", panelHeader).CornerRadius = UDim.new(0, 4)

    local panelHeaderFix = Instance.new("Frame")
    panelHeaderFix.Size = UDim2.new(1, 0, 0, 8)
    panelHeaderFix.Position = UDim2.new(0, 0, 1, -8)
    panelHeaderFix.BackgroundColor3 = Arqel.Theme.Header
    panelHeaderFix.BorderSizePixel = 0
    panelHeaderFix.Parent = panelHeader

    local panelHeaderLine = Instance.new("Frame")
    panelHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    panelHeaderLine.Position = UDim2.new(0, 0, 1, 0)
    panelHeaderLine.BackgroundColor3 = Arqel.Theme.Accent
    panelHeaderLine.BackgroundTransparency = 0.6
    panelHeaderLine.BorderSizePixel = 0
    panelHeaderLine.Parent = panelHeader

    local panelHeaderIcon = Instance.new("ImageLabel")
    panelHeaderIcon.Size = UDim2.new(0, 16, 0, 16)
    panelHeaderIcon.Position = UDim2.new(0, 12, 0.5, 0)
    panelHeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    panelHeaderIcon.BackgroundTransparency = 1
    panelHeaderIcon.Image = Icons.getIcon("user")
    panelHeaderIcon.ImageColor3 = Arqel.Theme.Accent
    panelHeaderIcon.ScaleType = Enum.ScaleType.Fit
    panelHeaderIcon.Parent = panelHeader

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -65, 1, 0)
    panelTitle.Position = UDim2.new(0, 34, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "User Info"
    panelTitle.TextColor3 = Arqel.Theme.Text
    panelTitle.TextSize = 16
    panelTitle.Font = Enum.Font.ArimoBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelHeader

    local panelClose = Instance.new("ImageButton")
    panelClose.Size = UDim2.new(0, 20, 0, 20)
    panelClose.Position = UDim2.new(1, -14, 0.5, 0)
    panelClose.AnchorPoint = Vector2.new(1, 0.5)
    panelClose.BackgroundTransparency = 1
    panelClose.Image = Icons.getIcon("close")
    panelClose.ImageColor3 = Arqel.Theme.TextDim
    panelClose.ScaleType = Enum.ScaleType.Fit
    panelClose.Parent = panelHeader
    panelClose.MouseEnter:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    panelClose.MouseLeave:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -55)
    contentFrame.Position = UDim2.new(0, 0, 0, 55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = panel

    local contentPadding = Instance.new("UIPadding", contentFrame)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)

    local contentLayout = Instance.new("UIListLayout", contentFrame)
    contentLayout.Padding = UDim.new(0, spacing)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local player = cloneref(Players.LocalPlayer)

    local avatarWrapper = Instance.new("Frame")
    avatarWrapper.Size = UDim2.new(0, avatarSize + 6, 0, avatarSize + 6)
    avatarWrapper.BackgroundTransparency = 1
    avatarWrapper.LayoutOrder = 1
    avatarWrapper.Parent = contentFrame

    local avatarGlow = Instance.new("Frame")
    avatarGlow.Size = UDim2.new(1, 0, 1, 0)
    avatarGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarGlow.BackgroundColor3 = Arqel.Theme.Accent
    avatarGlow.BackgroundTransparency = 0.5
    avatarGlow.BorderSizePixel = 0
    avatarGlow.Parent = avatarWrapper
    Instance.new("UICorner", avatarGlow).CornerRadius = UDim.new(0, 4)

    local avatarGlowStroke = Instance.new("UIStroke", avatarGlow)
    avatarGlowStroke.Color = Arqel.Theme.Accent
    avatarGlowStroke.Thickness = 1.5
    avatarGlowStroke.Transparency = 0.3

    local avatarContainer = Instance.new("Frame")
    avatarContainer.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    avatarContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarContainer.BackgroundColor3 = Arqel.Theme.Input
    avatarContainer.BorderSizePixel = 0
    avatarContainer.ClipsDescendants = true
    avatarContainer.Parent = avatarWrapper
    Instance.new("UICorner", avatarContainer).CornerRadius = UDim.new(0, 4)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ScaleType = Enum.ScaleType.Crop
    avatarImage.Parent = avatarContainer
    pcall(function()
        local content = Players:GetUserThumbnailAsync(player and player.UserId or 0, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatarImage.Image = content
    end)

    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, 0, 0, isCompact and 14 or 18)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "Welcome, " .. (player and player.DisplayName or "User")
    welcomeLabel.TextColor3 = Arqel.Theme.Text
    welcomeLabel.TextSize = welcomeSize
    welcomeLabel.Font = Enum.Font.ArimoBold
    welcomeLabel.TextTruncate = Enum.TextTruncate.AtEnd
    welcomeLabel.LayoutOrder = 2
    welcomeLabel.Parent = contentFrame

    local divider1 = Instance.new("Frame")
    divider1.Size = UDim2.new(1, 16, 0, 2)
    divider1.Position = UDim2.new(0.5, 0, 0, 0)
    divider1.AnchorPoint = Vector2.new(0.5, 0)
    divider1.BackgroundColor3 = Arqel.Theme.Divider
    divider1.BorderSizePixel = 0
    divider1.LayoutOrder = 3
    divider1.Parent = contentFrame

    local executorContainer = Instance.new("Frame")
    executorContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    executorContainer.BackgroundTransparency = 1
    executorContainer.LayoutOrder = 4
    executorContainer.Parent = contentFrame

    local executorTitle = Instance.new("TextLabel")
    executorTitle.Size = UDim2.new(1, 0, 0, 11)
    executorTitle.BackgroundTransparency = 1
    executorTitle.Text = "Executor"
    executorTitle.TextColor3 = Arqel.Theme.TextDim
    executorTitle.TextSize = titleSize
    executorTitle.Font = Enum.Font.ArimoBold
    executorTitle.TextXAlignment = Enum.TextXAlignment.Left
    executorTitle.Parent = executorContainer

    local executorValue = Instance.new("TextLabel")
    executorValue.Size = UDim2.new(1, 0, 0, 14)
    executorValue.Position = UDim2.new(0, 0, 0, 11)
    executorValue.BackgroundTransparency = 1
    executorValue.Text = Utils.getExecutorName()
    executorValue.TextColor3 = Arqel.Theme.Accent
    executorValue.TextSize = valueSize
    executorValue.Font = Enum.Font.ArimoBold
    executorValue.TextXAlignment = Enum.TextXAlignment.Left
    executorValue.TextTruncate = Enum.TextTruncate.AtEnd
    executorValue.Parent = executorContainer

    local deviceContainer = Instance.new("Frame")
    deviceContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    deviceContainer.BackgroundTransparency = 1
    deviceContainer.LayoutOrder = 5
    deviceContainer.Parent = contentFrame

    local deviceTitle = Instance.new("TextLabel")
    deviceTitle.Size = UDim2.new(1, 0, 0, 11)
    deviceTitle.BackgroundTransparency = 1
    deviceTitle.Text = "Device"
    deviceTitle.TextColor3 = Arqel.Theme.TextDim
    deviceTitle.TextSize = titleSize
    deviceTitle.Font = Enum.Font.ArimoBold
    deviceTitle.TextXAlignment = Enum.TextXAlignment.Left
    deviceTitle.Parent = deviceContainer

    local deviceValue = Instance.new("TextLabel")
    deviceValue.Size = UDim2.new(1, 0, 0, 14)
    deviceValue.Position = UDim2.new(0, 0, 0, 11)
    deviceValue.BackgroundTransparency = 1
    deviceValue.Text = Utils.getDeviceType()
    deviceValue.TextColor3 = Arqel.Theme.Accent
    deviceValue.TextSize = valueSize
    deviceValue.Font = Enum.Font.ArimoBold
    deviceValue.TextXAlignment = Enum.TextXAlignment.Left
    deviceValue.TextTruncate = Enum.TextTruncate.AtEnd
    deviceValue.Parent = deviceContainer

    local divider2 = Instance.new("Frame")
    divider2.Size = UDim2.new(1, 16, 0, 2)
    divider2.Position = UDim2.new(0.5, 0, 0, 0)
    divider2.AnchorPoint = Vector2.new(0.5, 0)
    divider2.BackgroundColor3 = Arqel.Theme.Divider
    divider2.BorderSizePixel = 0
    divider2.LayoutOrder = 6
    divider2.Parent = contentFrame

    local hwidContainer = Instance.new("Frame")
    hwidContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    hwidContainer.BackgroundTransparency = 1
    hwidContainer.LayoutOrder = 7
    hwidContainer.Parent = contentFrame

    local hwidTitle = Instance.new("TextLabel")
    hwidTitle.Size = UDim2.new(1, 0, 0, 11)
    hwidTitle.BackgroundTransparency = 1
    hwidTitle.Text = "HWID"
    hwidTitle.TextColor3 = Arqel.Theme.TextDim
    hwidTitle.TextSize = titleSize
    hwidTitle.Font = Enum.Font.ArimoBold
    hwidTitle.TextXAlignment = Enum.TextXAlignment.Left
    hwidTitle.Parent = hwidContainer

    local fullHWID = Utils.getHWID()
    local copyBtnSize = 18
    local dotAreaWidth = panelWidth - 16 - copyBtnSize - 6
    local hiddenDots = Utils.generateHiddenDots(dotAreaWidth, 5)

    local hwidValue = Instance.new("TextLabel")
    hwidValue.Size = UDim2.new(1, -(copyBtnSize + 6), 0, 14)
    hwidValue.Position = UDim2.new(0, 0, 0, 11)
    hwidValue.BackgroundTransparency = 1
    hwidValue.Text = hiddenDots
    hwidValue.TextColor3 = Arqel.Theme.TextDim
    hwidValue.TextSize = isCompact and 9 or 10
    hwidValue.Font = Enum.Font.ArimoBold
    hwidValue.TextXAlignment = Enum.TextXAlignment.Left
    hwidValue.TextTruncate = Enum.TextTruncate.AtEnd
    hwidValue.Parent = hwidContainer

    local copyBtn = Instance.new("ImageButton")
    copyBtn.Size = UDim2.new(0, copyBtnSize, 0, copyBtnSize)
    copyBtn.Position = UDim2.new(1, 0, 0.5, 1)
    copyBtn.AnchorPoint = Vector2.new(1, 0.5)
    copyBtn.BackgroundTransparency = 1
    copyBtn.Image = Icons.getIcon("copy")
    copyBtn.ImageColor3 = Arqel.Theme.TextDim
    copyBtn.ScaleType = Enum.ScaleType.Fit
    copyBtn.Parent = hwidContainer
    copyBtn.MouseEnter:Connect(function() TweenService:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Accent}):Play() end)
    copyBtn.MouseLeave:Connect(function() TweenService:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)
    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(fullHWID) end)
        TweenService:Create(copyBtn, TweenInfo.new(0.1), {ImageColor3 = Arqel.Theme.Success}):Play()
        task.delay(0.3, function() TweenService:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)
        Notify.send("Copied", "HWID copied to clipboard", 2, "copy")
    end)

    local divider3 = Instance.new("Frame")
    divider3.Size = UDim2.new(1, 16, 0, 2)
    divider3.Position = UDim2.new(0.5, 0, 0, 0)
    divider3.AnchorPoint = Vector2.new(0.5, 0)
    divider3.BackgroundColor3 = Arqel.Theme.Divider
    divider3.BorderSizePixel = 0
    divider3.LayoutOrder = 8
    divider3.Parent = contentFrame

    local clockContainer = Instance.new("Frame")
    clockContainer.Size = UDim2.new(1, 0, 0, isCompact and 30 or 38)
    clockContainer.BackgroundTransparency = 1
    clockContainer.LayoutOrder = 9
    clockContainer.Parent = contentFrame

    local clockRow = Instance.new("Frame")
    clockRow.Size = UDim2.new(1, 0, 0, isCompact and 18 or 22)
    clockRow.Position = UDim2.new(0.5, -8, 0, 0)
    clockRow.AnchorPoint = Vector2.new(0.5, 0)
    clockRow.BackgroundTransparency = 1
    clockRow.Parent = clockContainer

    local clockRowLayout = Instance.new("UIListLayout", clockRow)
    clockRowLayout.FillDirection = Enum.FillDirection.Horizontal
    clockRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    clockRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    clockRowLayout.Padding = UDim.new(0, isCompact and 4 or 6)

    local clockIcon = Instance.new("ImageLabel")
    clockIcon.Size = UDim2.new(0, isCompact and 14 or 16, 0, isCompact and 14 or 16)
    clockIcon.BackgroundTransparency = 1
    clockIcon.Image = Icons.getIcon("clock")
    clockIcon.ImageColor3 = Arqel.Theme.Accent
    clockIcon.ScaleType = Enum.ScaleType.Fit
    clockIcon.LayoutOrder = 1
    clockIcon.Parent = clockRow

    local clockTimeLabel = Instance.new("TextLabel")
    clockTimeLabel.Size = UDim2.new(0, 0, 1, 0)
    clockTimeLabel.AutomaticSize = Enum.AutomaticSize.X
    clockTimeLabel.BackgroundTransparency = 1
    clockTimeLabel.Text = Utils.formatTime12()
    clockTimeLabel.TextColor3 = Arqel.Theme.Accent
    clockTimeLabel.TextSize = isCompact and 14 or 16
    clockTimeLabel.Font = Enum.Font.ArimoBold
    clockTimeLabel.LayoutOrder = 2
    clockTimeLabel.Parent = clockRow

    local clockDateLabel = Instance.new("TextLabel")
    clockDateLabel.Size = UDim2.new(1, 0, 0, isCompact and 12 or 14)
    clockDateLabel.Position = UDim2.new(0, -8, 0, isCompact and 18 or 22)
    clockDateLabel.BackgroundTransparency = 1
    clockDateLabel.Text = Utils.formatDate()
    clockDateLabel.TextColor3 = Arqel.Theme.TextDim
    clockDateLabel.TextSize = isCompact and 9 or 11
    clockDateLabel.Font = Enum.Font.ArimoBold
    clockDateLabel.TextXAlignment = Enum.TextXAlignment.Center
    clockDateLabel.Parent = clockContainer

    local clockRunning = true
    task.spawn(function()
        while clockRunning do
            if not clockTimeLabel or not clockTimeLabel.Parent then clockRunning = false break end
            clockTimeLabel.Text = Utils.formatTime12()
            clockDateLabel.Text = Utils.formatDate()
            task.wait(1)
        end
    end)
    panel.Destroying:Connect(function() clockRunning = false end)

    local function toggle(userIcon, container, baseWidth)
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, panelWidth, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, baseWidth + gap + panelWidth, 0, panelHeight)}):Play()
        else
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, baseWidth, 0, panelHeight)}):Play()
        end
    end

    panelClose.MouseButton1Click:Connect(function() if isOpen then toggle(nil, parent, windowWidth) end end)
    return panel, toggle, function() return isOpen end, panelWidth
end

local function BuildCenteredUI(windowWidth, windowHeight, panelHeight, userPanelWidth, changelogPanelWidth, gap, buildContent)
    local gui = buildContent.gui

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, windowWidth, 0, panelHeight)
    container.Position = UDim2.new(0.5, 0, 1.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Parent = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    mainFrame.Position = UDim2.new(0.5, 0, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.BackgroundColor3 = Arqel.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = container
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 4)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Arqel.Theme.Accent
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.4

    local userPanel, toggleUserPanel, isUserOpen, userPanelActualWidth = CreateUserInfoPanel(container, windowWidth, panelHeight, userPanelWidth, mainFrame, gap, false)
    local changelogPanel, toggleChangelog, isChangelogOpen, changelogPanelActualWidth = CreateChangelogPanel(container, windowWidth, panelHeight, changelogPanelWidth, mainFrame, gap)

    local function getContainerWidth()
        local w = windowWidth
        if isUserOpen() then w = w + gap + userPanelActualWidth end
        if isChangelogOpen() then w = w + gap + changelogPanelActualWidth end
        return w
    end

    local function toggleUser(userIcon)
        local currentW = getContainerWidth()
        if isUserOpen() then toggleUserPanel(userIcon, container, currentW - gap - userPanelActualWidth)
        else toggleUserPanel(userIcon, container, currentW) end
    end

    local function toggleCL(changelogIcon)
        local currentW = getContainerWidth()
        if isChangelogOpen() then toggleChangelog(changelogIcon, container, currentW - gap - changelogPanelActualWidth)
        else toggleChangelog(changelogIcon, container, currentW) end
    end

    local function closeAllPanels(userIcon, changelogIcon, callback)
        if isChangelogOpen() then toggleCL(changelogIcon) task.wait(0.35) end
        if isUserOpen() then toggleUser(userIcon) task.wait(0.35) end
        if callback then callback() end
    end

    return {
        container = container, mainFrame = mainFrame, mainStroke = mainStroke,
        toggleUser = toggleUser, toggleCL = toggleCL,
        isUserOpen = isUserOpen, isChangelogOpen = isChangelogOpen,
        closeAllPanels = closeAllPanels
    }
end

local function closeDoorsThenExit(ui, userIcon, changelogIcon, doors, callback)
    ui.closeAllPanels(userIcon, changelogIcon, function()
        doors.close(function() task.wait(0.3) if callback then callback() end end)
    end)
end

function UI.BuildKeylessUI()
    local oldGui = hui:FindFirstChild("ArqelKeylessSystem")
    if oldGui then oldGui:Destroy() end
    local oldGui2 = hui:FindFirstChild("ArqelKeySystem")
    if oldGui2 then oldGui2:Destroy() end

    Utils.enableBlur()

    local mobile = Utils.isMobile()
    local padding = 14
    local windowWidth = 300
    local windowHeight = 265
    local userPanelWidth = 165
    local changelogPanelWidth = 200
    local gap = 12

    local gui = Instance.new("ScreenGui")
    gui.Name = "ArqelKeylessSystem"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = hui

    local ui = BuildCenteredUI(windowWidth, windowHeight, windowHeight, userPanelWidth, changelogPanelWidth, gap, {gui = gui})
    local container = ui.container
    local main = ui.mainFrame
    local mainStroke = ui.mainStroke

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Arqel.Theme.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.Parent = main
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 8)
    headerFix.Position = UDim2.new(0, 0, 1, -8)
    headerFix.BackgroundColor3 = Arqel.Theme.Header
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, 0)
    headerLine.BackgroundColor3 = Arqel.Theme.Accent
    headerLine.BackgroundTransparency = 0.6
    headerLine.BorderSizePixel = 0
    headerLine.Parent = header

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 30, 0, 30)
    logo.Position = UDim2.new(0, padding, 0.5, 0)
    logo.AnchorPoint = Vector2.new(0, 0.5)
    logo.BackgroundTransparency = 1
    logo.Image = Icons.getLogoIcon()
    logo.ImageColor3 = Arqel.Theme.Text
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, padding + 40, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = Arqel.Appearance.Title
    title.TextColor3 = Arqel.Theme.Text
    title.TextSize = mobile and 24 or 26
    title.Font = Enum.Font.ArimoBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -padding, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = Icons.getIcon("close")
    closeBtn.ImageColor3 = Arqel.Theme.TextDim
    closeBtn.ScaleType = Enum.ScaleType.Fit
    closeBtn.Parent = header
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local contentY = 60

    local successBox = Instance.new("Frame")
    successBox.Size = UDim2.new(0.94, 0, 0, 52)
    successBox.Position = UDim2.new(0.5, 0, 0, contentY)
    successBox.AnchorPoint = Vector2.new(0.5, 0)
    successBox.BackgroundColor3 = Arqel.Theme.Success
    successBox.BackgroundTransparency = 0.85
    successBox.BorderSizePixel = 0
    successBox.Parent = main
    Instance.new("UICorner", successBox).CornerRadius = UDim.new(0, 4)

    local successStroke = Instance.new("UIStroke", successBox)
    successStroke.Color = Arqel.Theme.Success
    successStroke.Thickness = 1
    successStroke.Transparency = 0.5

    local checkIcon = Instance.new("ImageLabel")
    checkIcon.Size = UDim2.new(0, 24, 0, 24)
    checkIcon.Position = UDim2.new(0, 16, 0.5, 0)
    checkIcon.AnchorPoint = Vector2.new(0, 0.5)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Image = Icons.getIcon("check")
    checkIcon.ImageColor3 = Arqel.Theme.Success
    checkIcon.ScaleType = Enum.ScaleType.Fit
    checkIcon.Parent = successBox

    local successText = Instance.new("TextLabel")
    successText.Size = UDim2.new(1, -60, 1, 0)
    successText.Position = UDim2.new(0, 52, 0, 0)
    successText.BackgroundTransparency = 1
    successText.Text = "Access Granted"
    successText.TextColor3 = Arqel.Theme.Success
    successText.TextSize = mobile and 17 or 18
    successText.Font = Enum.Font.ArimoBold
    successText.TextXAlignment = Enum.TextXAlignment.Left
    successText.Parent = successBox

    local keylessText = Instance.new("TextLabel")
    keylessText.Size = UDim2.new(1, 0, 0, 20)
    keylessText.Position = UDim2.new(0.5, 0, 0, contentY + 60)
    keylessText.AnchorPoint = Vector2.new(0.5, 0)
    keylessText.BackgroundTransparency = 1
    keylessText.Text = "Keyless Script"
    keylessText.TextColor3 = Arqel.Theme.TextDim
    keylessText.TextSize = mobile and 14 or 15
    keylessText.Font = Enum.Font.ArimoBold
    keylessText.Parent = main

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 3)
    divider.Position = UDim2.new(0, 0, 0, contentY + 88)
    divider.BackgroundColor3 = Arqel.Theme.Divider
    divider.BorderSizePixel = 0
    divider.Parent = main

    local launchBtn = Instance.new("TextButton")
    launchBtn.Size = UDim2.new(0.75, 0, 0, 42)
    launchBtn.Position = UDim2.new(0.5, 0, 0, contentY + 103)
    launchBtn.AnchorPoint = Vector2.new(0.5, 0)
    launchBtn.BackgroundColor3 = Arqel.Theme.Accent
    launchBtn.BorderSizePixel = 0
    launchBtn.Text = ""
    launchBtn.AutoButtonColor = false
    launchBtn.Parent = main
    Instance.new("UICorner", launchBtn).CornerRadius = UDim.new(0, 4)

    local launchStroke = Instance.new("UIStroke", launchBtn)
    launchStroke.Color = Arqel.Theme.AccentHover
    launchStroke.Thickness = 1
    launchStroke.Transparency = 0.5

    local launchContent = Instance.new("Frame")
    launchContent.Size = UDim2.new(1, 0, 1, 0)
    launchContent.BackgroundTransparency = 1
    launchContent.Parent = launchBtn

    local launchLayout = Instance.new("UIListLayout", launchContent)
    launchLayout.FillDirection = Enum.FillDirection.Horizontal
    launchLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    launchLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    launchLayout.Padding = UDim.new(0, 8)

    local launchIcon = Instance.new("ImageLabel")
    launchIcon.Size = UDim2.new(0, 18, 0, 18)
    launchIcon.BackgroundTransparency = 1
    launchIcon.Image = Icons.getIcon("shield")
    launchIcon.ImageColor3 = Arqel.Theme.Text
    launchIcon.ScaleType = Enum.ScaleType.Fit
    launchIcon.LayoutOrder = 1
    launchIcon.Parent = launchContent

    local launchLabel = Instance.new("TextLabel")
    launchLabel.Size = UDim2.new(0, 0, 0, 18)
    launchLabel.AutomaticSize = Enum.AutomaticSize.X
    launchLabel.BackgroundTransparency = 1
    launchLabel.Text = "Launch Script"
    launchLabel.TextColor3 = Arqel.Theme.Text
    launchLabel.TextSize = mobile and 14 or 15
    launchLabel.Font = Enum.Font.ArimoBold
    launchLabel.LayoutOrder = 2
    launchLabel.Parent = launchContent

    launchBtn.MouseEnter:Connect(function() TweenService:Create(launchBtn, TweenInfo.new(0.15), {BackgroundColor3 = Arqel.Theme.AccentHover}):Play() end)
    launchBtn.MouseLeave:Connect(function() TweenService:Create(launchBtn, TweenInfo.new(0.15), {BackgroundColor3 = Arqel.Theme.Accent}):Play() end)

    local bottomY = contentY + 153

    local userBtn = Instance.new("TextButton")
    userBtn.Size = UDim2.new(0, 36, 0, 36)
    userBtn.Position = UDim2.new(0.5, -44, 0, bottomY)
    userBtn.AnchorPoint = Vector2.new(0.5, 0)
    userBtn.BackgroundColor3 = Arqel.Theme.Background
    userBtn.BorderSizePixel = 0
    userBtn.Text = ""
    userBtn.AutoButtonColor = false
    userBtn.Parent = main
    Instance.new("UICorner", userBtn).CornerRadius = UDim.new(0, 4)

    local userIcon = Instance.new("ImageLabel")
    userIcon.Size = UDim2.new(0, 18, 0, 18)
    userIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    userIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    userIcon.BackgroundTransparency = 1
    userIcon.Image = Icons.getIcon("user")
    userIcon.ImageColor3 = Arqel.Theme.TextDim
    userIcon.ScaleType = Enum.ScaleType.Fit
    userIcon.Parent = userBtn
    userBtn.MouseEnter:Connect(function() TweenService:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Accent}):Play() end)
    userBtn.MouseLeave:Connect(function() TweenService:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0, 36, 0, 36)
    discordBtn.Position = UDim2.new(0.5, 0, 0, bottomY)
    discordBtn.AnchorPoint = Vector2.new(0.5, 0)
    discordBtn.BackgroundColor3 = Arqel.Theme.Background
    discordBtn.BorderSizePixel = 0
    discordBtn.Text = ""
    discordBtn.AutoButtonColor = false
    discordBtn.Parent = main
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 4)

    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Size = UDim2.new(0, 18, 0, 18)
    discordIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    discordIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = Icons.getIcon("discord")
    discordIcon.ImageColor3 = Arqel.Theme.Discord
    discordIcon.ScaleType = Enum.ScaleType.Fit
    discordIcon.Parent = discordBtn
    discordBtn.MouseEnter:Connect(function() TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.DiscordHover}):Play() end)
    discordBtn.MouseLeave:Connect(function() TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Discord}):Play() end)

    local changelogBtn = Instance.new("TextButton")
    changelogBtn.Size = UDim2.new(0, 36, 0, 36)
    changelogBtn.Position = UDim2.new(0.5, 44, 0, bottomY)
    changelogBtn.AnchorPoint = Vector2.new(0.5, 0)
    changelogBtn.BackgroundColor3 = Arqel.Theme.Background
    changelogBtn.BorderSizePixel = 0
    changelogBtn.Text = ""
    changelogBtn.AutoButtonColor = false
    changelogBtn.Parent = main
    Instance.new("UICorner", changelogBtn).CornerRadius = UDim.new(0, 4)

    local changelogIcon = Instance.new("ImageLabel")
    changelogIcon.Size = UDim2.new(0, 18, 0, 18)
    changelogIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    changelogIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    changelogIcon.BackgroundTransparency = 1
    changelogIcon.Image = Icons.getIcon("changelog")
    changelogIcon.ImageColor3 = Arqel.Theme.TextDim
    changelogIcon.ScaleType = Enum.ScaleType.Fit
    changelogIcon.Parent = changelogBtn
    changelogBtn.MouseEnter:Connect(function() TweenService:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Text}):Play() end)
    changelogBtn.MouseLeave:Connect(function() TweenService:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    if #Arqel.Changelog == 0 then
        changelogBtn.Visible = false
        userBtn.Position = UDim2.new(0.5, -22, 0, bottomY)
        discordBtn.Position = UDim2.new(0.5, 22, 0, bottomY)
    end

    local doors = CreateDoorOverlay(main, windowWidth, windowHeight)

    userBtn.MouseButton1Click:Connect(function() ui.toggleUser(userIcon) end)
    changelogBtn.MouseButton1Click:Connect(function() ui.toggleCL(changelogIcon) end)

    closeBtn.MouseButton1Click:Connect(function()
        Notify.send("Goodbye", "See you next time!", 2, "close")
        closeDoorsThenExit(ui, userIcon, changelogIcon, doors, function()
            Utils.fullCleanup()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            task.wait(0.4) gui:Destroy()
        end)
        if Arqel.Callbacks.OnClose then Arqel.Callbacks.OnClose() end
    end)

    launchBtn.MouseButton1Click:Connect(function()
        Notify.send("Launching", "Script loaded successfully!", 2, "success")
        getgenv().SCRIPT_KEY = "KEYLESS"
        getgenv().ArqelLoaded = false
        closeDoorsThenExit(ui, userIcon, changelogIcon, doors, function()
            Utils.disableBlur()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            task.wait(0.4) gui:Destroy()
            if not Internal.IsJunkieMode and Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
        end)
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if Arqel.Links.Discord ~= "" then
            Notify.send("Discord", "Invite link copied!", 2, "discord")
            pcall(function() setclipboard(Arqel.Links.Discord) end)
        end
    end)

    Utils.setupDragging(header, container)
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
    task.wait(0.6)
    doors.open(function()
        checkIcon.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(checkIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24)}):Play()
        task.wait(0.2)
        ui.toggleUser(userIcon)
        if #Arqel.Changelog > 0 then task.wait(0.3) ui.toggleCL(changelogIcon) end
    end)
end

function UI.BuildKeyUI()
    local oldGui = hui:FindFirstChild("ArqelKeySystem")
    if oldGui then oldGui:Destroy() end
    local oldGui2 = hui:FindFirstChild("ArqelKeylessSystem")
    if oldGui2 then oldGui2:Destroy() end

    Utils.enableBlur()

    local mobile = Utils.isMobile()
    local scale = Utils.getScale()
    local padding = 14
    local showShop = Arqel.Shop.Enabled
    local shopHeight = 52
    local shopDividerHeight = 1
    local shopExtra = showShop and (shopHeight + shopDividerHeight) or 0
    local baseWindowHeight = mobile and math.clamp(360 * scale, 320, 400) or 360
    local windowWidth = mobile and math.clamp(400 * scale, 320, 440) or 400
    local windowHeight = baseWindowHeight + shopExtra
    local elementHeight = mobile and math.clamp(56 * scale, 48, 62) or 56
    local buttonHeight = mobile and math.clamp(42 * scale, 38, 48) or 42
    local statusHeight = mobile and math.clamp(60 * scale, 52, 68) or 60
    local userPanelWidth = 180
    local changelogPanelWidth = 220
    local gap = 12

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ArqelKeySystem"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = hui

    local ui = BuildCenteredUI(windowWidth, windowHeight, baseWindowHeight, userPanelWidth, changelogPanelWidth, gap, {gui = screenGui})
    local container = ui.container
    local mainFrame = ui.mainFrame
    local mainStroke = ui.mainStroke

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Arqel.Theme.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.Parent = mainFrame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 6)
    headerFix.Position = UDim2.new(0, 0, 1, -6)
    headerFix.BackgroundColor3 = Arqel.Theme.Header
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, 0)
    headerLine.BackgroundColor3 = Arqel.Theme.Accent
    headerLine.BackgroundTransparency = 0.6
    headerLine.BorderSizePixel = 0
    headerLine.Parent = header

    local logo = Instance.new("ImageLabel")
    logo.Size = Arqel.Appearance.IconSize
    logo.Position = UDim2.new(0, padding, 0.5, 0)
    logo.AnchorPoint = Vector2.new(0, 0.5)
    logo.BackgroundTransparency = 1
    logo.Image = Icons.getLogoIcon()
    logo.ImageColor3 = Arqel.Theme.Text
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = header

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -90, 1, 0)
    titleLabel.Position = UDim2.new(0, padding + Arqel.Appearance.IconSize.X.Offset + 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = Arqel.Appearance.Title
    titleLabel.TextColor3 = Arqel.Theme.Text
    titleLabel.TextSize = mobile and 24 or 26
    titleLabel.Font = Enum.Font.ArimoBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -padding, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = Icons.getIcon("close")
    closeBtn.ImageColor3 = Arqel.Theme.TextDim
    closeBtn.ScaleType = Enum.ScaleType.Fit
    closeBtn.Parent = header
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local contentStartY = 60

    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.94, 0, 0, statusHeight)
    statusFrame.Position = UDim2.new(0.5, 0, 0, contentStartY)
    statusFrame.AnchorPoint = Vector2.new(0.5, 0)
    statusFrame.BackgroundColor3 = Arqel.Theme.Input
    statusFrame.BorderSizePixel = 0
    statusFrame.ClipsDescendants = true
    statusFrame.Parent = mainFrame
    Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 4)

    local statusStroke = Instance.new("UIStroke", statusFrame)
    statusStroke.Color = Arqel.Theme.Accent
    statusStroke.Thickness = 1
    statusStroke.Transparency = 0.8

    local statusIcon = Instance.new("ImageLabel")
    statusIcon.Size = UDim2.new(0, 24, 0, 24)
    statusIcon.Position = UDim2.new(0, 16, 0.5, 0)
    statusIcon.AnchorPoint = Vector2.new(0, 0.5)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Image = Icons.getIcon("lock")
    statusIcon.ImageColor3 = Arqel.Theme.StatusIdle
    statusIcon.ScaleType = Enum.ScaleType.Fit
    statusIcon.Parent = statusFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -60, 1, 0)
    statusLabel.Position = UDim2.new(0, 52, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = Arqel.Appearance.Subtitle
    statusLabel.TextColor3 = Arqel.Theme.StatusIdle
    statusLabel.TextSize = mobile and 17 or 18
    statusLabel.Font = Enum.Font.ArimoBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    statusLabel.Parent = statusFrame

    local inputStartY = contentStartY + statusHeight + 10

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.94, 0, 0, elementHeight)
    inputFrame.Position = UDim2.new(0.5, 0, 0, inputStartY)
    inputFrame.AnchorPoint = Vector2.new(0.5, 0)
    inputFrame.BackgroundColor3 = Arqel.Theme.Input
    inputFrame.BorderSizePixel = 0
    inputFrame.ClipsDescendants = true
    inputFrame.Parent = mainFrame
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 4)

    local inputStroke = Instance.new("UIStroke", inputFrame)
    inputStroke.Color = Arqel.Theme.Accent
    inputStroke.Thickness = 1
    inputStroke.Transparency = 0.7

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -24, 1, 0)
    textBox.Position = UDim2.new(0, 12, 0.5, 0)
    textBox.AnchorPoint = Vector2.new(0, 0.5)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.TextColor3 = Arqel.Theme.Text
    textBox.PlaceholderText = "Enter your key..."
    textBox.PlaceholderColor3 = Arqel.Theme.TextDim
    textBox.TextSize = mobile and 17 or 18
    textBox.Font = Enum.Font.ArimoBold
    textBox.ClearTextOnFocus = false
    textBox.TextTruncate = Enum.TextTruncate.AtEnd
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = inputFrame
    textBox.Focused:Connect(function() TweenService:Create(inputStroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play() end)
    textBox.FocusLost:Connect(function() TweenService:Create(inputStroke, TweenInfo.new(0.15), {Transparency = 0.7}):Play() end)

    local dividerY = inputStartY + elementHeight + 12

    local dividerLine = Instance.new("Frame")
    dividerLine.Size = UDim2.new(1, 0, 0, 3)
    dividerLine.Position = UDim2.new(0, 0, 0, dividerY)
    dividerLine.BackgroundColor3 = Arqel.Theme.Divider
    dividerLine.BorderSizePixel = 0
    dividerLine.Parent = mainFrame

    local acquireStartY = dividerY + 15

    local function createButton(text, iconKey, isPrimary, yPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.75, 0, 0, buttonHeight)
        btn.Position = UDim2.new(0.5, 0, 0, yPos)
        btn.AnchorPoint = Vector2.new(0.5, 0)
        btn.BackgroundColor3 = isPrimary and Arqel.Theme.Accent or Arqel.Theme.Input
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = mainFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = isPrimary and Arqel.Theme.AccentHover or Arqel.Theme.Accent
        btnStroke.Thickness = 1
        btnStroke.Transparency = isPrimary and 0.5 or 0.7

        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.Parent = btn

        local layout = Instance.new("UIListLayout", content)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 8)

        local iconImg = Instance.new("ImageLabel")
        iconImg.Size = UDim2.new(0, 18, 0, 18)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = Icons.getIcon(iconKey)
        iconImg.ImageColor3 = Arqel.Theme.Text
        iconImg.ScaleType = Enum.ScaleType.Fit
        iconImg.LayoutOrder = 1
        iconImg.Parent = content

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 0, 0, 20)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Arqel.Theme.Text
        label.TextSize = mobile and 14 or 15
        label.Font = Enum.Font.ArimoBold
        label.LayoutOrder = 2
        label.Parent = content

        local origColor = btn.BackgroundColor3
        local hoverColor = isPrimary and Arqel.Theme.AccentHover or Arqel.Theme.Accent
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origColor}):Play() end)
        return btn
    end

    local acquireBtn = createButton("Get Key", "key", false, acquireStartY)
    local redeemBtn = createButton("Redeem Key", "shield", true, acquireStartY + buttonHeight + 5)
    local bottomY = acquireStartY + buttonHeight * 2 + 10

    local userBtn = Instance.new("TextButton")
    userBtn.Size = UDim2.new(0, 36, 0, 36)
    userBtn.Position = UDim2.new(0.5, -44, 0, bottomY)
    userBtn.AnchorPoint = Vector2.new(0.5, 0)
    userBtn.BackgroundColor3 = Arqel.Theme.Background
    userBtn.BorderSizePixel = 0
    userBtn.Text = ""
    userBtn.AutoButtonColor = false
    userBtn.Parent = mainFrame
    Instance.new("UICorner", userBtn).CornerRadius = UDim.new(0, 4)

    local userIcon = Instance.new("ImageLabel")
    userIcon.Size = UDim2.new(0, 18, 0, 18)
    userIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    userIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    userIcon.BackgroundTransparency = 1
    userIcon.Image = Icons.getIcon("user")
    userIcon.ImageColor3 = Arqel.Theme.TextDim
    userIcon.ScaleType = Enum.ScaleType.Fit
    userIcon.Parent = userBtn
    userBtn.MouseEnter:Connect(function() TweenService:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Accent}):Play() end)
    userBtn.MouseLeave:Connect(function() TweenService:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0, 36, 0, 36)
    discordBtn.Position = UDim2.new(0.5, 0, 0, bottomY)
    discordBtn.AnchorPoint = Vector2.new(0.5, 0)
    discordBtn.BackgroundColor3 = Arqel.Theme.Background
    discordBtn.BorderSizePixel = 0
    discordBtn.Text = ""
    discordBtn.AutoButtonColor = false
    discordBtn.Parent = mainFrame
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 4)

    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Size = UDim2.new(0, 18, 0, 18)
    discordIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    discordIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = Icons.getIcon("discord")
    discordIcon.ImageColor3 = Arqel.Theme.Discord
    discordIcon.ScaleType = Enum.ScaleType.Fit
    discordIcon.Parent = discordBtn
    discordBtn.MouseEnter:Connect(function() TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.DiscordHover}):Play() end)
    discordBtn.MouseLeave:Connect(function() TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Discord}):Play() end)

    local changelogBtn = Instance.new("TextButton")
    changelogBtn.Size = UDim2.new(0, 36, 0, 36)
    changelogBtn.Position = UDim2.new(0.5, 44, 0, bottomY)
    changelogBtn.AnchorPoint = Vector2.new(0.5, 0)
    changelogBtn.BackgroundColor3 = Arqel.Theme.Background
    changelogBtn.BorderSizePixel = 0
    changelogBtn.Text = ""
    changelogBtn.AutoButtonColor = false
    changelogBtn.Parent = mainFrame
    Instance.new("UICorner", changelogBtn).CornerRadius = UDim.new(0, 4)

    local changelogIcon = Instance.new("ImageLabel")
    changelogIcon.Size = UDim2.new(0, 18, 0, 18)
    changelogIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    changelogIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    changelogIcon.BackgroundTransparency = 1
    changelogIcon.Image = Icons.getIcon("changelog")
    changelogIcon.ImageColor3 = Arqel.Theme.TextDim
    changelogIcon.ScaleType = Enum.ScaleType.Fit
    changelogIcon.Parent = changelogBtn
    changelogBtn.MouseEnter:Connect(function() TweenService:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Text}):Play() end)
    changelogBtn.MouseLeave:Connect(function() TweenService:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    if #Arqel.Changelog == 0 then
        changelogBtn.Visible = false
        userBtn.Position = UDim2.new(0.5, -22, 0, bottomY)
        discordBtn.Position = UDim2.new(0.5, 22, 0, bottomY)
    end

    if showShop then
        local shopDivider = Instance.new("Frame")
        shopDivider.Size = UDim2.new(1, 0, 0, shopDividerHeight)
        shopDivider.Position = UDim2.new(0, 0, 1, -shopHeight - shopDividerHeight)
        shopDivider.BackgroundColor3 = Arqel.Theme.Accent
        shopDivider.BackgroundTransparency = 0.6
        shopDivider.BorderSizePixel = 0
        shopDivider.Parent = mainFrame

        local shopFrame = Instance.new("Frame")
        shopFrame.Size = UDim2.new(1, 0, 0, shopHeight)
        shopFrame.Position = UDim2.new(0, 0, 1, -shopHeight)
        shopFrame.BackgroundColor3 = Arqel.Theme.Header
        shopFrame.BorderSizePixel = 0
        shopFrame.ClipsDescendants = true
        shopFrame.Parent = mainFrame

        local shopCorner = Instance.new("UICorner", shopFrame)
        shopCorner.CornerRadius = UDim.new(0, 4)

        local shopTopFix = Instance.new("Frame")
        shopTopFix.Size = UDim2.new(1, 0, 0, 8)
        shopTopFix.Position = UDim2.new(0, 0, 0, 0)
        shopTopFix.BackgroundColor3 = Arqel.Theme.Header
        shopTopFix.BorderSizePixel = 0
        shopTopFix.Parent = shopFrame

        local shopPadding = 14
        local shopIconSize = 28

        local shopIconWrapper = Instance.new("Frame")
        shopIconWrapper.Size = UDim2.new(0, shopIconSize + 4, 0, shopIconSize + 4)
        shopIconWrapper.Position = UDim2.new(0, shopPadding, 0.5, 0)
        shopIconWrapper.AnchorPoint = Vector2.new(0, 0.5)
        shopIconWrapper.BackgroundColor3 = Arqel.Theme.Accent
        shopIconWrapper.BackgroundTransparency = 0.7
        shopIconWrapper.BorderSizePixel = 0
        shopIconWrapper.Parent = shopFrame
        Instance.new("UICorner", shopIconWrapper).CornerRadius = UDim.new(0, 4)

        local shopIconStroke = Instance.new("UIStroke", shopIconWrapper)
        shopIconStroke.Color = Arqel.Theme.Accent
        shopIconStroke.Thickness = 1
        shopIconStroke.Transparency = 0.5

        local shopIconImg = Instance.new("ImageLabel")
        shopIconImg.Size = UDim2.new(0, shopIconSize, 0, shopIconSize)
        shopIconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        shopIconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        shopIconImg.BackgroundTransparency = 1
        shopIconImg.Image = Icons.getShopIcon()
        shopIconImg.ImageColor3 = Arqel.Theme.Text
        shopIconImg.ScaleType = Enum.ScaleType.Fit
        shopIconImg.Parent = shopIconWrapper

        local buyBtnWidth = 60
        local textStartX = shopPadding + shopIconSize + 4 + 10
        local textAreaWidth = windowWidth - textStartX - buyBtnWidth - shopPadding - 8

        local shopTitle = Instance.new("TextLabel")
        shopTitle.Size = UDim2.new(0, textAreaWidth, 0, 18)
        shopTitle.Position = UDim2.new(0, textStartX, 0, 9)
        shopTitle.BackgroundTransparency = 1
        shopTitle.Text = Arqel.Shop.Title
        shopTitle.TextColor3 = Arqel.Theme.Text
        shopTitle.TextSize = mobile and 13 or 14
        shopTitle.Font = Enum.Font.ArimoBold
        shopTitle.TextXAlignment = Enum.TextXAlignment.Left
        shopTitle.TextTruncate = Enum.TextTruncate.AtEnd
        shopTitle.Parent = shopFrame

        local shopSubtitle = Instance.new("TextLabel")
        shopSubtitle.Size = UDim2.new(0, textAreaWidth, 0, 14)
        shopSubtitle.Position = UDim2.new(0, textStartX, 0, 29)
        shopSubtitle.BackgroundTransparency = 1
        shopSubtitle.Text = Arqel.Shop.Subtitle
        shopSubtitle.TextColor3 = Arqel.Theme.TextDim
        shopSubtitle.TextSize = mobile and 10 or 11
        shopSubtitle.Font = Enum.Font.ArimoBold
        shopSubtitle.TextXAlignment = Enum.TextXAlignment.Left
        shopSubtitle.TextTruncate = Enum.TextTruncate.AtEnd
        shopSubtitle.Parent = shopFrame

        local buyBtn = Instance.new("TextButton")
        buyBtn.Size = UDim2.new(0, buyBtnWidth, 0, 30)
        buyBtn.Position = UDim2.new(1, -shopPadding, 0.5, 0)
        buyBtn.AnchorPoint = Vector2.new(1, 0.5)
        buyBtn.BackgroundColor3 = Arqel.Theme.Accent
        buyBtn.BorderSizePixel = 0
        buyBtn.Text = ""
        buyBtn.AutoButtonColor = false
        buyBtn.Parent = shopFrame
        Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 4)

        local buyBtnStroke = Instance.new("UIStroke", buyBtn)
        buyBtnStroke.Color = Arqel.Theme.AccentHover
        buyBtnStroke.Thickness = 1
        buyBtnStroke.Transparency = 0.5

        local buyContent = Instance.new("Frame")
        buyContent.Size = UDim2.new(1, 0, 1, 0)
        buyContent.BackgroundTransparency = 1
        buyContent.Parent = buyBtn

        local buyLayout = Instance.new("UIListLayout", buyContent)
        buyLayout.FillDirection = Enum.FillDirection.Horizontal
        buyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        buyLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        buyLayout.Padding = UDim.new(0, 5)

        local buyIcon = Instance.new("ImageLabel")
        buyIcon.Size = UDim2.new(0, 14, 0, 14)
        buyIcon.BackgroundTransparency = 1
        buyIcon.Image = Icons.getIcon("cart")
        buyIcon.ImageColor3 = Arqel.Theme.Text
        buyIcon.ScaleType = Enum.ScaleType.Fit
        buyIcon.LayoutOrder = 1
        buyIcon.Parent = buyContent

        local buyLabel = Instance.new("TextLabel")
        buyLabel.Size = UDim2.new(0, 0, 0, 14)
        buyLabel.AutomaticSize = Enum.AutomaticSize.X
        buyLabel.BackgroundTransparency = 1
        buyLabel.Text = Arqel.Shop.ButtonText
        buyLabel.TextColor3 = Arqel.Theme.Text
        buyLabel.TextSize = mobile and 11 or 12
        buyLabel.Font = Enum.Font.ArimoBold
        buyLabel.LayoutOrder = 2
        buyLabel.Parent = buyContent

        buyBtn.MouseEnter:Connect(function() TweenService:Create(buyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Arqel.Theme.AccentHover}):Play() end)
        buyBtn.MouseLeave:Connect(function() TweenService:Create(buyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Arqel.Theme.Accent}):Play() end)
        buyBtn.MouseButton1Click:Connect(function()
            if Arqel.Shop.Link ~= "" then
                pcall(function() setclipboard(Arqel.Shop.Link) end)
                Notify.send("Shop", "Shop link copied to clipboard!", 2, "copy")
            end
        end)
    end

    local doors = CreateDoorOverlay(mainFrame, windowWidth, windowHeight)

    userBtn.MouseButton1Click:Connect(function() ui.toggleUser(userIcon) end)
    changelogBtn.MouseButton1Click:Connect(function() ui.toggleCL(changelogIcon) end)

    local spinConnection, dotsThread

    local function setStatus(state, customText)
        if spinConnection then spinConnection:Disconnect() spinConnection = nil statusIcon.Rotation = 0 end
        if dotsThread then task.cancel(dotsThread) dotsThread = nil end
        local color, icon, text = Arqel.Theme.StatusIdle, Icons.getIcon("lock"), customText or "No key detected"
        if state == "verifying" then
            color, icon, text = Arqel.Theme.Accent, Icons.getIcon("loading"), "Verifying key"
            spinConnection = RunService.Heartbeat:Connect(function(dt)
                if statusIcon and statusIcon.Parent then statusIcon.Rotation = (statusIcon.Rotation + dt * 360) % 360
                else if spinConnection then spinConnection:Disconnect() end end
            end)
            local dots, i = {".", "..", "...", ""}, 1
            dotsThread = task.spawn(function()
                while statusLabel and statusLabel.Parent and statusLabel.Text:find("Verifying", 1, true) do
                    statusLabel.Text = text .. dots[i] i = (i % #dots) + 1 task.wait(0.4)
                end
            end)
        elseif state == "success" then color, icon, text = Arqel.Theme.Success, Icons.getIcon("check"), customText or "Access Granted"
        elseif state == "error" then color, icon, text = Arqel.Theme.Error, Icons.getIcon("alert"), customText or "Invalid Key" end
        TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextColor3 = color}):Play()
        TweenService:Create(statusIcon, TweenInfo.new(0.3), {ImageColor3 = color}):Play()
        statusLabel.Text = text statusIcon.Image = icon
    end

    closeBtn.MouseButton1Click:Connect(function()
        Notify.send("Goodbye", "See you next time!", 2, "close")
        closeDoorsThenExit(ui, userIcon, changelogIcon, doors, function()
            Utils.fullCleanup()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.4) screenGui:Destroy()
            if Arqel.Callbacks.OnClose then Arqel.Callbacks.OnClose() end
        end)
    end)

    local function handleRedeem()
        local key = textBox.Text:gsub("%s+", "")
        if key == "" then Notify.send("Error", "Please enter your key", 3, "warning") return end
        setStatus("verifying") redeemBtn.Active = false task.wait(0.3)
        local valid, errorMsg = false, "Invalid key"
        if Internal.ValidateFunction then
            local success, result, msg = pcall(Internal.ValidateFunction, key)
            if success then
                if type(result) == "table" then
                    valid = result.valid == true
                    local errMsgs = {
                        KEY_INVALID = "Key not found in system", KEY_EXPIRED = "Key has expired",
                        HWID_BANNED = "Hardware banned", KEY_INVALIDATED = "Key was revoked",
                        ALREADY_USED = "One-time key already used", HWID_MISMATCH = "HWID limit reached",
                        SERVICE_NOT_FOUND = "Service not found", SERVICE_MISMATCH = "Wrong service",
                        PREMIUM_REQUIRED = "Premium required", ERROR = "Network error"
                    }
                    local errCode = result.error or "Unknown"
                    errorMsg = errMsgs[errCode] or result.message or errCode
                    if errCode == "HWID_BANNED" then task.delay(2, function() cloneref(Players.LocalPlayer):Kick("Hardware banned") end) end
                elseif type(result) == "boolean" then valid = result errorMsg = msg or "Invalid key" end
            end
        end
        redeemBtn.Active = true
        if valid then
            FileSystem.saveKey(key) getgenv().SCRIPT_KEY = key getgenv().ArqelLoaded = false
            setStatus("success") Notify.send("Success", "Key validated successfully!", 2, "success") task.wait(1)
            closeDoorsThenExit(ui, userIcon, changelogIcon, doors, function()
                Utils.disableBlur()
                TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
                TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                task.wait(0.4) screenGui:Destroy()
                if not Internal.IsJunkieMode and Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
            end)
        else
            setStatus("error", errorMsg) Notify.send("Invalid", errorMsg, 4, "error")
            if Arqel.Callbacks.OnFail then Arqel.Callbacks.OnFail(errorMsg) end
        end
    end

    redeemBtn.MouseButton1Click:Connect(handleRedeem)
    acquireBtn.MouseButton1Click:Connect(function()
        if Arqel.Links.GetKey ~= "" then Notify.send("Copied", "Key link copied!", 3, "copy") pcall(function() setclipboard(Arqel.Links.GetKey) end)
        else Notify.send("Error", "No key link set", 3, "warning") end
    end)
    discordBtn.MouseButton1Click:Connect(function()
        if Arqel.Links.Discord ~= "" then Notify.send("Discord", "Invite link copied!", 2, "discord") pcall(function() setclipboard(Arqel.Links.Discord) end) end
    end)
    textBox.FocusLost:Connect(function(enter) if enter then handleRedeem() end end)

    Utils.setupDragging(header, container)
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
    task.wait(0.6)
    doors.open(function()
        task.wait(0.2)
        ui.toggleUser(userIcon)
        if #Arqel.Changelog > 0 then task.wait(0.3) ui.toggleCL(changelogIcon) end
    end)
end

return UI