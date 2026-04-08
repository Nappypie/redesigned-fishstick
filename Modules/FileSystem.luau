local FileSystem = {}

local Arqel = nil
local FolderName = "Arqel"
local IconsFolder = "Icons"

function FileSystem._init(arqelRef)
    Arqel = arqelRef
end

function FileSystem.hasFileSystem()
    return type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"
        and type(makefolder) == "function"
        and type(isfolder) == "function"
end

function FileSystem.getFileName()
    return FolderName .. "/" .. Arqel.Storage.FileName .. ".txt"
end

function FileSystem.getIconPath(iconFiles, iconName)
    return FolderName .. "/" .. IconsFolder .. "/" .. iconFiles[iconName]
end

function FileSystem.ensureFolders()
    if not FileSystem.hasFileSystem() then return false end
    pcall(function()
        if not isfolder(FolderName) then makefolder(FolderName) end
        if not isfolder(FolderName .. "/" .. IconsFolder) then makefolder(FolderName .. "/" .. IconsFolder) end
    end)
    return true
end

function FileSystem.saveKey(key)
    if not FileSystem.hasFileSystem() or not Arqel.Storage.Remember then return false end
    return pcall(function() writefile(FileSystem.getFileName(), key) end)
end

function FileSystem.loadKey()
    if not FileSystem.hasFileSystem() then return nil end
    local ok, content = pcall(function()
        if isfile(FileSystem.getFileName()) then return readfile(FileSystem.getFileName()) end
        return nil
    end)
    if ok and content and content ~= "" then return content end
    return nil
end

function FileSystem.clearKey()
    if not FileSystem.hasFileSystem() then return false end
    return pcall(function() delfile(FileSystem.getFileName()) end)
end

function FileSystem.isIconCached(iconFiles, iconName)
    if not FileSystem.hasFileSystem() then return false end
    local success, result = pcall(function() return isfile(FileSystem.getIconPath(iconFiles, iconName)) end)
    return success and result
end

FileSystem.FolderName = FolderName
FileSystem.IconsFolder = IconsFolder

return FileSystem