# BloxHubUILibs

Universal Roblox GUI Framework — single-file, component-based UI library built on pure Roblox Engine components. Cross-device compatible (PC, Mobile, Tablet, Console).

## Features

- **Single-File Library** — load one file and you're ready.
- **Pure Roblox UI** — UIStroke, UIGradient, native components.
- **Cross-Device** — auto-adapts size & input for PC/Mobile/Tablet/Console.
- **Touch Support** — sliders and other components support touch input.
- **Modern Design** — gradients, accent lines, smooth animations.
- **Live Theme System** — switch/customize themes; all components recolor instantly.
- **Built-in Notifications** — stacked, modern, with type colors.
- **Window Resizable** — drag-resize from the bottom-right corner.
- **Dynamic Inputs** — keybind picker supporting keyboard & mouse.
- **Full Cleanup** — `Window:Destroy()`, `element:Destroy()`, `BloxHub:Destroy()`.

## Files

| File             | Purpose                                    |
|------------------|--------------------------------------------|
| `source.lua`     | The library (v3.1.0)                       |
| `example.lua`    | Showcase script for all components         |
| `documentation.md` | Full API reference                        |

## Getting Started

```lua
local BloxHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArtChivegroup/BloxHubUILibs/refs/heads/main/source.lua"))()

local MainWindow = BloxHub:CreateWindow("My UI", {
    Size = UDim2.new(0, 550, 0, 450),
    Resizable = true
})

local tab = MainWindow:CreateTab("Main")

tab:AddButton("Click Me", function()
    BloxHub:Notify("Hi", "Button clicked!", 3, "Success")
end)

tab:AddToggle("ESP", false, function(state)
    print("ESP:", state)
end)
```

## Documentation

Detailed API reference is available in [`documentation.md`](documentation.md). A full component showcase is in [`example.lua`](example.lua).

### Quick API Overview

- `BloxHub:CreateWindow(title, config)` — `config.Size`, `config.Position`, `config.Resizable`, `config.MinSize`, `config.Visible`
- `Window:CreateTab(name)`, `Window:Toggle/Show/Hide`, `Window:SetTitle`, `Window:SetSize`, `Window:SetPosition`, `Window:Destroy`
- `Window:RegisterHotkey(name, key, cb)` — returns control object with `:Enable()` / `:Disable()`
- `Window:CreatePopup(title, config)`
- `Tab:AddButton/AddToggle/AddSlider/AddKeybind/AddDropdown/AddTextBox/AddLabel/AddDivider`
- `BloxHub:Notify(title, msg, duration, type)` — types: `Info`, `Success`, `Warning`, `Error`
- `BloxHub:CreateFloatingIcon(window, config)`
- `BloxHub:GetThemes()`, `BloxHub:SetTheme(name)`, `BloxHub:CustomizeTheme(colors)`
- `BloxHub:SaveConfig()`, `BloxHub:LoadConfig()`, `BloxHub:Destroy()`

## Notice

This is a UI library for use in Roblox scripts executed by the user. Use responsibly within the terms of service of the platforms you use it on.