# Ghostline UI

A modern, animated UI library for Roblox. Ghostline ships with three window styles, a full set of controls, a built-in theme engine, notifications, global search, configuration saving, and first-class mobile support.

- **Version:** 2.3.0
- **Language:** Luau
- **Styles:** Ghostline (Our UI), Rayfield, Orion

---

## Table of contents

1. [Features](#features)
2. [Installation](#installation)
3. [Quick start](#quick-start)
4. [Window styles](#window-styles)
5. [Creating a window](#creating-a-window)
6. [Tabs and sections](#tabs-and-sections)
7. [Elements](#elements)
8. [Notifications](#notifications)
9. [Themes and modes](#themes-and-modes)
10. [Flags and configurations](#flags-and-configurations)
11. [Window API](#window-api)
12. [Global API](#global-api)
13. [Custom styles](#custom-styles)
14. [Built-in shortcuts](#built-in-shortcuts)
15. [Notes](#notes)

---

## Features

- Three ready-to-use window styles selectable with a single option
- Controls: buttons, toggles, checkboxes, sliders, progress bars, textboxes, dropdowns (single and multi-select), keybinds, color pickers, labels, paragraphs, dividers
- Collapsible, nestable sections
- Notification system with four types and auto-sizing for long text
- Theme engine with seven built-in accent colors, dark and light modes, and runtime custom themes
- Global search across every tab and control (Ctrl+K)
- Flags with save, load, and auto-save configuration support
- Player profile card with avatar, streamer mode, and premium badge
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

Configuration saving requires the file functions `writefile`, `readfile`, `isfile`, `listfiles`, and `makefolder`. Without them, everything else still works.

---

## Quick start

```lua
local Ghostline = loadstring(game:HttpGet("https://raw.githubusercontent.com/nyxoo-lua/GhostLine-UI-Lua/refs/heads/main/GhostLine-main.lua"))()

local Window = Ghostline.new({
	Name = "My Script",
	Subtitle = "v1.0.0",
	Style = "Ghostline",
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
| `Theme` | string | `"Rouge"` | Accent theme name. See [Themes and modes](#themes-and-modes). |
| `Mode` | string | `"dark"` | `"dark"` or `"light"`. |
| `Size` | Vector2 | depends on style | Initial window size. |
| `Compact` | boolean | automatic | Force the compact sidebar on or off. |
| `ToggleKey` | Enum.KeyCode | `RightShift` | Key that shows and hides the window. |
| `Blur` | boolean | `true` | Blur the game behind the window. |
| `BlurSize` | number | `14` | Blur intensity. |
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
	Theme = "Bleu",
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

`Icon` is optional. `Window.CreateTab` is an alias of `MakeTab`.

`Window:MakeSettingsTab({ Name = "Settings" })` adds a ready-made settings tab with a theme picker, interface scale, glass opacity, animation speed, blur, compact sidebar, toggle key, profile options, and configuration management.

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

Elements with a value also have `:Set(value, silent)` and `:Get()`. Passing `true` as `silent` updates the element without calling the callback. Every element has `:Destroy()`. Right-clicking (or long-pressing on touch) a row resets it to its initial value.

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

Adds a control to switch the accent color and the dark or light mode.

```lua
Tab:MakeThemePicker({ Name = "Theme", Flag = "theme" })
```

---

## Notifications

```lua
Ghostline:Notify({
	Title = "Saved",
	Content = "Your configuration was saved.",
	Type = "Success",
	Time = 4,
})
```

| Option | Description |
|---|---|
| `Title` | Notification title. |
| `Content` | Body text. The card grows to fit long text. |
| `Type` | `"Info"`, `"Success"`, `"Warning"`, or `"Error"`. |
| `Time` | Duration in seconds, default `4`. `Duration` is also accepted. |

Click a notification to dismiss it. `Window:Notify(config)` and `Ghostline:MakeNotification(config)` are aliases. Notifications follow the style of the most recently created window.

---

## Themes and modes

Built-in accent themes: `Rouge`, `Rose`, `Violet`, `Bleu`, `Vert`, `Jaune`, `Noir`.

```lua
Ghostline:SetTheme("Violet")
Ghostline:SetTheme("Bleu", "light")
Ghostline:SetMode("dark")
Ghostline:ToggleMode()

Ghostline:AddTheme("Cyan", Color3.fromRGB(0, 220, 220))
Ghostline:SetTheme("Cyan")
```

Every color in the interface updates live with a smooth transition. Current values are available in `Ghostline.CurrentTheme` and `Ghostline.CurrentMode`, and the full list in `Ghostline.ThemeOrder`.

---

## Flags and configurations

Any element with a `Flag` is registered in `Ghostline.Flags` and saved with configurations.

```lua
Ghostline.Flags["speed"]:Get()
Ghostline.Flags["speed"]:Set(50)

Ghostline:SaveConfig("default")
Ghostline:LoadConfig("default")
Ghostline:ListConfigs()
Ghostline:EnableAutoSave("default", 2)
```

- Configurations are stored as JSON files in the folder named by `Ghostline.ConfigFolder` (default `"Ghostline"`).
- `SaveConfig` and `LoadConfig` return `success, error`.
- `EnableAutoSave(name, delay)` saves automatically after every change, with the given delay in seconds. Disable it with `Ghostline._auto = nil`.

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
| `Window:SetCompact(enabled)` | Force the compact sidebar. No effect in the Rayfield style. |
| `Window:SetProfile(table)` | Update profile fields such as `DisplayName`, `Username`, or `Image`. |
| `Window:SetProfileVisibility(avatar, name)` | Show or hide the avatar and the name. Pass `nil` to leave one unchanged. |
| `Window:SetStreamer(enabled)` | Hide the player name throughout the interface. |
| `Window:SetPremium(enabled, label)` | Toggle the premium badge and optionally change its label. |
| `Window:OpenProfile()` / `Window:CloseProfile()` | Open or close the profile panel. |
| `Window:Notify(config)` | Show a notification. |
| `Window:Destroy()` | Close and clean up the window. |

Useful fields: `Window.Visible`, `Window.Minimized`, `Window.Compact`, `Window.Destroyed`, `Window.ToggleKey`, `Window.Tabs`, `Window.CurrentTab`.

---

## Global API

| Member | Description |
|---|---|
| `Ghostline.new(config)` | Create a window. |
| `Ghostline:Notify(config)` | Show a notification. |
| `Ghostline:SetTheme(name, mode)` | Apply a theme and optionally a mode. |
| `Ghostline:SetMode(mode)` / `Ghostline:ToggleMode()` | Switch between dark and light. |
| `Ghostline:AddTheme(name, color)` | Register a new accent theme. |
| `Ghostline:AddStyle(name, definition)` | Register a custom window style. |
| `Ghostline:SaveConfig(name)` / `LoadConfig(name)` / `ListConfigs()` | Configuration management. |
| `Ghostline:EnableAutoSave(name, delay)` | Save on every change. |
| `Ghostline:Destroy()` | Destroy every window and the GUI. |
| `Ghostline.Flags` | Table of all flagged elements. |
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

## Notes

- Only one palette is active at a time. If you create windows with different styles, the most recently created one sets the colors.
- The style is chosen when the window is created and cannot be changed afterward.
- `Mode = "light"` uses the generated light palette rather than the gray base of Rayfield and Orion.
- On narrow screens the sidebar switches to compact mode automatically, and touch devices get larger hit areas.
