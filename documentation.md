# BloxHub GUI Framework v3.1

**BloxHub** adalah library GUI yang powerful, single-file, dan berbasis komponen untuk Roblox. Didesain minimalis, highly customizable, dan mudah diintegrasikan ke project manapun. Framework v3.1 menggunakan **pure Roblox engine UI components** untuk kompatibilitas lintas perangkat (PC, Mobile, Tablet, Console).

## ✨ Features

-   **Single-File Library**: Tidak ada struktur file kompleks. Load satu file dan siap digunakan.
-   **Cross-Device Compatible**: Otomatis menyesuaikan ukuran dan input untuk PC, Mobile, Tablet, dan Console.
-   **Pure Roblox Engine UI**: Menggunakan UIStroke, UIGradient, dan komponen native Roblox.
-   **Touch Support**: Slider dan komponen lain mendukung input sentuh.
-   **Modern Design**: Gradient backgrounds, accent lines, smooth animations.
-   **Live Theme System**: Ganti tema / custom warna — **semua komponen langsung ter-warnai ulang otomatis**.
-   **Configuration Persistence**: Simpan dan load preferensi user secara otomatis.
-   **Built-in Notification System**: Notifikasi modern dengan **stacking** (tidak saling menimpa).
-   **Dynamic Inputs**: Keybind system yang support keyboard dan mouse.
-   **Window Resizable**: Resize manual lewat sudut kanan-bawah (opsional).
-   **Full Cleanup**: `Window:Destroy()`, `element:Destroy()`, dan `BloxHub:Destroy()`.

## 🚀 Getting Started

### 1. Load the Library

```lua
local BloxHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArtChivegroup/Roblox/refs/heads/main/script/addon/BloxHubUILib/test/source.lua"))()
```

### 2. Create Your First Window

```lua
local MainWindow = BloxHub:CreateWindow("My First UI", {
    Size = UDim2.new(0, 550, 0, 450), -- Optional, auto-adapts untuk mobile
    Resizable = true                   -- Optional, izinkan user resize
})
```

### 3. Add Tabs and Components

```lua
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

## 📚 API Reference

### Core API

#### `BloxHub:CreateWindow(title, [config])`
Membuat window baru dengan adaptive sizing untuk mobile.

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | string | Judul window |
| `config.Size` | UDim2 | Ukuran window (auto-adapt untuk mobile) |
| `config.Position` | UDim2 | Posisi window (default: centered) |
| `config.Resizable` | boolean | Izinkan resize via sudut kanan-bawah (default `false`) |
| `config.MinSize` | UDim2 | Ukuran minimum saat resize (default `320x200`) |
| `config.Visible` | boolean | Muncul tidaknya window awal (default `true`) |

#### `Window:CreateTab(name)`
Membuat tab baru. Tab pertama otomatis aktif.

#### `Window:RegisterHotkey(name, keyCode, callback)`
Register hotkey untuk trigger callback. Mengembalikan object kontrol hotkey.

```lua
local hotkey = MainWindow:RegisterHotkey("ToggleGUI", Enum.KeyCode.RightShift, function()
    MainWindow:Toggle()
end)

hotkey:Disable()  -- Nonaktifkan hotkey
hotkey:Enable()   -- Aktifkan kembali
```

#### `Window:Toggle()` / `Window:Show()` / `Window:Hide()`
Mengontrol visibilitas window (Toggle/Hide otomatis menampilkan floating icon).

#### `Window:SetTitle(newTitle)`
Mengganti judul window.

#### `Window:SetSize(width, height)`
Resize window secara programmatic.

#### `Window:SetPosition(udim2)`
Mengubah posisi window.

#### `Window:Destroy()`
Hapus window beserta semua koneksinya dan floating icon-nya.

### Component API

Semua komponen di bawah mengembalikan object. Komponen yang berupa `row` mengembalikan table dengan:
- `Container` — Frame utama.
- `Destroy()` — Hapus elemen & bebaskan koneksinya.

#### `Tab:AddButton(text, callback)`
Tombol dengan click animation.

#### `Tab:AddToggle(text, [default], callback)`
Toggle switch dengan pill design dan bounce animation.

```lua
local toggle = mainTab:AddToggle("ESP", false, function(enabled)
    -- Your code
end)

