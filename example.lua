--[[
    BloxHub GUI Framework v3.1 - Showcase Example
    
    Deskripsi:
    Script ini memuat BloxHub GUI Framework v3.1 dari GitHub dan membuat
    sebuah jendela UI untuk mendemonstrasikan semua komponen yang tersedia.
    
    Fitur v3.1:
    - Pure Roblox UI (UIStroke, UIGradient, dll)
    - Cross-device compatible (PC, Mobile, Tablet, Console)
    - Touch support untuk slider dan komponen lainnya
    - Modern design dengan gradient dan animasi smooth
    - Live theme recolor (SetTheme/CustomizeTheme langsung mengupdate semua komponen)
    - Window Resizable & method SetSize / SetPosition / Destroy
    - Notofication stacking (tidak saling menimpa)
    - Cleanup: BloxHub:Destroy() dan element:Destroy()
    
    Cara Penggunaan:
    1. Jalan di executor
    2. Tekan RightShift untuk toggle GUI
    3. Atau klik floating icon
]]

-- URL ke file source BloxHub GUI Framework
local GITHUB_URL = "https://raw.githubusercontent.com/ArtChivegroup/BloxHubUILibs/refs/heads/main/source.lua"

-- Muat library dari GitHub
local BloxHub = loadstring(game:HttpGet(GITHUB_URL))()

-- Periksa apakah library berhasil dimuat
if not BloxHub then
    warn("Gagal memuat BloxHub GUI Framework. Periksa koneksi internet atau URL.")
    return
end

-- Tampilkan info device
print("=== BloxHub Framework v" .. BloxHub.Version .. " ===")
print("Device Info:")
print("  IsMobile:", BloxHub.Device.IsMobile)
print("  IsTablet:", BloxHub.Device.IsTablet)
print("  IsConsole:", BloxHub.Device.IsConsole)
print("  IsDesktop:", BloxHub.Device.IsDesktop)
print("  TouchEnabled:", BloxHub.Device.TouchEnabled)

-- =========================================================================
-- MEMBUAT JENDELA UTAMA
-- =========================================================================

local MainWindow = BloxHub:CreateWindow("BloxHub v3.1 Showcase", {
    Size = UDim2.new(0, 560, 0, 480),  -- Akan auto-adapt untuk mobile
    Resizable = true                    -- Izinkan resize via sudut kanan-bawah
})

-- Ubah ukuran programmatically
-- MainWindow:SetSize(560, 480)

-- Daftarkan hotkey 'RightShift' untuk toggle GUI
MainWindow:RegisterHotkey("ToggleGUI", Enum.KeyCode.RightShift, function()
    MainWindow:Toggle()
end)

-- Buat floating icon
BloxHub:CreateFloatingIcon(MainWindow, {
    Text = "Menu", 
    ShowOnMinimize = true
})


-- =========================================================================
-- TAB 1: MAIN FEATURES
-- =========================================================================

local featuresTab = MainWindow:CreateTab("Features")

featuresTab:AddLabel("Basic Components", { Bold = true })

-- Button dengan click animation
featuresTab:AddButton("Show Notification", function()
    BloxHub:Notify("Hello!", "This is a notification from BloxHub v3.0", 3, "Info")
end)

featuresTab:AddButton("Success Notification", function()
    BloxHub:Notify("Success", "Operation completed successfully!", 3, "Success")
end)

featuresTab:AddDivider()

featuresTab:AddLabel("Toggle & Slider", { Bold = true })

-- Toggle dengan pill design dan bounce animation
local flyToggle = featuresTab:AddToggle("Enable Fly", false, function(state)
    BloxHub:Notify("Fly Mode", state and "Enabled" or "Disabled", 2, state and "Success" or "Info")
end)

