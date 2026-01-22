# Arqel Key System

A clean, customizable key system UI library for Roblox scripts.

![Version](https://img.shields.io/badge/version-1.0.0-red)
![Platform](https://img.shields.io/badge/platform-Roblox-blue)

---

## Features

- 🔑 Clean key verification UI
- 🚀 Built-in Junkie Development support
- 🎨 Fully customizable theme & colors
- 💾 Auto-save & auto-load keys
- 📱 Mobile responsive
- 🔓 Keyless mode support
- 🔔 Notification system
- 🖱️ Draggable window
- 🌫️ Background blur effect

---

## Installation

```lua
local Arqel = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
## Installation

```lua
local Arqel = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
```

---

## Quick Start

### Junkie Development

```lua
local Arqel = loadstring(game:HttpGet("URL"))()

Arqel.Appearance.Title = "My Script"
Arqel.Links.Discord = "discord.gg/xxx"
Arqel.Storage.FileName = "MyScript_Key"

Arqel:LaunchJunkie({
    Service = "YourService",
    Identifier = "1234",
    Provider = "YourName"
})
```

### Custom Validation

```lua
local Arqel = loadstring(game:HttpGet("URL"))()

Arqel.Appearance.Title = "My Script"
Arqel.Links.GetKey = "yoursite.com/getkey"
Arqel.Links.Discord = "discord.gg/xxx"
Arqel.Storage.FileName = "MyScript_Key"

Arqel.Callbacks.OnVerify = function(key)
    return key == "secretkey123"
end

Arqel.Callbacks.OnSuccess = function()
    print("Loading script...")
end

Arqel:Launch()
```

---

## API Reference

### Arqel.Appearance

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Title` | string | `"Arqel"` | Header title |
| `Subtitle` | string | `"Enter your key to continue"` | Status text |
| `Icon` | string | `""` | Logo asset ID |
| `IconSize` | UDim2 | `UDim2.new(0, 30, 0, 30)` | Logo size |

### Arqel.Links

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `GetKey` | string | `""` | Key acquisition URL |
| `Discord` | string | `""` | Discord invite link |

### Arqel.Storage

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `FileName` | string | `"Arqel_Key"` | Save file name |
| `Remember` | boolean | `true` | Auto-save valid keys |
| `AutoLoad` | boolean | `true` | Try saved key on launch |

### Arqel.Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `Keyless` | nil/boolean | `nil` | `nil` = auto-detect, `true` = force keyless, `false` = require key |
| `Blur` | boolean | `true` | Background blur effect |
| `Draggable` | boolean | `true` | Allow dragging window |

### Arqel.Theme

| Property | Type | Default |
|----------|------|---------|
| `Accent` | Color3 | `RGB(139, 0, 0)` |
| `AccentHover` | Color3 | `RGB(170, 20, 20)` |
| `Background` | Color3 | `RGB(15, 15, 15)` |
| `Header` | Color3 | `RGB(20, 20, 20)` |
| `Input` | Color3 | `RGB(25, 25, 25)` |
| `Text` | Color3 | `RGB(255, 255, 255)` |
| `TextDim` | Color3 | `RGB(120, 120, 120)` |
| `Success` | Color3 | `RGB(50, 205, 110)` |
| `Error` | Color3 | `RGB(245, 70, 90)` |
| `Warning` | Color3 | `RGB(255, 180, 50)` |
| `StatusIdle` | Color3 | `RGB(180, 80, 80)` |
| `Discord` | Color3 | `RGB(88, 101, 242)` |
| `DiscordHover` | Color3 | `RGB(114, 137, 218)` |
| `Divider` | Color3 | `RGB(45, 45, 70)` |

### Arqel.Callbacks

| Property | Type | Description |
|----------|------|-------------|
| `OnVerify` | function | Custom key validation (for `:Launch()` only) |
| `OnSuccess` | function | Called after successful validation |
| `OnFail` | function | Called after failed validation |
| `OnClose` | function | Called when UI is closed |

---

## Methods

### Arqel:LaunchJunkie(config)

Launch with Junkie Development integration.

```lua
Arqel:LaunchJunkie({
    Service = "ServiceName",
    Identifier = "1234",
    Provider = "ProviderName"
})
```

### Arqel:Launch()

Launch with custom validation.

```lua
Arqel.Callbacks.OnVerify = function(key)
    return key == "mykey"
end

Arqel:Launch()
```

### Arqel:Notify(title, message, duration, type)

Show a notification.

```lua
Arqel:Notify("Title", "Message", 5, "success")
```

**Notification Types:** `success`, `error`, `warning`, `info`, `copy`, `discord`, `close`

### Arqel:GetSavedKey()

Returns the saved key or `nil`.

### Arqel:ClearSavedKey()

Deletes the saved key file.

---

## Examples

### Custom Theme (Blue)

```lua
local Arqel = loadstring(game:HttpGet("URL"))()

Arqel.Theme.Accent = Color3.fromRGB(0, 120, 255)
Arqel.Theme.AccentHover = Color3.fromRGB(50, 150, 255)
Arqel.Theme.Background = Color3.fromRGB(15, 15, 20)
Arqel.Theme.Header = Color3.fromRGB(20, 20, 28)

Arqel.Appearance.Title = "Blue Hub"
Arqel.Links.Discord = "discord.gg/xxx"

Arqel:LaunchJunkie({
    Service = "BlueHub",
    Identifier = "1234",
    Provider = "MyName"
})
```

### Keyless Mode

```lua
local Arqel = loadstring(game:HttpGet("URL"))()

Arqel.Appearance.Title = "Free Script"
Arqel.Links.Discord = "discord.gg/xxx"
Arqel.Options.Keyless = true

Arqel.Callbacks.OnSuccess = function()
    print("Loading...")
end

Arqel:Launch()
```

### Custom Key Validation

```lua
local Arqel = loadstring(game:HttpGet("URL"))()

Arqel.Appearance.Title = "My Script"
Arqel.Links.GetKey = "mysite.com/getkey"
Arqel.Storage.FileName = "MyScript_Key"

Arqel.Callbacks.OnVerify = function(key)
    local validKeys = {"key1", "key2", "key3"}
    for _, v in ipairs(validKeys) do
        if key == v then return true end
    end
    return false, "Invalid key"
end

Arqel.Callbacks.OnSuccess = function()
    loadstring(game:HttpGet("mainscript.lua"))()
end

Arqel.Callbacks.OnFail = function(reason)
    warn("Failed:", reason)
end

Arqel:Launch()
```

### Full Customization

```lua
local Arqel = loadstring(game:HttpGet("URL"))()

-- Appearance
Arqel.Appearance.Title = "Premium Hub"
Arqel.Appearance.Subtitle = "Enter license to continue"
Arqel.Appearance.Icon = "rbxassetid://123456789"
Arqel.Appearance.IconSize = UDim2.new(0, 40, 0, 40)

-- Links
Arqel.Links.GetKey = "premiumhub.com/getkey"
Arqel.Links.Discord = "discord.gg/premium"

-- Storage
Arqel.Storage.FileName = "PremiumHub_License"
Arqel.Storage.Remember = true
Arqel.Storage.AutoLoad = true

-- Options
Arqel.Options.Blur = true
Arqel.Options.Draggable = true

-- Theme
Arqel.Theme.Accent = Color3.fromRGB(200, 50, 50)
Arqel.Theme.AccentHover = Color3.fromRGB(230, 70, 70)
Arqel.Theme.Background = Color3.fromRGB(10, 10, 10)
Arqel.Theme.Header = Color3.fromRGB(15, 15, 15)

-- Launch
Arqel:LaunchJunkie({
    Service = "PremiumHub",
    Identifier = "5678",
    Provider = "Developer"
})
```

---

## Comparison: LaunchJunkie vs Launch

| Feature | `:LaunchJunkie()` | `:Launch()` |
|---------|-------------------|-------------|
| Validation | Built-in Junkie | Custom `OnVerify` |
| Key Link | Auto from Junkie | Manual `Links.GetKey` |
| Keyless Detection | Automatic | Manual `Options.Keyless` |
| `OnSuccess` | Optional | Required |
| `OnVerify` | Not needed | Required |

---

## Support

- Discord: [discord.gg/xxx](https://discord.gg/xxx)
- Issues: [GitHub Issues](https://github.com/xxx/xxx/issues)

---

## License

MIT License - Free to use and modify.
```

---

**Just copy everything above and paste into your GitHub README.md file!**
