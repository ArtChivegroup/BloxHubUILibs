# BloxHubUILibs

A single-file GUI framework for Roblox. You load `source.lua`, you make a window, you fill it with toggles, sliders, keybinds, and dropdowns. It runs on native Roblox widgets instead of placeholder images, so the same window fits phones, tablets, consoles, and desktop; the device check at load time handles the sizing and input differences for you.

Version 3.1.0.

## The three files

`source.lua` is the library itself. `example.lua` builds a window and runs through every component so you can see the calls in context. `documentation.md` is the API notes. That's the whole repo.

## What it does

- One file. No extra assets, no setup past the `loadstring` call.
- Layout drops in based on which device you're on at load, then tracks the effects of resizing. On `BloxHub.Screen` you get the viewport, breakpoint, orientation, and a density scale.
- Sliders accept touch; dragging them feels native either way.
- `SetTheme`, `CustomizeTheme`, and a saved config each repaint the live components in a single call.
- Windows can resize from a corner, and you can destroy a whole window, one element, or the framework.
- Notifications stack down the edge so several can sit on screen together, rather than burying one another.
- Every method that opens an input hook also cleans it up when you destroy the thing that owns it.

## Setup

```lua
local BloxHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArtChivegroup/BloxHubUILibs/refs/heads/main/source.lua"))()

local w = BloxHub:CreateWindow("My UI", { Size = UDim2.new(0, 560, 0, 460) })
local tab = w:CreateTab("Main")

tab:AddButton("Hello", function()
    BloxHub:Notify("Just so you know", "You clicked a button.", 2, "Info")
end)

local esp = tab:AddToggle("ESP", false, function(on) print("ESP:", on) end)
```

The raw URL is fetched over HTTPS. On mobile and consoles the width clamps so a menu never runs wider than the screen.

## The API at a glance

The full method list and parameter tables live in `documentation.md`. Quick summary.

Core calls, `BloxHub:CreateWindow`, `BloxHub:Notify`, `BloxHub:CreateFloatingIcon`, `BloxHub:GetThemes`, `BloxHub:SetTheme`, `BloxHub:CustomizeTheme`, `BloxHub:SaveConfig`, `BloxHub:LoadConfig`, `BloxHub:Destroy`.

Responsive, `BloxHub:RP`, `BloxHub:MeasureScreen`, `BloxHub:Fit`, `BloxHub:ResizeWindows`, `BloxHub:OnScreenChange`, plus the `BloxHub.Screen` table.

Window: `CreateTab`, `Toggle`, `Show`, `Hide`, `SetTitle`, `SetSize`, `SetPosition`, `Destroy`, `CreatePopup`, `RegisterHotkey`.

Element: `AddButton`, `AddToggle`, `AddSlider`, `AddKeybind`, `AddDropdown`, `AddTextBox`, `AddLabel`, `AddDivider`.

## Notice

This is a UI layer you run inside your own executor. What you can do with it depends on where you run it, so keep use within the terms of service of the platform you're on.