toggle:GetValue()      -- Returns boolean
toggle:SetValue(true)  -- Set toggle state
toggle:Destroy()       -- Hapus elemen
```

#### `Tab:AddSlider(text, min, max, [default], callback)`
Slider dengan draggable knob dan touch support.

```lua
local slider = mainTab:AddSlider("FOV", 70, 120, 90, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

slider:GetValue()     -- Returns number
slider:SetValue(100)  -- Set slider value
slider:Destroy()
```

#### `Tab:AddKeybind(text, defaultKey, callback)`
Keybind picker dengan visual feedback saat listening.

```lua
mainTab:AddKeybind("Aimbot Key", Enum.KeyCode.E, function(key, input, name)
    print("New key:", name)
end)

local kb = mainTab:AddKeybind("Key", Enum.KeyCode.F, function() end)
kb:SetKey(Enum.KeyCode.G)   -- Set key programmatic
kb:GetKey()                 -- Mengembalikan keyCode, inputType
```

#### `Tab:AddDropdown(text, options, callback)`
Dropdown menu dengan selected indicator.

```lua
local dd = mainTab:AddDropdown("Target", {"Head", "Torso", "Random"}, function(choice)
    print("Selected:", choice)
end)

dd:GetValue()         -- String selected
dd:SetValue("Torso")  -- Ganti nilai
dd:Refresh({"New", "List"})  -- Ganti opsi
dd:Destroy()
```

#### `Tab:AddTextBox(text, [placeholder], callback)`
Input text dengan focus animation.

```lua
local tb = mainTab:AddTextBox("Username", "Enter name...", function(text, enterPressed)
    if enterPressed then print("Submitted:", text) end
end)

tb:GetValue()  -- String current text
```

#### `Tab:AddLabel(text, [config])`
Label text. Bold labels mendapat accent bar.

```lua
mainTab:AddLabel("Section Title", { Bold = true, TextSize = 16 })
mainTab:AddLabel("Description text")
```

#### `Tab:AddDivider()`
Pembatas visual dengan proper spacing.

### Popup API

#### `Window:CreatePopup(title, [config])`
Modal popup dengan overlay yang bisa ditutup dengan klik backdrop.

```lua
local popup = MainWindow:CreatePopup("Confirm")
popup:AddLabel("Are you sure?")
popup:AddButton("Yes", function() popup:Hide() end)
popup:AddButton("No", function() popup:Hide() end)
popup:Show()
-- popup:Hide() / popup:Destroy()
```

### Utility Functions

#### `BloxHub:Notify(title, message, [duration], [type])`
Tampilkan notifikasi. Type: `"Info"`, `"Success"`, `"Warning"`, `"Error"`. Notifications **menumpuk** ke bawah sehingga tidak saling menimpa.

#### `BloxHub:CreateFloatingIcon(window, [config])`
Buat floating icon / toggle. Otomatis sinkron dengan Toggle/Hide/Show window.

```lua
BloxHub:CreateFloatingIcon(MainWindow, {
    Text = "Toggle UI",
    ShowOnMinimize = true
})
```

#### `BloxHub:GetThemes()`
Mengembalikan daftar nama theme bawaan (mis. `"Dark"`, `"Light"`, `"Purple"`, `"Green"`).

#### `BloxHub:SetTheme(themeName)`
Ganti tema. **Semua window & komponen ter-warna ulang otomatis.**

#### `BloxHub:CustomizeTheme(customColors)`
Ubah sebagian warna theme dan recolor semua komponen secara live.

```lua
BloxHub:CustomizeTheme({ Accent = Color3.fromRGB(255, 128, 0), Text = Color3.new(1, 1, 1) })
```

#### `BloxHub:SaveConfig([name])` / `BloxHub:LoadConfig([name])`
Simpan / load konfigurasi (theme + window) ke file `writefile` atau memori.

#### `BloxHub:Destroy()`
Bersihkan **semua** resource framework: disconnect semua koneksi input, destroy ScreenGui, hapus semua window dan notifikasi. Aman dipanggil untuk reset.

## 📱 Device Detection

Framework otomatis mendeteksi device dan menyesuaikan UI:

```lua
BloxHub.Device.IsMobile   -- true jika mobile phone
BloxHub.Device.IsTablet   -- true jika tablet
BloxHub.Device.IsConsole  -- true jika console (Xbox)
BloxHub.Device.IsDesktop  -- true jika PC
BloxHub.Device.TouchEnabled -- true jika touch supported
```

## 🎨 Theme System (v3.1)

Empat theme bawaan: `"Dark"`, `"Light"`, `"Purple"`, `"Green"`. Setiap theme menspesifikasikan semua warna di bawah, termasuk **gradient**, **border** dan **shadow**, sehingga recolor konsisten.

```lua
BloxHub.Settings.Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    BackgroundGradient = Color3.fromRGB(18, 18, 24),
    Primary = Color3.fromRGB(22, 22, 28),
    PrimaryGradient = Color3.fromRGB(28, 28, 36),
    Secondary = Color3.fromRGB(32, 32, 42),
    SecondaryGradient = Color3.fromRGB(42, 42, 54),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentGradient = Color3.fromRGB(108, 121, 255),
    AccentHover = Color3.fromRGB(118, 131, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(148, 155, 164),
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Error = Color3.fromRGB(237, 66, 69),
    Border = Color3.fromRGB(48, 48, 58),
    Shadow = Color3.fromRGB(0, 0, 0)
}
```

`Accent`, `Success`, `Warning`, `Error` juga dipakai sebagai status bawah notification bar.

## 🔧 UI Settings

Toggle fitur UI modern:

```lua
BloxHub.Settings.UI = {
    StrokeEnabled = true,      -- UIStroke borders
    GradientEnabled = true,    -- Gradient backgrounds
    ShadowEnabled = true,      -- Drop shadows
    ResponsiveScale = true     -- Responsive scaling
}
```

## 🔁 Lifecycle & Cleanup

- **Per window**: `window:Destroy()` menghapus window, shadow, floating icon, dan memutus semua koneksi global-nya.
- **Per elemen**: `element:Destroy()` menghapus row dan membebaskan koneksi drag/resize miliknya (mencegah memory/connection leak).
- **Global**: `BloxHub:Destroy()` memutus seluruh `InputBegan`/`InputChanged`/`InputEnded` milik framework dan menghapus `ScreenGui`.