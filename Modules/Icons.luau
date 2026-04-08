local Icons = {}

local FileSystem = nil
local Arqel = nil

local DefaultLogoAsset = "rbxassetid://95721401302279"

Icons.IconFiles = {
    key = "lucide--key.png",
    shield = "lucide--shield-minus.png",
    check = "prime--check-square.png",
    copy = "flowbite--clipboard-outline.png",
    discord = "qlementine-icons--discord-16.png",
    alert = "mdi--alert-octagon-outline.png",
    lock = "lucide--user-lock.png",
    loading = "nonicons--loading-16.png",
    close = "material-symbols--dangerous-outline.png",
    changelog = "ant-design--sync-outlined.png",
    logo = "rrjlGmac.png",
    user = "U.png",
    clock = "Clock.png",
    cart = "Cart.png"
}

Icons.FallbackIcons = {
    key = "rbxassetid://96510194465420",
    shield = "rbxassetid://89965059528921",
    check = "rbxassetid://76078495178149",
    copy = "rbxassetid://125851897718493",
    discord = "rbxassetid://83278450537116",
    alert = "rbxassetid://140438367956051",
    lock = "rbxassetid://114355063515473",
    loading = "rbxassetid://116535712789945",
    close = "rbxassetid://6022668916",
    changelog = "rbxassetid://138133190015277",
    logo = "rbxassetid://95721401302279",
    user = "rbxassetid://77400125196692",
    clock = "rbxassetid://87505349362628",
    cart = "rbxassetid://114754518183872"
}

Icons.CachedIcons = {}
Icons.IconBaseURL = "https://raw.githubusercontent.com/Cobruhehe/expert-octo-doodle/main/Icons/"

function Icons._init(fileSystemRef, arqelRef)
    FileSystem = fileSystemRef
    Arqel = arqelRef
end

function Icons.shouldDownloadLogo()
    return Arqel.Appearance.Icon == DefaultLogoAsset
end

function Icons.getIcon(iconName)
    return Icons.CachedIcons[iconName] or Icons.FallbackIcons[iconName]
end

function Icons.getLogoIcon()
    if Arqel.Appearance.Icon == DefaultLogoAsset then return Icons.getIcon("logo") end
    return Arqel.Appearance.Icon
end

function Icons.getShopIcon()
    if Arqel.Shop.Icon == "" then return Icons.getLogoIcon() end
    return Arqel.Shop.Icon
end

function Icons.downloadIcon(iconName)
    if not FileSystem.hasFileSystem() then
        Icons.CachedIcons[iconName] = Icons.FallbackIcons[iconName]
        return false
    end
    local path = FileSystem.getIconPath(Icons.IconFiles, iconName)
    if FileSystem.isIconCached(Icons.IconFiles, iconName) then
        local success = pcall(function() Icons.CachedIcons[iconName] = getcustomasset(path) end)
        if success then return true end
    end
    local success = pcall(function()
        local response = game:HttpGet(Icons.IconBaseURL .. Icons.IconFiles[iconName])
        if #response < 100 then error("Invalid") end
        writefile(path, response)
        Icons.CachedIcons[iconName] = getcustomasset(path)
    end)
    if not success then Icons.CachedIcons[iconName] = Icons.FallbackIcons[iconName] end
    return success
end

function Icons.allIconsCached()
    if not FileSystem.hasFileSystem() then return false end
    local iconNames = {"key", "shield", "check", "copy", "discord", "alert", "lock", "loading", "close", "changelog", "user", "clock", "cart"}
    if Icons.shouldDownloadLogo() then table.insert(iconNames, "logo") end
    for _, name in ipairs(iconNames) do
        if not FileSystem.isIconCached(Icons.IconFiles, name) then return false end
    end
    return true
end

function Icons.loadAllIconsFromCache()
    FileSystem.ensureFolders()
    local iconNames = {"key", "shield", "check", "copy", "discord", "alert", "lock", "loading", "close", "changelog", "user", "clock", "cart"}
    if Icons.shouldDownloadLogo() then table.insert(iconNames, "logo") end
    for _, name in ipairs(iconNames) do Icons.downloadIcon(name) end
end

return Icons