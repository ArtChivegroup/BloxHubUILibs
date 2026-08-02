# BloxHub GUI Framework v3.1

A single-file, component UI library for Roblox. It runs on the engine's own widgets, which keeps it usable on PC, mobile, tablet, and console without you shipping separate builds. Version 3.1.0.

## Features

- The whole library is one `source.lua`; there's nothing to wire together.
- Window size and input adapt from a device check that runs at load.
- It uses UIStroke, UIGradient, and other native widgets rather than fetched images.
- Sliders chase touch input as well as mouse.
- Theme swaps, custom colors, and loaded configs repaint every component live.
- Windows resize from a corner, and you can remove a window, a tab, or a single element.
- Notifications pile up in a stack without hiding each other.
- Cleanup methods free the input connections those elements opened.
- Layout re-flows when the client window resizes or a phone rotates, web-style.

## Loading

```lua
local BloxHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArtChivegroup/BloxHubUILibs/refs/heads/main/source.lua"))()
```

## A window from scratch

```lua
local MainWindow = BloxHub:CreateWindow("My First UI", {
    Size = UDim2.new(0, 550, 0, 450),
    Resizable = true
})

local mainTab = MainWindow:CreateTab("Main")

mainTab:AddButton("Click Me!", function()
    BloxHub:Notify("Success", "Button clicked!", 3, "Info")
end)

local fly = mainTab:AddToggle("Enable Feature", false, function(state)
    print("Feature:", state)
end)

mainTab:AddSlider("Speed", 1, 100, 50, function(value)
    print("Speed:", value)
end)
```

The `Size` is a hint. On a phone the width clamps to fit, and the height shrinks too.

## CreateWindow

`BloxHub:CreateWindow(title, config)` makes a window and centers it.

| Key | Type | What it does |
|-----|------|--------------|
| `title` | string | The header text. Extra-left of the logo dot. |
| `config.Size` | UDim2 | Start size; adapts on mobile. |
| `config.Position` | UDim2 | Where it goes. Defaults to centered. |
| `config.Resizable` | boolean | Lets a user drag from the bottom-right corner. Off by default. |
| `config.MinSize` | UDim2 | Floor for resizing. Defaults to 320x200. |
| `config.Visible` | boolean | Show at load or not. Defaults to true. |

## Window methods

`CreateTab(name)` appends a tab; the first one activates itself. `Toggle`, `Show`, and `Hide` switch visibility, and Toggle plus Hide bring back the floating icon.

`SetTitle(newTitle)` rewrites the header text. `SetSize(w, h)` and `SetPosition(udim2)` move the window from code. `Destroy()` removes the window, its shadow, its floating icon, and every connection it opened.

`RegisterHotkey(name, keyCode, callback)` binds a key. It hands back a control object.

```lua
local hk = MainWindow:RegisterHotkey("ToggleGUI", Enum.KeyCode.RightShift, function()
    MainWindow:Toggle()
end)

hk:Disable()
hk:Enable()
```

`CreatePopup(title, config)` builds a modal. See the Popup section below.

## Component API

Every row component returns a table with `Container` (the frame) and `Destroy()` (removes the row and frees whatever it held).

### AddButton

`tab:AddButton(text, callback)` puts a full-width button with a click animation.

### AddToggle

`tab:AddToggle(text, default, callback)` renders a pill switch. The knob bounces when it flips.

```lua
local t = mainTab:AddToggle("ESP", false, function(on) end)

t:GetValue()       -- boolean
t:SetValue(true)   -- flip it from code
t:Destroy()
```

### AddSlider

`tab:AddSlider(text, min, max, default, callback)` is a draggable track with a knob and a value readout. The value snaps to whole numbers.

```lua
local s = mainTab:AddSlider("FOV", 70, 120, 90, function(v)
    workspace.CurrentCamera.FieldOfView = v
end)

s:GetValue()
s:SetValue(100)
```

### AddKeybind

`tab:AddKeybind(text, defaultKey, callback)` gives you a key that, when clicked, turns the label into "..." and waits for input. On a keyboard it captures the next non-repressed key; on mobile it's still the same dialog.

```lua
local kb = mainTab:AddKeybind("Aim Key", Enum.KeyCode.E, function(k, input, name) end)
kb:SetKey(Enum.KeyCode.G)
local k, inputType = kb:GetKey()
```

### AddDropdown

`tab:AddDropdown(text, options, callback)` lists choices; the selected one keeps a small accent bar. It opens upward so it never clips behind the screen edge.

```lua
local dd = mainTab:AddDropdown("Target", {"Head", "Torso", "Random"}, function(sel) end)
dd:GetValue()
dd:SetValue("Torso")
dd:Refresh({"New", "List of options"})
dd:Destroy()
```

### AddTextBox

`tab:AddTextBox(text, placeholder, callback)` is a text field. `callback(text, enterPressed)` runs when the field loses focus, and `enterPressed` tells you whether Enter was hit.