-- Slider dengan draggable knob dan touch support
local speedSlider = featuresTab:AddSlider("Walk Speed", 16, 200, 16, function(value)
    local humanoid = game.Players.LocalPlayer.Character and 
                     game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

local fovSlider = featuresTab:AddSlider("Camera FOV", 30, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

featuresTab:AddDivider()

featuresTab:AddLabel("Input Components", { Bold = true })

-- Keybind dengan visual feedback
featuresTab:AddKeybind("Fly Key", Enum.KeyCode.F, function(keyCode, inputType, keyName)
    BloxHub:Notify("Keybind Set", "Fly key is now: " .. keyName, 2, "Info")
end)

-- TextBox dengan focus animation
featuresTab:AddTextBox("Player Name", "Enter username...", function(text, enterPressed)
    if enterPressed and text ~= "" then
        BloxHub:Notify("Search", "Searching for: " .. text, 2, "Info")
    end
end)


-- =========================================================================
-- TAB 2: VISUALS
-- =========================================================================

local visualsTab = MainWindow:CreateTab("Visuals")

visualsTab:AddLabel("ESP Options", { Bold = true })

visualsTab:AddToggle("Player ESP", false, function(state)
    print("Player ESP:", state)
end)

visualsTab:AddToggle("Box ESP", false, function(state)
    print("Box ESP:", state)
end)

visualsTab:AddToggle("Tracers", false, function(state)
    print("Tracers:", state)
end)

visualsTab:AddToggle("Name Tags", true, function(state)
    print("Name Tags:", state)
end)

visualsTab:AddDivider()

visualsTab:AddLabel("ESP Settings", { Bold = true })

visualsTab:AddSlider("Max Distance", 100, 2000, 500, function(value)
    print("Max Distance:", value)
end)

visualsTab:AddDropdown("ESP Color", {"Team Color", "White", "Red", "Green", "Blue"}, function(choice)
    BloxHub:Notify("ESP Color", "Changed to: " .. choice, 2, "Info")
end)

visualsTab:AddDropdown("Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(choice)
    print("Target Part:", choice)
end)


-- =========================================================================
-- TAB 3: AIMBOT
-- =========================================================================

local aimbotTab = MainWindow:CreateTab("Aimbot")

aimbotTab:AddLabel("Aimbot Settings", { Bold = true })

aimbotTab:AddToggle("Enable Aimbot", false, function(state)
    BloxHub:Notify("Aimbot", state and "Activated" or "Deactivated", 2, state and "Warning" or "Info")
end)

aimbotTab:AddToggle("Show FOV Circle", true, function(state)
    print("FOV Circle:", state)
end)

aimbotTab:AddSlider("FOV Size", 50, 500, 150, function(value)
    print("FOV Size:", value)
end)

aimbotTab:AddSlider("Smoothness", 1, 20, 5, function(value)
    print("Smoothness:", value)
end)

aimbotTab:AddDivider()

aimbotTab:AddLabel("Target Settings", { Bold = true })

aimbotTab:AddDropdown("Target Priority", {"Closest", "Lowest Health", "Highest Threat"}, function(choice)
    print("Priority:", choice)
end)

aimbotTab:AddKeybind("Aim Key", Enum.KeyCode.E, function(keyCode, inputType, keyName)
    BloxHub:Notify("Aim Key", "Set to: " .. keyName, 2, "Info")
end)


-- =========================================================================
-- TAB 4: SETTINGS
-- =========================================================================

local settingsTab = MainWindow:CreateTab("Settings")

settingsTab:AddLabel("UI Customization", { Bold = true })

-- Theme selector (dengan daftar theme otomatis)
settingsTab:AddDropdown("Theme", BloxHub:GetThemes(), function(themeName)
    BloxHub:SetTheme(themeName)
    BloxHub:Notify("Theme Changed", "Applied: " .. themeName, 2, "Success")
end)

settingsTab:AddDivider()

settingsTab:AddLabel("Configuration", { Bold = true })

settingsTab:AddButton("Save Config", function()
    local success = BloxHub:SaveConfig()
    if success then
        BloxHub:Notify("Config", "Configuration saved!", 2, "Success")
    else
        BloxHub:Notify("Config", "Failed to save (executor required)", 3, "Error")
    end
end)

settingsTab:AddButton("Load Config", function()
    BloxHub:LoadConfig()
    BloxHub:Notify("Config", "Configuration loaded!", 2, "Info")
end)

settingsTab:AddDivider()

settingsTab:AddLabel("Device Info", { Bold = true })

local deviceType = BloxHub.Device.IsMobile and "Mobile" or 
                   BloxHub.Device.IsTablet and "Tablet" or 
                   BloxHub.Device.IsConsole and "Console" or "Desktop"
settingsTab:AddLabel("Current Device: " .. deviceType)
settingsTab:AddLabel("Touch Enabled: " .. tostring(BloxHub.Device.TouchEnabled))
settingsTab:AddLabel("Framework Version: " .. BloxHub.Version)

settingsTab:AddDivider()

-- Demonstrasi cleanup per-elemen: toggle yang bisa dihapus
settingsTab:AddLabel("Lifecycle Demo", { Bold = true })

local removable = settingsTab:AddToggle("Removable Toggle", false, function(state)
    BloxHub:Notify("Toggle", state and "On" or "Off", 1, "Info")
end)

settingsTab:AddButton("Remove Toggle Above", function()
    removable:Destroy()
    BloxHub:Notify("Cleanup", "Toggle element removed!", 2, "Success")
end)

settingsTab:AddDivider()

settingsTab:AddButton("Destroy GUI", function()
    BloxHub:Destroy() -- Membersihkan semua window, notifikasi & koneksi input
end)


-- =========================================================================
-- EXTRAS TAB: demo popup & stacked notifications
-- =========================================================================

local extrasTab = MainWindow:CreateTab("Extras")

extrasTab:AddLabel("Popup", { Bold = true })

extrasTab:AddButton("Open Popup", function()
    local popup = MainWindow:CreatePopup("Confirm", {})
    popup:AddLabel("This is a modal popup. Click an option below.")
    popup:AddButton("Confirm", function()
        popup:Hide()
        BloxHub:Notify("Popup", "Confirmed!", 2, "Success")
    end)
    popup:AddButton("Cancel", function()
        popup:Hide()
    end)
    popup:Show()
end)

extrasTab:AddDivider()

extrasTab:AddLabel("Stacked Notifications", { Bold = true })

extrasTab:AddButton("Fire 3 Notifications", function()
    BloxHub:Notify("Info", "First notification", 2, "Info")
    BloxHub:Notify("Warning", "Second notification", 3, "Warning")
    BloxHub:Notify("Error", "Third notification", 3, "Error")
end)

extrasTab:AddButton("Custom Theme Setting", function()
    BloxHub:CustomizeTheme({ Accent = Color3.fromRGB(255, 128, 0) })
    BloxHub:Notify("Theme", "Custom accent applied & all components recolored!", 2, "Success")
end)


-- =========================================================================
-- STARTUP NOTIFICATION
-- =========================================================================

BloxHub:Notify(
    "BloxHub v3.1 Loaded",
    "Press RightShift to toggle menu. Touch support enabled!",
    5,
    "Success"
)
