# Ghostline UI

A modern, animated UI library for Roblox. Ghostline ships with three window styles, a full set of controls, a live theme engine, built-in localization in nine languages, notifications, global search, configuration management, and first-class mobile support.

- **Version:** 2.4.0
- **Language:** Luau
- **Window styles:** Ghostline (Our UI), Rayfield, Orion
- **Interface languages:** English, French, German, Spanish, Italian, Portuguese, Dutch, Polish, Turkish

---

## Table of contents

1. [Features](#features)
2. [Installation](#installation)
3. [Quick start](#quick-start)
4. [Window styles](#window-styles)
5. [Creating a window](#creating-a-window)
6. [Tabs and sections](#tabs-and-sections)
7. [Elements](#elements)
8. [Localization](#localization)
9. [Notifications](#notifications)
10. [Themes and modes](#themes-and-modes)
11. [Flags and configurations](#flags-and-configurations)
12. [Performance mode](#performance-mode)
13. [Window API](#window-api)
14. [Global API](#global-api)
15. [Custom styles](#custom-styles)
16. [Built-in shortcuts](#built-in-shortcuts)
17. [Migrating from 2.3](#migrating-from-23)
18. [Notes](#notes)

---

## Features

- Three ready-to-use window styles selectable with a single option
- Controls: buttons, toggles, checkboxes, sliders, progress bars, textboxes, dropdowns (single and multi-select), keybinds, color pickers, language picker, theme picker, labels, paragraphs, dividers
- Collapsible, nestable sections
- Built-in localization: nine languages, live switching, auto-detection, and per-element translations for your own text
- Notifications with four types, click callbacks, auto-sizing for long text, and a configurable stack limit
- Theme engine with seven built-in accent colors, dark and light modes, and runtime custom themes. Theme and mode names are accepted in every supported language
- Global search across every tab and control (Ctrl+K)
- Flags with save, load, delete, export, import, and auto-save support
- Per-element `SetVisible` and `SetLocked`
- Player profile card with avatar, streamer mode, and premium badge
- Performance mode that disables decorative effects and blur
- Draggable and resizable window, adjustable UI scale, optional background blur
- Floating launcher button for touch devices
- Tooltips, right-click reset, and double-tap slider reset
- Automatic compact layout on small screens

---

## Installation

Load the library with `loadstring`:

```lua
local Ghostline = loadstring(game:HttpGet("https://raw.githubusercontent.com/nyxoo-lua/GhostLine-UI-Lua/refs/heads/main/GhostLine-main.lua"))()
```

The GUI is mounted in `gethui()` when available, otherwise in `CoreGui`, and falls back to `PlayerGui`.

Configuration saving needs the file functions `writefile`, `readfile`, `isfile`, `listfiles`, and `makefolder`. Deleting a configuration also needs `delfile`, and copying one needs `setclipboard`. Without them, everything else still works.

---

## Quick start

```lua
local Ghostline = loadstring(game:HttpGet("https://raw.githubusercontent.com/nyxoo-lua/GhostLine-UI-Lua/refs/heads/main/GhostLine-main.lua"))()

local Window = Ghostline.new({
	Name = "My Script",
	Subtitle = "v1.0.0",
	Style = "Ghostline",
	Language = "en",
})

local Main = Window:MakeTab({ Name = "Main" })

Main:MakeButton({
	Name = "Say hello",
	Callback = function()
		Ghostline:Notify({ Title = "Hello", Content = "It works.", Type = "Success" })
	end,
})

Main:MakeToggle({
	Name = "Enabled",
	Default = false,
	Flag = "enabled",
	Callback = function(value)
		print("Enabled:", value)
	end,
})

Window:MakeSettingsTab()
```

---

## Window styles

Choose a style when creating the window with the `Style` option.

| Style | Description |
|---|---|
| `"Ghostline"` | Default. Glass look with animated orbs, a rotating gradient border, an animated accent bar, and a left sidebar. |
| `"Rayfield"` | Flat dark-gray window with a blue accent. Tabs are pills in a horizontal bar at the top, and the profile collapses into a small avatar in the header. |
| `"Orion"` | Flat midnight-blue window with a left sidebar. Controls are bordered boxes and the toggle is a checkbox with a drawn check mark. |

The Rayfield and Orion styles are inspired by the libraries they are named after. They are not exact copies.

```lua
local Window = Ghostline.new({ Name = "My Script", Style = "Orion" })
```

The `Theme` option only changes the accent color of Rayfield and Orion, keeping their base grays.

---

## Creating a window

`Ghostline.new(config)` returns a window object. `Ghostline.CreateWindow` is an alias.

| Option | Type | Default | Description |
|---|---|---|---|
| `Name` | string | `"Ghostline OS"` | Window title. |
| `Subtitle` | string | none | Small text under the title. |
| `Style` | string | `"Ghostline"` | `"Ghostline"`, `"Rayfield"`, `"Orion"`, or any custom style. |
| `Language` | string | `"en"` | Interface language. A code, a language name, a Roblox locale such as `"fr-fr"`, or `"auto"`. |
| `Theme` | string | `"Red"` | Accent theme name, in any supported language. |
| `Mode` | string | `"dark"` | `"dark"` or `"light"`, in any supported language. |
| `Size` | Vector2 | depends on style | Initial window size. |
| `Compact` | boolean | automatic | Force the compact sidebar on or off. |
| `ToggleKey` | Enum.KeyCode | `RightShift` | Key that shows and hides the window. |
| `Blur` | boolean | `true` | Blur the game behind the window. |
| `BlurSize` | number | `14` | Blur intensity. |
| `Performance` | boolean | `false` | Start in [performance mode](#performance-mode). |
| `Launcher` | boolean | `true` on touch devices | Floating draggable button that toggles the window. |
| `Profile` | table | see below | Profile card options. |

Profile options:

| Option | Type | Description |
|---|---|---|
| `ShowAvatar` | boolean | Show the player avatar. |
| `ShowName` | boolean | Show the player name. |
| `Streamer` | boolean | Hide the player name everywhere. |
| `Premium` | boolean | Show the premium badge and gold ring. |
| `PremiumLabel` | string | Badge text when premium. |
| `FreeLabel` | string | Badge text when not premium. |
| `DisplayName` | string | Override the displayed name. |
| `Username` | string | Override the username. |
| `Image` | string | Custom avatar image. |

```lua
local Window = Ghostline.new({
	Name = "Ghostline OS",
	Subtitle = "Test Suite",
	Style = "Rayfield",
	Language = "auto",
	Theme = "Blue",
	Size = Vector2.new(580, 410),
	ToggleKey = Enum.KeyCode.RightShift,
	Profile = {
		Premium = true,
		PremiumLabel = "VIP BETA",
	},
})
```

---

## Tabs and sections

### Tabs

```lua
local Tab = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://0000000000" })
local Tab2 = Window:MakeTab("Visuals")
```

`Icon` is optional. `Window.CreateTab` is an alias of `MakeTab`. Tab names can be [translation tables](#translating-your-own-text).

`Window:MakeSettingsTab({ Name = "Settings" })` adds a ready-made settings tab with a theme picker, language picker, interface scale, glass opacity, animation speed, blur, performance mode, compact sidebar, toggle key, profile options, and full configuration management. It follows the current language.

### Sections

Sections are collapsible groups. They support every element type and can be nested.

```lua
local Section = Tab:MakeSection({ Name = "Aimbot", Open = true })
Section:MakeToggle({ Name = "Enabled" })

local Advanced = Section:MakeSection({ Name = "Advanced", Open = false })
Advanced:MakeSlider({ Name = "Smoothness", Min = 0, Max = 10, Default = 3 })
```

---

## Elements

Every element can be created on a tab or on a section. Most accept these common options:

| Option | Description |
|---|---|
| `Name` | Label shown on the row. |
| `Callback` | Function called when the value changes. |
| `Default` | Initial value. |
| `Flag` | Unique key used to store the value for configurations. |
| `Tooltip` | Text shown when hovering the row. |
| `Locked` | Start the element locked and dimmed. |
| `Visible` | Set to `false` to start the element hidden. |

Elements with a value also have `:Set(value, silent)` and `:Get()`. Passing `true` as `silent` updates the element without calling the callback. Every element created through a `Make` function also has:

| Method | Description |
|---|---|
| `:Destroy()` | Remove the element. |
| `:SetVisible(visible)` | Show or hide the row. |
| `:SetLocked(locked)` | Dim the row and block all input on it. Code can still call `:Set()`. |

Right-clicking (or long-pressing on touch) a row resets it to its initial value, unless it is locked.

### Label

```lua
local label = Tab:MakeLabel("Some text")
label:Set("Updated text")
```

### Paragraph

```lua
local paragraph = Tab:MakeParagraph({ Title = "About", Content = "A block of text that wraps and grows." })
paragraph:Set("New title", "New content")
```

### Divider

```lua
Tab:MakeDivider()
```

### Button

```lua
local button = Tab:MakeButton({
	Name = "Run",
	Callback = function()
		print("Clicked")
	end,
})
button:SetText("Running...")
```

### Toggle

```lua
local toggle = Tab:MakeToggle({
	Name = "Enabled",
	Default = false,
	Flag = "enabled",
	Callback = function(value)
		print(value)
	end,
})
toggle:Set(true)
```

The toggle is a pill in the Ghostline and Rayfield styles, and a checkbox in the Orion style.

### Checkbox

```lua
local checkbox = Tab:MakeCheckbox({
	Name = "Show names",
	Default = true,
	Callback = function(value)
		print(value)
	end,
})
```

### Slider

| Option | Description |
|---|---|
| `Min`, `Max` | Value range. |
| `Increment` | Step size, decimals are supported. |
| `Suffix` | Text appended to the displayed value. |

```lua
Tab:MakeSlider({
	Name = "Speed",
	Min = 0,
	Max = 100,
	Default = 16,
	Increment = 1,
	Suffix = " st/s",
	Flag = "speed",
	Callback = function(value)
		print(value)
	end,
})
```

Double-clicking a slider restores its default value.

### Progress bar

```lua
local progress = Tab:MakeProgressBar({ Name = "Loading", Default = 0 })
progress:Set(0.5)
```

The value goes from `0` to `1`.

### Textbox

```lua
Tab:MakeTextbox({
	Name = "Username",
	Default = "",
	Placeholder = "Type here...",
	ClearOnFocus = false,
	Flag = "username",
	Callback = function(text)
		print(text)
	end,
})
```

### Dropdown

Set `Multi = true` for multi-select. A single dropdown returns a string and a multi dropdown returns a table.

```lua
local dropdown = Tab:MakeDropdown({
	Name = "Target",
	Options = { "Head", "Torso", "Legs" },
	Default = "Head",
	Flag = "target",
	Callback = function(value)
		print(value)
	end,
})

local multi = Tab:MakeDropdown({
	Name = "Parts",
	Multi = true,
	Options = { "Head", "Torso", "Legs" },
	Default = { "Head" },
	Callback = function(values)
		print(table.concat(values, ", "))
	end,
})

dropdown:Refresh({ "Head", "Torso", "Legs", "Arms" })
```

### Keybind

`Mode` is `"Press"` (callback fires on key down) or `"Hold"` (callback receives `true` on press and `false` on release). `Changed` fires when the user rebinds the key.

```lua
Tab:MakeKeybind({
	Name = "Fly",
	Default = Enum.KeyCode.F,
	Mode = "Hold",
	Flag = "fly_key",
	Callback = function(isDown)
		print(isDown)
	end,
	Changed = function(key)
		print(key.Name)
	end,
})
```

### Color picker

```lua
Tab:MakeColorPicker({
	Name = "ESP color",
	Default = Color3.fromRGB(255, 45, 85),
	Flag = "esp_color",
	Callback = function(color)
		print(color)
	end,
})
```

### Theme picker

Adds a control to switch the accent color and the dark or light mode. Without a `Name`, it uses the localized word for "Theme".

```lua
Tab:MakeThemePicker({ Flag = "theme" })
```

### Language picker

Adds a dropdown listing every registered language by its native name. Choosing one switches the whole interface instantly, and the dropdown stays in sync when the language is changed from code.

```lua
Tab:MakeLanguagePicker({
	Flag = "language",
	Callback = function(code)
		print("Language is now", code)
	end,
})
```

---

## Localization

Ghostline translates all of its own text (settings tab, profile panel, search, dropdown placeholders, theme picker, error messages) and lets you translate yours.

Built-in languages:

| Code | Language |
|---|---|
| `en` | English |
| `fr` | Français |
| `de` | Deutsch |
| `es` | Español |
| `it` | Italiano |
| `pt` | Português |
| `nl` | Nederlands |
| `pl` | Polski |
| `tr` | Türkçe |

### Choosing a language

```lua
local Window = Ghostline.new({ Name = "My Script", Language = "de" })

Ghostline:SetLanguage("fr")
Ghostline:SetLanguage("Deutsch")
Ghostline:SetLanguage("es-ES")
Ghostline:SetLanguage("auto")
```

`SetLanguage` accepts a code, a language name in English or in the language itself, a Roblox locale id, or `"auto"` to follow the player's Roblox locale. It returns `true`, or `false` and an error message for unknown languages. Switching is live: every visible built-in text updates immediately, with no rebuild.

### Translating your own text

Anywhere an element takes `Name`, `Title`, `Content`, `Placeholder`, or `Tooltip`, you can pass a table of translations instead of a string. The same works for tab names, section names, and labels.

```lua
local Combat = Window:MakeTab({
	Name = { en = "Combat", fr = "Combat", de = "Kampf", es = "Combate" },
})

Combat:MakeSlider({
	Name = { en = "Speed", fr = "Vitesse", de = "Geschwindigkeit", es = "Velocidad" },
	Min = 0,
	Max = 100,
	Default = 16,
	Tooltip = { en = "Right-click to reset", fr = "Clic droit pour réinitialiser" },
})
```

Resolution order: the current language, then English, then the first entry in the table. The text updates by itself whenever the language changes, and search results follow it.

To reuse a built-in string, use `Ghostline.Loc`:

```lua
Combat:MakeButton({ Name = Ghostline.Loc("save") })
```

### Reading translations

```lua
Ghostline:Translate("save")
Ghostline:Translate("days", 7)
Ghostline:ThemeLabel("Red")
Ghostline:GetLanguages()
```

`GetLanguages` returns a list of `{ Code, Name }` entries in display order.

### Adding a language

```lua
Ghostline:AddLanguage("sv", "Svenska", {
	save = "Spara",
	load = "Ladda",
	settings = "Inställningar",
	language = "Språk",
})
Ghostline:SetLanguage("sv")
```

Missing keys fall back to English. The new language appears in every language picker created afterward.

### Reacting to changes

```lua
local connection = Ghostline:OnLanguageChanged(function(code)
	print("Switched to", code)
end)

connection:Disconnect()
```

### Translation keys

`search`, `none`, `no_results`, `tab_label`, `dark`, `light`, `theme`, `theme_tip`, `settings`, `appearance`, `interface`, `ui_scale`, `ui_scale_tip`, `glass`, `anim_speed`, `blur`, `compact`, `compact_tip`, `toggle_key`, `language`, `profile`, `show_avatar`, `show_name`, `streamer`, `streamer_long`, `configs`, `cfg_name`, `cfg_existing`, `save`, `load`, `delete`, `export_cfg`, `import_cfg`, `import_ph`, `auto_save`, `auto_save_tip`, `cfg_saved`, `cfg_loaded`, `cfg_deleted`, `cfg_exported`, `cfg_imported`, `failed`, `tips`, `tips_body`, `perf`, `perf_tip`, `guest`, `yes`, `no`, `user_id`, `roblox_premium`, `account_age`, `days`, `session`, `performance`, `privacy`, `profile_hidden`, `err_fs`, `err_missing`, `err_corrupt`, `err_theme`, `err_callback`, `err_lang`, `theme_Red`, `theme_Pink`, `theme_Purple`, `theme_Blue`, `theme_Green`, `theme_Yellow`, `theme_Black`.

Some values take `string.format` arguments, such as `days` (`"%d days"`) and the `err_*` messages.

---

## Notifications

```lua
Ghostline:Notify({
	Title = "Saved",
	Content = "Your configuration was saved.",
	Type = "Success",
	Time = 4,
	Callback = function()
		print("Notification clicked")
	end,
})
```

| Option | Description |
|---|---|
| `Title` | Notification title. |
| `Content` | Body text. The card grows to fit long text. |
| `Type` | `"Info"`, `"Success"`, `"Warning"`, or `"Error"`. |
| `Time` | Duration in seconds, default `4`. `Duration` is also accepted. |
| `Callback` | Function called when the player clicks the notification. |

Clicking a notification also dismisses it. At most `Ghostline.MaxNotifications` (default `5`) are shown at once, and the oldest is dismissed when a new one pushes past the limit. `Window:Notify(config)` and `Ghostline:MakeNotification(config)` are aliases. Notifications follow the style of the most recently created window.

---

## Themes and modes

Built-in accent themes: `Red`, `Pink`, `Purple`, `Blue`, `Green`, `Yellow`, `Black`.

```lua
Ghostline:SetTheme("Purple")
Ghostline:SetTheme("Blue", "light")
Ghostline:SetMode("dark")
Ghostline:ToggleMode()

Ghostline:AddTheme("Cyan", Color3.fromRGB(0, 220, 220))
Ghostline:SetTheme("Cyan")
```

Theme and mode names are case-insensitive and accepted in every built-in language, so `"Rouge"`, `"rot"`, `"azul"`, and `"hell"` all work. Existing scripts that use the old French names keep working.

Every color in the interface updates live with a smooth transition. Current values are available in `Ghostline.CurrentTheme` and `Ghostline.CurrentMode`, and the full list in `Ghostline.ThemeOrder`.

---

## Flags and configurations

Any element with a `Flag` is registered in `Ghostline.Flags` and saved with configurations.

```lua
Ghostline:GetFlag("speed")
Ghostline:SetFlag("speed", 50)
Ghostline:SetFlag("speed", 50, true)

Ghostline:SaveConfig("default")
Ghostline:LoadConfig("default")
Ghostline:DeleteConfig("default")
Ghostline:ListConfigs()
Ghostline:EnableAutoSave("default", 2)

local json = Ghostline:ExportConfig()
Ghostline:ImportConfig(json)
```

- Configurations are stored as JSON files in the folder named by `Ghostline.ConfigFolder` (default `"Ghostline"`).
- `SaveConfig`, `LoadConfig`, `DeleteConfig`, and `ImportConfig` return `success, error`, with the error already translated into the current language.
- `ExportConfig` returns the current values as a JSON string, and `ImportConfig` applies one. Use them to share settings without touching the file system.
- `EnableAutoSave(name, delay)` saves automatically after every change, with the given delay in seconds. Disable it with `Ghostline._auto = nil`.
- `GetFlag` and `SetFlag` read and write a flagged element by key. The optional third argument of `SetFlag` skips the callback.

---

## Performance mode

For weaker devices, performance mode pauses every infinite animation (the rotating border, the drifting orbs), hides the decorative sheen, and turns the background blur off. The previous blur setting is restored when you switch back.

```lua
local Window = Ghostline.new({ Name = "My Script", Performance = true })

Window:SetPerformanceMode(true)
Window:SetPerformanceMode(false)
print(Window.Performance)
```

The settings tab includes a toggle for it. It has no visible effect on the flat Rayfield and Orion styles apart from the blur.

---

## Window API

| Method | Description |
|---|---|
| `Window:Toggle(state)` | Show or hide the window. Without an argument it flips the current state. |
| `Window:Minimize(state)` | Collapse the window to its title bar, or restore it. |
| `Window:Center()` | Move the window to the center of the screen. |
| `Window:SelectTab(tab)` | Select a tab by object or by name. |
| `Window:SetUserScale(scale)` | Scale the whole interface, from `0.6` to `1.5`. |
| `Window:SetGlass(alpha)` | Set the window background transparency, from `0` to `0.9`. |
| `Window:SetBlur(enabled)` | Enable or disable the background blur. |
| `Window:SetPerformanceMode(enabled)` | Enable or disable performance mode. |
| `Window:SetCompact(enabled)` | Force the compact sidebar. No effect in the Rayfield style. |
| `Window:SetLanguage(code)` | Same as `Ghostline:SetLanguage`. |
| `Window:SetProfile(table)` | Update profile fields such as `DisplayName`, `Username`, or `Image`. |
| `Window:SetProfileVisibility(avatar, name)` | Show or hide the avatar and the name. Pass `nil` to leave one unchanged. |
| `Window:SetStreamer(enabled)` | Hide the player name throughout the interface. |
| `Window:SetPremium(enabled, label)` | Toggle the premium badge and optionally change its label. |
| `Window:OpenProfile()` / `Window:CloseProfile()` | Open or close the profile panel. |
| `Window:Notify(config)` | Show a notification. |
| `Window:Destroy()` | Close and clean up the window. |

Useful fields: `Window.Visible`, `Window.Minimized`, `Window.Compact`, `Window.Performance`, `Window.Destroyed`, `Window.ToggleKey`, `Window.Tabs`, `Window.CurrentTab`.

---

## Global API

| Member | Description |
|---|---|
| `Ghostline.new(config)` | Create a window. |
| `Ghostline:Notify(config)` | Show a notification. |
| `Ghostline:SetLanguage(code)` | Switch the interface language. |
| `Ghostline:AddLanguage(code, name, dictionary)` | Register a language. |
| `Ghostline:GetLanguages()` | List registered languages. |
| `Ghostline:OnLanguageChanged(fn)` | Listen for language changes. Returns an object with `:Disconnect()`. |
| `Ghostline:Translate(key, ...)` | Translate a built-in key with optional format arguments. |
| `Ghostline.Loc(key, ...)` | Build a translation reference for use in `Name`, `Title`, and similar fields. |
| `Ghostline:ThemeLabel(name)` | Localized display name of a theme. |
| `Ghostline:SetTheme(name, mode)` | Apply a theme and optionally a mode. |
| `Ghostline:SetMode(mode)` / `Ghostline:ToggleMode()` | Switch between dark and light. |
| `Ghostline:AddTheme(name, color)` | Register a new accent theme. |
| `Ghostline:AddStyle(name, definition)` | Register a custom window style. |
| `Ghostline:SaveConfig(name)` / `LoadConfig(name)` / `DeleteConfig(name)` / `ListConfigs()` | Configuration management. |
| `Ghostline:ExportConfig()` / `ImportConfig(json)` | Share configurations as JSON text. |
| `Ghostline:GetFlag(flag)` / `SetFlag(flag, value, silent)` | Read and write flagged elements. |
| `Ghostline:EnableAutoSave(name, delay)` | Save on every change. |
| `Ghostline:Destroy()` | Destroy every window and the GUI. |
| `Ghostline.Flags` | Table of all flagged elements. |
| `Ghostline.Language` | Current language code. |
| `Ghostline.MaxNotifications` | Maximum notifications on screen, default `5`. |
| `Ghostline.AnimSpeed` | Animation speed multiplier, `1` is normal. |
| `Ghostline.Styles` / `Ghostline.StyleOrder` | Registered styles. |
| `Ghostline.Version` | Library version string. |

---

## Custom styles

`Ghostline:AddStyle(name, definition)` registers a new style. Any field you leave out is inherited from the default Ghostline style.

```lua
Ghostline:AddStyle("Slate", {
	Layout = "Side",
	Header = 40,
	WindowRadius = 6,
	RowRadius = 4,
	MainAlpha = 0,
	RowAlpha = 0,
	MainGradient = false,
	RowGradient = false,
	Orbs = false,
	Sheen = false,
	SpinStroke = false,
	AccentBar = false,
	TitleGradient = false,
	Toggle = "Box",
	LauncherText = "S",
	Palette = {
		BackgroundPrimary = Color3.fromRGB(18, 20, 24),
		BackgroundSecondary = Color3.fromRGB(26, 29, 34),
		GlassTint = Color3.fromRGB(36, 40, 47),
		Border = Color3.fromRGB(58, 64, 74),
		Text = Color3.fromRGB(235, 238, 242),
		SubText = Color3.fromRGB(150, 156, 166),
		AccentGlow = Color3.fromRGB(120, 200, 120),
		AccentDeep = Color3.fromRGB(70, 140, 70),
		AccentSoft = Color3.fromRGB(170, 230, 170),
	},
})

local Window = Ghostline.new({ Name = "My Script", Style = "Slate" })
```

Main style fields:

| Field | Description |
|---|---|
| `Layout` | `"Side"` for a left sidebar or `"Top"` for a horizontal tab bar. |
| `Header` | Title bar height. |
| `Size` | Default window size (Vector2). |
| `Sidebar` | Sidebar width. |
| `WindowRadius`, `PanelRadius`, `SidebarRadius`, `TabRadius`, `RowRadius`, `SectionRadius`, `NotifRadius` | Corner radii. |
| `MainAlpha`, `RowAlpha`, `RowHoverAlpha`, `SidebarAlpha`, `TabActiveAlpha` | Transparency values. |
| `MainGradient`, `RowGradient`, `TabFlat`, `TitleGradient` | Gradient and flat-fill switches. |
| `Orbs`, `Sheen`, `SpinStroke`, `AccentBar`, `Indicator` | Decorative effects. |
| `RowHoverStroke` | Highlight the row border on hover. |
| `Toggle` | `"Pill"` or `"Box"`. |
| `LauncherText` | Text on the floating launcher button. |
| `Palette` | Optional base colors applied when the style is used. |

---

## Built-in shortcuts

| Action | Shortcut |
|---|---|
| Show or hide the window | `RightShift` (configurable with `ToggleKey`) |
| Global search | `Ctrl + K` |
| Close the profile panel | `Escape` |
| Reset an element | Right-click, or long-press on touch |
| Reset a slider | Double-click or double-tap |
| Dismiss a notification | Click it |

---

## Migrating from 2.3

- **Default language is now English.** Version 2.3 was French only. Pass `Language = "fr"` to keep the previous text.
- **Theme keys are English.** The names in `Ghostline.Themes` and `Ghostline.ThemeOrder` are now `Red`, `Pink`, `Purple`, `Blue`, `Green`, `Yellow`, `Black`. The old French names (`Rouge`, `Bleu`, and so on) are still accepted by `SetTheme`, `Theme`, and saved configurations through aliases.
- **No emoji.** The search box placeholder and the premium badge no longer include symbols.
- **Mode names.** `"clair"` and `"sombre"` still work, along with their equivalents in the other languages.

---

## Notes

- Only one palette is active at a time. If you create windows with different styles, the most recently created one sets the colors.
- The style is chosen when the window is created and cannot be changed afterward. The language can be changed at any time.
- `Mode = "light"` uses the generated light palette rather than the gray base of Rayfield and Orion.
- Plain strings you pass as `Name` are never translated. Use a translation table to make them follow the language.
- Languages are limited to scripts supported by the Gotham font family, which covers Latin-based languages.
- On narrow screens the sidebar switches to compact mode automatically, and touch devices get larger hit areas.