```lua
local tb = mainTab:AddTextBox("Username", "type a name", function(text, enter) end)
tb:GetValue()
tb:SetValue("something")
```

### AddLabel

`tab:AddLabel(text, config)` outputs static text. Setting `Bold = true` gives it an accent bar on the left and pushes the text over.

```lua
mainTab:AddLabel("Section", { Bold = true })
mainTab:AddLabel("plain line of text")
```

### AddDivider

`tab:AddDivider()` is a horizontal rule with padding around it.

## Popups

`window:CreatePopup(title)` returns a `popup` with `Show()` and `Hide()`. Clicking the darkened backdrop behind it closes it.

```lua
local p = MainWindow:CreatePopup("Confirm")
p:AddLabel("Are you sure?")
p:AddButton("Yes", function() p:Hide() end)
p:AddButton("No", function() p:Hide() end)
p:Show()
```

## Utilities

### Notify

`BloxHub:Notify(title, message, duration, type)` slides a toast in from the right. Types `Info`, `Success`, `Warning`, `Error`. Toasts stack downward so several can serve at once.

### FloatingIcon

`BloxHub:CreateFloatingIcon(window, config)` places a grab-the-bar toggle that stays on screen when the menu is hidden.

```lua
BloxHub:CreateFloatingIcon(MainWindow, {
    Text = "Puzzle Piece",
    ShowOnMinimize = true
})
```

### Themes

`BloxHub:GetThemes()` returns the built-in names. `SetTheme(name)` applies one and repaints everything that's already on screen. `CustomizeTheme({ key = color })` alters specific keys the same way.

```lua
BloxHub:SetTheme("Green")
BloxHub:CustomizeTheme({ Accent = Color3.fromRGB(255, 90, 0) })
```

### Config

`SaveConfig(name)` writes JSON through `writefile` and, if that fails, keeps it in memory. `LoadConfig(name)` reads it back and reassigns the theme.

### Destroy

`BloxHub:Destroy()` disconnects every input hook the framework opened, destroys the ScreenGui, and drops all windows and notifications. The framework can be run again afterwards with a fresh `Init`.

## Device detection

These live on `BloxHub.Device`.

```lua
BloxHub.Device.IsMobile
BloxHub.Device.IsTablet
BloxHub.Device.IsConsole
BloxHub.Device.IsDesktop
BloxHub.Device.TouchEnabled
```

## Responsive layout

A thin media-query layer sits under the UI. At load it runs on `BloxHub.Screen`, which holds the current viewport, a breakpoint name, the orientation, and a density scale. Windows size themselves against it, and when the client window resizes or a phone rotates, every open window re-flows and pulls itself back on-screen.

```lua
BloxHub.Screen.Breakpoint     -- "phone" / "tablet" / "console" / "desktop"
BloxHub.Screen.Orientation    -- "landscape" / "portrait"
BloxHub.Screen.ViewportSize   -- Vector2 of the camera viewport
BloxHub.Screen.Scale          -- density factor (1 on desktop)
```

Public helpers you can call yourself.

```lua
local half = BloxHub:RP(50)                      -- scale a pixel size for the screen
BloxHub:MeasureScreen()                          -- rebuild the telemetry
local fit = BloxHub:Fit(560, 460)               -- clamp sizes to the viewport
BloxHub:ResizeWindows()                        -- re-flow all windows now
```

To react to resizing like you would to a browser's resize event:

```lua
local handle = BloxHub:OnScreenChange(function(screen)
    print("now on", screen.Breakpoint, screen.Orientation)
end)

-- later:
handle:Disconnect()
```

Windows also expose `window:Relayout()`, which clamps the window to the viewport and nudges it back on-screen. It runs automatically on viewport changes.

## Theme colors

```lua
BloxHub.Settings.Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    BackgroundGradient = Color3.fromRGB(18, 18, 24),
    Primary = Color3.fromRGB(22, 22, 28),
    Secondary = Color3.fromRGB(32, 32, 42),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentGradient = Color3.fromRGB(108, 121, 255),
    AccentHover = Color3.fromRGB(118, 131, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(148, 155, 164),
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Error = Color3.fromRGB(237, 66, 69),
    Border = Color3.fromRGB(48, 48, 58)
}
```

Accent, Success, Warning, and Error also color the accent bar on the left of a notification.

## UI flags

`BloxHub.Settings.UI` toggles pieces of the render:

```lua
BloxHub.Settings.UI = {
    StrokeEnabled = true,
    GradientEnabled = true,
    ShadowEnabled = true,
    ResponsiveScale = true
}
```

## Lifecycle scoping

Three levels of cleanup exist. `window:Destroy()` removes one window and all its connections. An element's `Destroy()` removes a single row and the input hooks it registered. `BloxHub:Destroy()` clears everything at once, connections included.

For a worked example that presses every component, read `example.lua` in this repo.