# BloxHubUILibs

A single-file GUI framework for Roblox. You load `source.lua`, you make a window, you fill it with toggles, sliders, keybinds, and dropdowns. It runs on native Roblox widgets instead of placeholder images, so the same window fits phones, tablets, consoles, and desktop; the device check at load time handles the sizing and input differences for you.

Version 3.3.0.

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
- Every release is additive: nothing is removed or renamed, so older scripts keep running as-is.

## New in 3.3.0

All additive. Existing call styles, return values, and behavior are unchanged.

- **Dropdown `Refresh` accepts both call styles.** `row.Refresh(list)` (dot) and `row:Refresh(list)` (colon) now both work. Previously a colon call silently emptied the list. Dot-call semantics are untouched, so old scripts behave exactly as before.
- **Dropdown lists stay in view and on top.** While an options list is open the framework raises its `DisplayOrder` so the list sits above ScreenGuis your script owns, and the list clamps to the viewport (opening upward when there is no room below). For a permanent pin, call `BloxHub:SetTopMost(true)` (and `SetTopMost(false)` to release).
- **Built-in minimize/restore.** `window:Minimize()` hides the window and shows a floating restore icon (draggable, click to restore); `window:Restore()` brings it back; `window:IsMinimized()` reports state. Pass `MinimizeButton = true` in `CreateWindow` to make the header button use this path — without it the header button keeps its old toggle behavior.
- **Mini widget.** `window:CreateMiniWidget({ Title = "FARM", Rows = { { Type = "Toggle", Text = "Farm", Default = false, Callback = function(on) end }, { Type = "Label", Text = "Kills: 0" } } })` builds a small draggable overlay for quick controls. Rows of type `Label` expose `SetText`, and the widget returns `Show`, `Hide`, `Destroy`, and `SetText(rowIndex, text)`. It clamps to the viewport and docks to the nearest edge when dragged close.
- **Clean-thread dispatch for instance creation.** All public component-creation calls run in a clean thread created at load time, so building the UI no longer breaks with `The current thread cannot access 'Instance' (lacking capability Plugin)` when your script `require`s a game module mid-build. Calls stay fully synchronous: order, timing, return values, and error messages are unchanged.

Still worth knowing: `require` a game module from the same thread that is building UI remains an anti-pattern — with 3.3.0 the UI survives it, but deferring `require` into `task.spawn` after the UI is built keeps your own module code out of the same trouble.

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

Core calls, `BloxHub:CreateWindow`, `BloxHub:Notify`, `BloxHub:CreateFloatingIcon`, `BloxHub:GetThemes`, `BloxHub:SetTheme`, `BloxHub:CustomizeTheme`, `BloxHub:SaveConfig`, `BloxHub:LoadConfig`, `BloxHub:Destroy`, `BloxHub:SetTopMost`.

Responsive, `BloxHub:RP`, `BloxHub:MeasureScreen`, `BloxHub:Fit`, `BloxHub:ResizeWindows`, `BloxHub:OnScreenChange`, plus the `BloxHub.Screen` table.

Window: `CreateTab`, `Toggle`, `Show`, `Hide`, `Minimize`, `Restore`, `IsMinimized`, `SetTitle`, `SetSize`, `SetPosition`, `Destroy`, `CreatePopup`, `CreateMiniWidget`, `RegisterHotkey`.

Element: `AddButton`, `AddToggle`, `AddSlider`, `AddKeybind`, `AddDropdown`, `AddTextBox`, `AddLabel`, `AddDivider`.

## Notice

This is a UI layer you run inside your own executor. What you can do with it depends on where you run it, so keep use within the terms of service of the platform you're on.