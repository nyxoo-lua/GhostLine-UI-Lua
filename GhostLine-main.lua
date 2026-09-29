--[[
    ╔═══════════════════════════════════════════════╗
    ║   GHOSTLINE UI LIBRARY  v2.0                  ║
    ║   Liquid Glass · Red Gradient · Fluid Anims   ║
    ╚═══════════════════════════════════════════════╝

    Composants : Window, Tab, Section (repliable), Label, Paragraph, Button,
                 Toggle, Checkbox, Slider, Textbox, Dropdown (simple/multi),
                 Keybind (Press/Hold), ColorPicker (HSV + hex), ProgressBar,
                 Divider, Notifications, Recherche, Flags + Save/Load config.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local Ghostline = {}
Ghostline.__index = Ghostline
Ghostline.Version = "2.0.0"
Ghostline.Flags = {}
Ghostline.Windows = {}
Ghostline.ConfigFolder = "Ghostline"

Ghostline.Theme = {
	BackgroundPrimary = Color3.fromRGB(14, 6, 8),
	BackgroundSecondary = Color3.fromRGB(28, 9, 13),
	GlassTint = Color3.fromRGB(52, 12, 22),
	AccentGlow = Color3.fromRGB(255, 45, 85),
	AccentDeep = Color3.fromRGB(150, 8, 40),
	AccentSoft = Color3.fromRGB(255, 120, 140),
	Text = Color3.fromRGB(250, 240, 242),
	SubText = Color3.fromRGB(175, 145, 150),
	Border = Color3.fromRGB(95, 25, 42),
	Success = Color3.fromRGB(70, 220, 130),
	Warning = Color3.fromRGB(255, 190, 60),
	Error = Color3.fromRGB(255, 70, 70),
}
local Theme = Ghostline.Theme

local EASE = Enum.EasingStyle
local DIR = Enum.EasingDirection
local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)

----------------------------------------------------------------------
-- UTILITAIRES
----------------------------------------------------------------------

local function Tween(obj, time, props, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or EASE.Quart, dir or DIR.Out), props)
	t:Play()
	return t
end

local function New(class, props, children)
	local inst = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then
			parent = v
		else
			inst[k] = v
		end
	end
	for _, c in ipairs(children or {}) do
		c.Parent = inst
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function Corner(parent, radius)
	return New("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

local function Stroke(parent, color, thickness, transparency)
	return New("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

-- stops = {{pos, Color3}, ...}  |  transparency = {{pos, value}, ...}
local function Gradient(parent, stops, rotation, transparency)
	local keys = {}
	for _, s in ipairs(stops) do
		table.insert(keys, ColorSequenceKeypoint.new(s[1], s[2]))
	end
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(keys)
	g.Rotation = rotation or 0
	if transparency then
		local tk = {}
		for _, s in ipairs(transparency) do
			table.insert(tk, NumberSequenceKeypoint.new(s[1], s[2]))
		end
		g.Transparency = NumberSequence.new(tk)
	end
	g.Parent = parent
	return g
end

local function TextLabel(props)
	local p = {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "",
		BorderSizePixel = 0,
	}
	for k, v in pairs(props) do
		p[k] = v
	end
	return New("TextLabel", p)
end

local function safe(cb, ...)
	if type(cb) ~= "function" then
		return
	end
	local ok, err = pcall(cb, ...)
	if not ok then
		warn("[Ghostline] Erreur callback : " .. tostring(err))
	end
end

local function Ripple(parent, x, y)
	local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
	local c = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(x - parent.AbsolutePosition.X, y - parent.AbsolutePosition.Y),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Theme.AccentSoft,
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Corner(c, 999)
	Tween(c, 0.55, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 })
	task.delay(0.6, function()
		c:Destroy()
	end)
end

local function MountGui(gui)
	local ok = pcall(function()
		if gethui then
			gui.Parent = gethui()
		else
			gui.Parent = CoreGui
		end
	end)
	if not ok or not gui.Parent then
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
end

local function MakeDrag(Window, hit, onMove, onEnd, onStart)
	local dragging = false
	local function isPointer(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
	end
	Window._track(hit.InputBegan, function(input)
		if isPointer(input) then
			dragging = true
			if onStart then
				onStart(input.Position)
			end
			onMove(input.Position)
		end
	end)
	Window._track(UserInputService.InputChanged, function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			onMove(input.Position)
		end
	end)
	Window._track(UserInputService.InputEnded, function(input)
		if dragging and isPointer(input) then
			dragging = false
			if onEnd then
				onEnd()
			end
		end
	end)
end

local function toHex(c)
	return string.format("#%02X%02X%02X", math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
end

----------------------------------------------------------------------
-- ROOT GUI + NOTIFICATIONS
----------------------------------------------------------------------

do
	local function killOld(container)
		pcall(function()
			local old = container:FindFirstChild("GhostlineLiquidUI")
			if old then
				old:Destroy()
			end
		end)
	end
	killOld(CoreGui)
	pcall(function()
		if gethui then
			killOld(gethui())
		end
	end)
	if Players.LocalPlayer then
		local pg = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if pg then
			killOld(pg)
		end
	end
end

local ScreenGui = New("ScreenGui", {
	Name = "GhostlineLiquidUI",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})
MountGui(ScreenGui)

local NotifHolder = New("Frame", {
	Name = "Notifications",
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -16, 1, -16),
	Size = UDim2.new(0, 320, 1, -32),
	Parent = ScreenGui,
})
New("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	Padding = UDim.new(0, 10),
	Parent = NotifHolder,
})

function Ghostline:Notify(cfg)
	cfg = cfg or {}
	local title = cfg.Title or "Ghostline"
	local content = cfg.Content or ""
	local duration = cfg.Time or cfg.Duration or 4
	local kinds = {
		Info = Theme.AccentGlow,
		Success = Theme.Success,
		Warning = Theme.Warning,
		Error = Theme.Error,
	}
	local color = kinds[cfg.Type or "Info"] or Theme.AccentGlow

	local textH = TextService:GetTextSize(content, 12, Enum.Font.Gotham, Vector2.new(270, 1000)).Y
	local height = 40 + textH + 16

	local Wrapper = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = NotifHolder,
	})
	local Card = New("TextButton", {
		Size = UDim2.new(1, 0, 0, height),
		Position = UDim2.new(1, 80, 0, 0),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		ClipsDescendants = true,
		Parent = Wrapper,
	})
	Corner(Card, 14)
	Gradient(Card, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundPrimary } }, 45)
	local stroke = Stroke(Card, color, 1.2, 0.35)

	New("Frame", {
		Size = UDim2.new(0, 4, 1, 0),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = Card,
	})
	TextLabel({
		Size = UDim2.new(1, -30, 0, 20),
		Position = UDim2.new(0, 18, 0, 8),
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Parent = Card,
	})
	TextLabel({
		Size = UDim2.new(1, -30, 0, textH),
		Position = UDim2.new(0, 18, 0, 30),
		Text = content,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Theme.SubText,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = Card,
	})
	local barBack = New("Frame", {
		Size = UDim2.new(1, 0, 0, 3),
		Position = UDim2.new(0, 0, 1, -3),
		BackgroundTransparency = 1,
		Parent = Card,
	})
	local bar = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Parent = barBack,
	})
	Gradient(bar, { { 0, Theme.AccentDeep }, { 1, color } }, 0)

	Tween(Wrapper, 0.4, { Size = UDim2.new(1, 0, 0, height) })
	Tween(Card, 0.6, { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.12 }, EASE.Exponential)
	Tween(bar, duration, { Size = UDim2.new(0, 0, 1, 0) }, EASE.Linear)

	local closed = false
	local function close()
		if closed then
			return
		end
		closed = true
		Tween(Card, 0.45, { Position = UDim2.new(1, 80, 0, 0), BackgroundTransparency = 1 }, EASE.Exponential, DIR.In)
		Tween(stroke, 0.3, { Transparency = 1 })
		task.wait(0.3)
		Tween(Wrapper, 0.3, { Size = UDim2.new(1, 0, 0, 0) })
		task.wait(0.32)
		Wrapper:Destroy()
	end
	Card.MouseButton1Click:Connect(function()
		task.spawn(close)
	end)
	task.delay(duration, function()
		task.spawn(close)
	end)
end

-- compatibilité avec l'ancienne API
function Ghostline:MakeNotification(cfg)
	return Ghostline:Notify(cfg)
end

----------------------------------------------------------------------
-- CONFIG (Save / Load)
----------------------------------------------------------------------

local function hasFS()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function encode(obj)
	local v = obj.Value
	if obj.Kind == "Color" then
		return { r = v.R, g = v.G, b = v.B }
	elseif obj.Kind == "Keybind" then
		return v and v.Name or "Unknown"
	end
	return v
end

local function decode(obj, data)
	if obj.Kind == "Color" and type(data) == "table" then
		return Color3.new(data.r or 1, data.g or 1, data.b or 1)
	elseif obj.Kind == "Keybind" then
		local ok, key = pcall(function()
			return Enum.KeyCode[data]
		end)
		return ok and key or Enum.KeyCode.Unknown
	end
	return data
end

function Ghostline:SaveConfig(name)
	if not hasFS() then
		return false, "Système de fichiers indisponible"
	end
	name = name or "default"
	local data = {}
	for flag, obj in pairs(Ghostline.Flags) do
		data[flag] = encode(obj)
	end
	pcall(makefolder, Ghostline.ConfigFolder)
	return pcall(writefile, Ghostline.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
end

function Ghostline:LoadConfig(name)
	if not hasFS() then
		return false, "Système de fichiers indisponible"
	end
	name = name or "default"
	local path = Ghostline.ConfigFolder .. "/" .. name .. ".json"
	if not isfile(path) then
		return false, "Config introuvable"
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)
	if not ok then
		return false, "Config corrompue"
	end
	for flag, value in pairs(data) do
		local obj = Ghostline.Flags[flag]
		if obj and obj.Set then
			pcall(obj.Set, obj, decode(obj, value))
		end
	end
	return true
end

----------------------------------------------------------------------
-- COMPOSANTS (partagés par Tab et Section)
----------------------------------------------------------------------

local function BuildElements(Target, Container, Tab, Window)
	local order = 0
	local function nextOrder()
		order += 1
		return order
	end

	local function Row(height, name, class)
		local isBtn = class == "TextButton"
		local row = New(class or "Frame", {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		if isBtn then
			row.Text = ""
			row.AutoButtonColor = false
		end
		Corner(row, 10)
		Gradient(row, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundSecondary } }, 25)
		local stroke = Stroke(row, Theme.Border, 1, 0.5)
		row.MouseEnter:Connect(function()
			Tween(stroke, 0.25, { Color = Theme.AccentGlow, Transparency = 0.15 })
			Tween(row, 0.25, { BackgroundTransparency = 0.25 })
		end)
		row.MouseLeave:Connect(function()
			Tween(stroke, 0.25, { Color = Theme.Border, Transparency = 0.5 })
			Tween(row, 0.25, { BackgroundTransparency = 0.4 })
		end)
		table.insert(Tab._elements, { Frame = row, Name = string.lower(name or "") })
		return row, stroke
	end

	local function Finish(cfg, obj)
		if cfg.Flag then
			Ghostline.Flags[cfg.Flag] = obj
		end
		function obj:Destroy()
			if obj.Instance then
				obj.Instance:Destroy()
			end
		end
		return obj
	end

	-- LABEL ----------------------------------------------------------
	function Target:MakeLabel(text)
		local lbl = TextLabel({
			Size = UDim2.new(1, 0, 0, 22),
			Text = text or "",
			TextColor3 = Theme.SubText,
			TextSize = 12,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		New("UIPadding", { PaddingLeft = UDim.new(0, 4), Parent = lbl })
		local obj = { Instance = lbl }
		function obj:Set(t)
			lbl.Text = t
		end
		return obj
	end

	-- PARAGRAPH ------------------------------------------------------
	function Target:MakeParagraph(cfg)
		local row = Row(0, cfg.Title)
		row.AutomaticSize = Enum.AutomaticSize.Y
		New("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			Parent = row,
		})
		New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row })
		local title = TextLabel({
			Size = UDim2.new(1, 0, 0, 16),
			Text = cfg.Title or "",
			Font = Enum.Font.GothamBold,
			LayoutOrder = 1,
			Parent = row,
		})
		local body = TextLabel({
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = cfg.Content or "",
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.SubText,
			TextWrapped = true,
			LayoutOrder = 2,
			Parent = row,
		})
		local obj = { Instance = row }
		function obj:Set(t, c)
			title.Text = t or title.Text
			body.Text = c or body.Text
		end
		return obj
	end

	-- DIVIDER --------------------------------------------------------
	function Target:MakeDivider()
		local d = New("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		Gradient(d, { { 0, Theme.BackgroundPrimary }, { 0.5, Theme.AccentGlow }, { 1, Theme.BackgroundPrimary } }, 0)
		return { Instance = d }
	end

	-- BUTTON ---------------------------------------------------------
	function Target:MakeButton(cfg)
		local name = cfg.Name or "Button"
		local row = Row(38, name, "TextButton")
		local fill = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = row,
		})
		Gradient(fill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		Corner(fill, 10)
		local lbl = TextLabel({
			Size = UDim2.new(1, 0, 1, 0),
			Text = name,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = row,
		})
		row.MouseEnter:Connect(function()
			Tween(fill, 0.3, { BackgroundTransparency = 0.7 })
		end)
		row.MouseLeave:Connect(function()
			Tween(fill, 0.3, { BackgroundTransparency = 1 })
		end)
		row.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Ripple(row, input.Position.X, input.Position.Y)
				Tween(fill, 0.1, { BackgroundTransparency = 0.35 })
			end
		end)
		row.MouseButton1Click:Connect(function()
			Tween(fill, 0.3, { BackgroundTransparency = 0.7 })
			safe(cfg.Callback)
		end)
		local obj = { Instance = row }
		function obj:SetText(t)
			lbl.Text = t
		end
		return Finish(cfg, obj)
	end

	-- TOGGLE ---------------------------------------------------------
	function Target:MakeToggle(cfg)
		local name = cfg.Name or "Toggle"
		local row = Row(38, name, "TextButton")
		TextLabel({ Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local track = New("Frame", {
			Size = UDim2.new(0, 44, 0, 22),
			Position = UDim2.new(1, -56, 0.5, -11),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = row,
		})
		Corner(track, 11)
		Stroke(track, Theme.Border, 1, 0.3)
		local onFill = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = track,
		})
		Gradient(onFill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		local knob = New("Frame", {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0, 3, 0.5, -8),
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(knob, 8)

		local obj = { Value = false, Instance = row, Kind = "Toggle" }
		function obj:Set(v, silent)
			v = v and true or false
			obj.Value = v
			Tween(onFill, 0.3, { BackgroundTransparency = v and 0 or 1 })
			Tween(knob, 0.4, { Position = v and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, EASE.Back)
			if not silent then
				safe(cfg.Callback, v)
			end
		end
		function obj:Get()
			return obj.Value
		end
		row.MouseButton1Click:Connect(function()
			obj:Set(not obj.Value)
		end)
		obj:Set(cfg.Default or false, true)
		return Finish(cfg, obj)
	end

	-- CHECKBOX (case à cocher) --------------------------------------
	function Target:MakeCheckbox(cfg)
		local name = cfg.Name or "Checkbox"
		local row = Row(38, name, "TextButton")
		TextLabel({ Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local box = New("Frame", {
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(1, -34, 0.5, -11),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(box, 6)
		local boxStroke = Stroke(box, Theme.Border, 1.5, 0.1)
		local fill = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = box,
		})
		Corner(fill, 4)
		Gradient(fill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 45)

		local obj = { Value = false, Instance = row, Kind = "Checkbox" }
		function obj:Set(v, silent)
			v = v and true or false
			obj.Value = v
			Tween(fill, 0.35, { Size = v and UDim2.new(1, -8, 1, -8) or UDim2.new(0, 0, 0, 0) }, EASE.Back)
			Tween(boxStroke, 0.3, { Color = v and Theme.AccentGlow or Theme.Border })
			if not silent then
				safe(cfg.Callback, v)
			end
		end
		function obj:Get()
			return obj.Value
		end
		row.MouseButton1Click:Connect(function()
			obj:Set(not obj.Value)
		end)
		obj:Set(cfg.Default or false, true)
		return Finish(cfg, obj)
	end

	-- SLIDER ---------------------------------------------------------
	function Target:MakeSlider(cfg)
		local name = cfg.Name or "Slider"
		local min, max = cfg.Min or 0, cfg.Max or 100
		local inc = cfg.Increment or 1
		local suffix = cfg.Suffix or ""
		local frac = tostring(inc):split(".")[2] or ""
		local decimals = #frac

		local row = Row(54, name)
		TextLabel({ Size = UDim2.new(0.6, 0, 0, 20), Position = UDim2.new(0, 12, 0, 7), Text = name, Parent = row })
		local valueLbl = TextLabel({
			Size = UDim2.new(0.4, -24, 0, 20),
			Position = UDim2.new(0.6, 12, 0, 7),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.AccentSoft,
			Parent = row,
		})
		local track = New("Frame", {
			Size = UDim2.new(1, -24, 0, 6),
			Position = UDim2.new(0, 12, 0, 36),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(track, 3)
		local fill = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(fill, 3)
		Gradient(fill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		local knob = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			ZIndex = 2,
			Parent = track,
		})
		Corner(knob, 9)
		Stroke(knob, Theme.AccentGlow, 2, 0)
		local hit = New("TextButton", {
			Size = UDim2.new(1, -16, 0, 26),
			Position = UDim2.new(0, 8, 0, 26),
			BackgroundTransparency = 1,
			Text = "",
			Parent = row,
		})

		local function snap(v)
			v = math.clamp(math.floor(v / inc + 0.5) * inc, min, max)
			return tonumber(string.format("%." .. decimals .. "f", v))
		end

		local obj = { Value = min, Instance = row, Kind = "Slider" }
		function obj:Set(v, silent)
			v = snap(v)
			obj.Value = v
			local a = (max == min) and 0 or (v - min) / (max - min)
			valueLbl.Text = tostring(v) .. suffix
			Tween(fill, 0.12, { Size = UDim2.new(a, 0, 1, 0) })
			Tween(knob, 0.12, { Position = UDim2.new(a, 0, 0.5, 0) })
			if not silent then
				safe(cfg.Callback, v)
			end
		end
		function obj:Get()
			return obj.Value
		end

		MakeDrag(Window, hit, function(pos)
			local a = math.clamp((pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local s = snap(min + a * (max - min))
			if s ~= obj.Value then
				obj:Set(s)
			end
		end, function()
			Tween(knob, 0.2, { Size = UDim2.new(0, 14, 0, 14) })
		end, function()
			Tween(knob, 0.25, { Size = UDim2.new(0, 18, 0, 18) }, EASE.Back)
		end)

		obj:Set(cfg.Default or min, true)
		return Finish(cfg, obj)
	end

	-- PROGRESS BAR ---------------------------------------------------
	function Target:MakeProgressBar(cfg)
		local name = cfg.Name or "Progress"
		local row = Row(46, name)
		TextLabel({ Size = UDim2.new(0.6, 0, 0, 20), Position = UDim2.new(0, 12, 0, 6), Text = name, Parent = row })
		local pct = TextLabel({
			Size = UDim2.new(0.4, -24, 0, 20),
			Position = UDim2.new(0.6, 12, 0, 6),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.AccentSoft,
			Parent = row,
		})
		local track = New("Frame", {
			Size = UDim2.new(1, -24, 0, 6),
			Position = UDim2.new(0, 12, 0, 32),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = row,
		})
		Corner(track, 3)
		local fill = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(fill, 3)
		local g = Gradient(fill, { { 0, Theme.AccentDeep }, { 0.5, Theme.AccentGlow }, { 1, Theme.AccentDeep } }, 0)
		TweenService:Create(g, TweenInfo.new(1.6, EASE.Linear, DIR.Out, -1), { Offset = Vector2.new(1, 0) }):Play()
		g.Offset = Vector2.new(-1, 0)

		local obj = { Value = 0, Instance = row, Kind = "Progress" }
		function obj:Set(a)
			a = math.clamp(a or 0, 0, 1)
			obj.Value = a
			pct.Text = math.floor(a * 100) .. "%"
			Tween(fill, 0.4, { Size = UDim2.new(a, 0, 1, 0) })
		end
		obj:Set(cfg.Default or 0)
		return Finish(cfg, obj)
	end

	-- TEXTBOX --------------------------------------------------------
	function Target:MakeTextbox(cfg)
		local name = cfg.Name or "Textbox"
		local row = Row(38, name)
		TextLabel({ Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local box = New("TextBox", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.new(0.42, 0, 0, 26),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			Text = cfg.Default or "",
			PlaceholderText = cfg.Placeholder or "...",
			PlaceholderColor3 = Theme.SubText,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			ClearTextOnFocus = cfg.ClearOnFocus or false,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(box, 7)
		local bs = Stroke(box, Theme.Border, 1, 0.4)
		box.Focused:Connect(function()
			Tween(bs, 0.25, { Color = Theme.AccentGlow, Transparency = 0 })
		end)
		local obj = { Value = box.Text, Instance = row, Kind = "Textbox" }
		box.FocusLost:Connect(function()
			Tween(bs, 0.25, { Color = Theme.Border, Transparency = 0.4 })
			obj.Value = box.Text
			safe(cfg.Callback, box.Text)
		end)
		function obj:Set(t, silent)
			box.Text = tostring(t)
			obj.Value = box.Text
			if not silent then
				safe(cfg.Callback, box.Text)
			end
		end
		return Finish(cfg, obj)
	end

	-- DROPDOWN -------------------------------------------------------
	function Target:MakeDropdown(cfg)
		local name = cfg.Name or "Dropdown"
		local multi = cfg.Multi or false
		local options = cfg.Options or {}

		local row = Row(38, name)
		local header = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundTransparency = 1,
			Text = "",
			Parent = row,
		})
		TextLabel({ Size = UDim2.new(0.5, 0, 0, 38), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = header })
		local valueLbl = TextLabel({
			Size = UDim2.new(0.5, -40, 0, 38),
			Position = UDim2.new(0.5, 0, 0, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.AccentSoft,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = header,
		})
		local arrow = TextLabel({
			Size = UDim2.new(0, 20, 0, 38),
			Position = UDim2.new(1, -28, 0, 0),
			Text = ">",
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold,
			TextColor3 = Theme.AccentGlow,
			Parent = header,
		})
		local list = New("ScrollingFrame", {
			Position = UDim2.new(0, 8, 0, 44),
			Size = UDim2.new(1, -16, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.AccentGlow,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = row,
		})
		New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

		local obj = { Options = options, Value = multi and {} or nil, Instance = row, Kind = "Dropdown" }
		local open = false
		local buttons = {}

		local function listHeight()
			return #options > 0 and (math.min(#options, 5) * 32 - 4) or 0
		end
		local function rowHeight()
			return open and (38 + 6 + listHeight() + 8) or 38
		end
		local function isSelected(opt)
			if multi then
				return table.find(obj.Value, opt) ~= nil
			end
			return obj.Value == opt
		end
		local function updateLabel()
			if multi then
				valueLbl.Text = #obj.Value == 0 and "Aucun" or table.concat(obj.Value, ", ")
			else
				valueLbl.Text = obj.Value ~= nil and tostring(obj.Value) or "Aucun"
			end
		end
		local function paint()
			for opt, b in pairs(buttons) do
				local sel = isSelected(opt)
				Tween(b, 0.2, {
					BackgroundTransparency = sel and 0.35 or 0.85,
					TextColor3 = sel and Theme.Text or Theme.SubText,
				})
			end
		end
		local function setOpen(state)
			open = state
			Tween(row, 0.4, { Size = UDim2.new(1, 0, 0, rowHeight()) }, EASE.Quart)
			Tween(list, 0.4, { Size = UDim2.new(1, -16, 0, listHeight()) }, EASE.Quart)
			Tween(arrow, 0.3, { Rotation = state and 90 or 0 })
		end

		function obj:Set(v, silent)
			if multi then
				obj.Value = type(v) == "table" and table.clone(v) or (v ~= nil and { v } or {})
			else
				obj.Value = v
			end
			updateLabel()
			paint()
			if not silent then
				safe(cfg.Callback, obj.Value)
			end
		end
		function obj:Get()
			return obj.Value
		end

		local function pick(opt)
			if multi then
				local new = table.clone(obj.Value)
				local i = table.find(new, opt)
				if i then
					table.remove(new, i)
				else
					table.insert(new, opt)
				end
				obj:Set(new)
			else
				obj:Set(opt)
				setOpen(false)
			end
		end

		function obj:Refresh(newOptions)
			options = newOptions or {}
			obj.Options = options
			for _, b in pairs(buttons) do
				b:Destroy()
			end
			buttons = {}
			for i, raw in ipairs(options) do
				local opt = tostring(raw)
				local b = New("TextButton", {
					Size = UDim2.new(1, -4, 0, 28),
					BackgroundColor3 = Theme.AccentDeep,
					BackgroundTransparency = 0.85,
					Text = opt,
					Font = Enum.Font.GothamMedium,
					TextSize = 12,
					TextColor3 = Theme.SubText,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					LayoutOrder = i,
					Parent = list,
				})
				Corner(b, 7)
				b.MouseEnter:Connect(function()
					if not isSelected(opt) then
						Tween(b, 0.2, { BackgroundTransparency = 0.6 })
					end
				end)
				b.MouseLeave:Connect(function()
					if not isSelected(opt) then
						Tween(b, 0.2, { BackgroundTransparency = 0.85 })
					end
				end)
				b.MouseButton1Click:Connect(function()
					pick(opt)
				end)
				buttons[opt] = b
			end
			if open then
				setOpen(true)
			end
			paint()
		end

		header.MouseButton1Click:Connect(function()
			setOpen(not open)
		end)

		obj:Refresh(options)
		obj:Set(cfg.Default or (multi and {} or nil), true)
		return Finish(cfg, obj)
	end

	-- KEYBIND --------------------------------------------------------
	function Target:MakeKeybind(cfg)
		local name = cfg.Name or "Keybind"
		local mode = cfg.Mode or "Press" -- "Press" | "Hold"
		local row = Row(38, name)
		TextLabel({ Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local bind = New("TextButton", {
			Size = UDim2.new(0, 90, 0, 26),
			Position = UDim2.new(1, -100, 0.5, -13),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = Theme.AccentGlow,
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(bind, 7)
		local bs = Stroke(bind, Theme.Border, 1, 0.4)

		local unknown = Enum.KeyCode.Unknown
		local obj = { Value = cfg.Default or unknown, Instance = row, Kind = "Keybind" }
		local binding = false

		function obj:Set(key, silent)
			obj.Value = key or unknown
			bind.Text = obj.Value == unknown and "None" or obj.Value.Name
			if not silent then
				safe(cfg.Changed, obj.Value)
			end
		end
		function obj:Get()
			return obj.Value
		end

		bind.MouseButton1Click:Connect(function()
			binding = true
			Window.Binding = true
			bind.Text = "..."
			Tween(bs, 0.2, { Color = Theme.AccentGlow, Transparency = 0 })
		end)

		Window._track(UserInputService.InputBegan, function(input, gpe)
			if binding then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					binding = false
					task.defer(function()
						Window.Binding = false
					end)
					if input.KeyCode == Enum.KeyCode.Escape then
						obj:Set(obj.Value, true)
					elseif input.KeyCode == Enum.KeyCode.Backspace then
						obj:Set(unknown)
					else
						obj:Set(input.KeyCode)
					end
					Tween(bs, 0.25, { Color = Theme.Border, Transparency = 0.4 })
				end
				return
			end
			if gpe or obj.Value == unknown then
				return
			end
			if input.KeyCode == obj.Value then
				if mode == "Hold" then
					safe(cfg.Callback, true)
				else
					safe(cfg.Callback)
				end
			end
		end)
		Window._track(UserInputService.InputEnded, function(input)
			if mode == "Hold" and obj.Value ~= unknown and input.KeyCode == obj.Value then
				safe(cfg.Callback, false)
			end
		end)

		obj:Set(obj.Value, true)
		return Finish(cfg, obj)
	end

	-- COLOR PICKER ---------------------------------------------------
	function Target:MakeColorPicker(cfg)
		local name = cfg.Name or "Color"
		local row = Row(38, name)
		local header = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundTransparency = 1,
			Text = "",
			Parent = row,
		})
		TextLabel({ Size = UDim2.new(0.6, 0, 0, 38), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = header })
		local preview = New("Frame", {
			Size = UDim2.new(0, 44, 0, 22),
			Position = UDim2.new(1, -56, 0, 8),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = header,
		})
		Corner(preview, 7)
		Stroke(preview, Theme.Text, 1, 0.7)

		local h, s, v = (cfg.Default or Theme.AccentGlow):ToHSV()

		-- carré Saturation / Valeur
		local sv = New("Frame", {
			Position = UDim2.new(0, 12, 0, 46),
			Size = UDim2.new(1, -48, 0, 110),
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(sv, 6)
		local whiteOv = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = sv,
		})
		Corner(whiteOv, 6)
		Gradient(whiteOv, { { 0, WHITE }, { 1, WHITE } }, 0, { { 0, 0 }, { 1, 1 } })
		local blackOv = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = BLACK,
			BorderSizePixel = 0,
			Parent = sv,
		})
		Corner(blackOv, 6)
		Gradient(blackOv, { { 0, BLACK }, { 1, BLACK } }, 90, { { 0, 1 }, { 1, 0 } })
		local svCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = sv,
		})
		Corner(svCursor, 6)
		Stroke(svCursor, WHITE, 2, 0)

		-- barre de teinte
		local hue = New("Frame", {
			Position = UDim2.new(1, -28, 0, 46),
			Size = UDim2.new(0, 16, 0, 110),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(hue, 6)
		Gradient(hue, {
			{ 0, Color3.fromRGB(255, 0, 0) },
			{ 1 / 6, Color3.fromRGB(255, 255, 0) },
			{ 2 / 6, Color3.fromRGB(0, 255, 0) },
			{ 3 / 6, Color3.fromRGB(0, 255, 255) },
			{ 4 / 6, Color3.fromRGB(0, 0, 255) },
			{ 5 / 6, Color3.fromRGB(255, 0, 255) },
			{ 1, Color3.fromRGB(255, 0, 0) },
		}, 90)
		local hueCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 6, 0, 5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = hue,
		})
		Corner(hueCursor, 3)
		Stroke(hueCursor, WHITE, 2, 0)

		-- champ hex
		local hex = New("TextBox", {
			Position = UDim2.new(0, 12, 0, 164),
			Size = UDim2.new(1, -24, 0, 24),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			ClearTextOnFocus = false,
			BorderSizePixel = 0,
			Text = "",
			Parent = row,
		})
		Corner(hex, 7)
		Stroke(hex, Theme.Border, 1, 0.4)

		local obj = { Value = Color3.fromHSV(h, s, v), Instance = row, Kind = "Color" }
		local open = false

		local function apply(silent)
			local color = Color3.fromHSV(h, s, v)
			obj.Value = color
			sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			preview.BackgroundColor3 = color
			svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
			hueCursor.Position = UDim2.new(0.5, 0, h, 0)
			hex.Text = toHex(color)
			if not silent then
				safe(cfg.Callback, color)
			end
		end
		function obj:Set(color, silent)
			h, s, v = color:ToHSV()
			apply(silent)
		end
		function obj:Get()
			return obj.Value
		end

		MakeDrag(Window, sv, function(pos)
			s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
			apply()
		end)
		MakeDrag(Window, hue, function(pos)
			h = math.clamp((pos.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
			apply()
		end)
		hex.FocusLost:Connect(function()
			local r, g, b = hex.Text:match("^#?(%x%x)(%x%x)(%x%x)$")
			if r then
				obj:Set(Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)))
			else
				hex.Text = toHex(obj.Value)
			end
		end)
		header.MouseButton1Click:Connect(function()
			open = not open
			Tween(row, 0.45, { Size = UDim2.new(1, 0, 0, open and 198 or 38) }, EASE.Quart)
		end)

		apply(true)
		return Finish(cfg, obj)
	end

	-- SECTION (repliable) -------------------------------------------
	function Target:MakeSection(cfg)
		cfg = type(cfg) == "string" and { Name = cfg } or (cfg or {})
		local open = cfg.Open ~= false
		local sec = New("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		Corner(sec, 12)
		Stroke(sec, Theme.AccentDeep, 1, 0.4)
		local head = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			Text = "",
			Parent = sec,
		})
		local title = TextLabel({
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.new(0, 14, 0, 0),
			Text = string.upper(cfg.Name or "Section"),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextColor3 = Theme.AccentSoft,
			Parent = head,
		})
		Gradient(title, { { 0, Theme.AccentSoft }, { 1, Theme.AccentGlow } }, 0)
		local arrow = TextLabel({
			Size = UDim2.new(0, 20, 1, 0),
			Position = UDim2.new(1, -28, 0, 0),
			Text = ">",
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold,
			TextColor3 = Theme.AccentGlow,
			Rotation = open and 90 or 0,
			Parent = head,
		})
		local inner = New("Frame", {
			Position = UDim2.new(0, 8, 0, 38),
			Size = UDim2.new(1, -16, 0, 0),
			BackgroundTransparency = 1,
			Parent = sec,
		})
		local layout = New("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = inner,
		})
		local function height()
			return open and (34 + 4 + layout.AbsoluteContentSize.Y + 8) or 34
		end
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			inner.Size = UDim2.new(1, -16, 0, layout.AbsoluteContentSize.Y)
			sec.Size = UDim2.new(1, 0, 0, height())
		end)
		head.MouseButton1Click:Connect(function()
			open = not open
			Tween(sec, 0.4, { Size = UDim2.new(1, 0, 0, height()) }, EASE.Quart)
			Tween(arrow, 0.3, { Rotation = open and 90 or 0 })
		end)

		local Section = { Instance = sec }
		BuildElements(Section, inner, Tab, Window)
		return Section
	end
end

----------------------------------------------------------------------
-- FENÊTRE
----------------------------------------------------------------------

function Ghostline.new(cfg)
	cfg = cfg or {}
	local Window = { Tabs = {}, CurrentTab = nil, Visible = true, Minimized = false, Binding = false, _conns = {} }
	local title = cfg.Name or "Ghostline OS"
	local subtitle = cfg.Subtitle
	local size = cfg.Size or Vector2.new(640, 430)
	local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
	local HEADER = 48

	function Window._track(signal, fn)
		local c = signal:Connect(fn)
		table.insert(Window._conns, c)
		return c
	end
	local track = Window._track

	-- Racine (déplaçable / redimensionnable) -------------------------
	local Root = New("Frame", {
		Name = "Window",
		Size = UDim2.fromOffset(size.X, size.Y),
		Position = UDim2.new(0.5, -size.X / 2, 0.5, -size.Y / 2),
		BackgroundTransparency = 1,
		Parent = ScreenGui,
	})
	local Holder = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = Root,
	})
	local Scale = New("UIScale", { Scale = 0.05, Parent = Holder })

	local Shadow = New("ImageLabel", {
		Position = UDim2.new(0, -30, 0, -30),
		Size = UDim2.new(1, 60, 1, 60),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5028857084",
		ImageColor3 = Theme.AccentDeep,
		ImageTransparency = 0.55,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(24, 24, 276, 276),
		Parent = Holder,
	})

	local Main = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		Parent = Holder,
	})
	Corner(Main, 20)
	Gradient(Main, {
		{ 0, Theme.BackgroundSecondary },
		{ 0.5, Theme.BackgroundPrimary },
		{ 1, Theme.GlassTint },
	}, 135)

	-- bordure rouge animée (dégradé qui tourne)
	local MainStroke = Stroke(Main, WHITE, 1.6, 0.05)
	local strokeGrad = Gradient(MainStroke, {
		{ 0, Theme.AccentDeep },
		{ 0.25, Theme.AccentGlow },
		{ 0.5, Theme.AccentDeep },
		{ 0.75, Theme.AccentGlow },
		{ 1, Theme.AccentDeep },
	}, 0)
	TweenService:Create(strokeGrad, TweenInfo.new(6, EASE.Linear, DIR.Out, -1), { Rotation = 360 }):Play()

	-- orbes "liquides" flottants derrière le verre
	local orbs = {
		{ size = 240, color = Theme.AccentGlow, from = UDim2.new(0, -60, 0, -40), to = UDim2.new(0, 60, 0, 70), t = 7, tr = 0.86 },
		{ size = 200, color = Theme.AccentDeep, from = UDim2.new(1, -170, 1, -150), to = UDim2.new(1, -280, 1, -220), t = 9, tr = 0.78 },
		{ size = 150, color = Theme.AccentSoft, from = UDim2.new(0.5, 0, 0, 60), to = UDim2.new(0.62, 50, 0, 150), t = 11, tr = 0.9 },
	}
	for _, o in ipairs(orbs) do
		local orb = New("Frame", {
			Size = UDim2.fromOffset(o.size, o.size),
			Position = o.from,
			BackgroundColor3 = o.color,
			BackgroundTransparency = o.tr,
			BorderSizePixel = 0,
			Parent = Main,
		})
		Corner(orb, 999)
		TweenService:Create(orb, TweenInfo.new(o.t, EASE.Sine, DIR.InOut, -1, true), { Position = o.to }):Play()
	end

	-- reflets de verre
	local sheen = New("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Corner(sheen, 20)
	Gradient(sheen, { { 0, WHITE }, { 1, WHITE } }, 90, { { 0, 0.9 }, { 1, 1 } })
	New("Frame", {
		Position = UDim2.new(0, 14, 0, 0),
		Size = UDim2.new(1, -28, 0, 1),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,
		Parent = Main,
	})

	-- En-tête ---------------------------------------------------------
	local Header = New("Frame", {
		Size = UDim2.new(1, 0, 0, HEADER),
		BackgroundTransparency = 1,
		Parent = Main,
	})
	local titleLbl = TextLabel({
		Size = UDim2.new(0, 300, 0, subtitle and 22 or HEADER),
		Position = UDim2.new(0, 18, 0, subtitle and 6 or 0),
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		Parent = Header,
	})
	Gradient(titleLbl, { { 0, Theme.Text }, { 1, Theme.AccentSoft } }, 0)
	if subtitle then
		TextLabel({
			Size = UDim2.new(0, 300, 0, 14),
			Position = UDim2.new(0, 18, 0, 26),
			Text = subtitle,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = Theme.SubText,
			Parent = Header,
		})
	end

	local function HeaderButton(text, offsetX, hoverColor)
		local b = New("TextButton", {
			Size = UDim2.new(0, 28, 0, 28),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, offsetX, 0.5, 0),
			BackgroundColor3 = hoverColor,
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = Header,
		})
		Corner(b, 8)
		b.MouseEnter:Connect(function()
			Tween(b, 0.2, { BackgroundTransparency = 0.5, TextColor3 = Theme.Text })
		end)
		b.MouseLeave:Connect(function()
			Tween(b, 0.2, { BackgroundTransparency = 1, TextColor3 = Theme.SubText })
		end)
		return b
	end
	local CloseBtn = HeaderButton("×", -10, Theme.Error)
	local MinBtn = HeaderButton("—", -44, Theme.AccentDeep)

	local Search = New("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -82, 0.5, 0),
		Size = UDim2.new(0, 150, 0, 26),
		BackgroundColor3 = Theme.BackgroundPrimary,
		BackgroundTransparency = 0.3,
		PlaceholderText = "Rechercher...",
		PlaceholderColor3 = Theme.SubText,
		Text = "",
		TextColor3 = Theme.Text,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		ClearTextOnFocus = false,
		BorderSizePixel = 0,
		Parent = Header,
	})
	Corner(Search, 8)
	local searchStroke = Stroke(Search, Theme.Border, 1, 0.4)
	Search.Focused:Connect(function()
		Tween(searchStroke, 0.25, { Color = Theme.AccentGlow, Transparency = 0 })
		Tween(Search, 0.35, { Size = UDim2.new(0, 190, 0, 26) }, EASE.Quart)
	end)
	Search.FocusLost:Connect(function()
		Tween(searchStroke, 0.25, { Color = Theme.Border, Transparency = 0.4 })
		Tween(Search, 0.35, { Size = UDim2.new(0, 150, 0, 26) }, EASE.Quart)
	end)

	-- barre d'accent animée
	local AccentBar = New("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 0, HEADER),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Parent = Main,
	})
	local barGrad = Gradient(AccentBar, {
		{ 0, Theme.BackgroundPrimary },
		{ 0.35, Theme.AccentDeep },
		{ 0.5, Theme.AccentGlow },
		{ 0.65, Theme.AccentDeep },
		{ 1, Theme.BackgroundPrimary },
	}, 0)
	barGrad.Offset = Vector2.new(-0.5, 0)
	TweenService:Create(barGrad, TweenInfo.new(2.5, EASE.Sine, DIR.InOut, -1, true), { Offset = Vector2.new(0.5, 0) }):Play()

	-- Corps ------------------------------------------------------------
	local Body = New("Frame", {
		Position = UDim2.new(0, 0, 0, HEADER + 2),
		Size = UDim2.new(1, 0, 1, -(HEADER + 2)),
		BackgroundTransparency = 1,
		Parent = Main,
	})
	local Sidebar = New("Frame", {
		Position = UDim2.new(0, 8, 0, 6),
		Size = UDim2.new(0, 146, 1, -14),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = Body,
	})
	Corner(Sidebar, 14)
	Stroke(Sidebar, Theme.Border, 1, 0.6)

	local TabList = New("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, 8),
		Size = UDim2.new(1, 0, 1, -40),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Sidebar,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Parent = TabList,
	})
	New("UIPadding", { PaddingTop = UDim.new(0, 4), Parent = TabList })

	local Indicator = New("Frame", {
		Size = UDim2.new(0, 3, 0, 20),
		Position = UDim2.new(0, 3, 0, 20),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Visible = false,
		Parent = Sidebar,
	})
	Corner(Indicator, 2)
	Gradient(Indicator, { { 0, Theme.AccentSoft }, { 1, Theme.AccentGlow } }, 90)

	TextLabel({
		Position = UDim2.new(0, 0, 1, -28),
		Size = UDim2.new(1, 0, 0, 20),
		Text = "Ghostline v" .. Ghostline.Version,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = Sidebar,
	})

	local ContentArea = New("Frame", {
		Position = UDim2.new(0, 160, 0, 0),
		Size = UDim2.new(1, -160, 1, 0),
		BackgroundTransparency = 1,
		Parent = Body,
	})

	-- poignée de redimensionnement
	local Resize = New("TextButton", {
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -22, 1, -22),
		BackgroundTransparency = 1,
		Text = "",
		Parent = Main,
	})
	local resizeDot = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 2, 0.5, 2),
		Size = UDim2.new(0, 7, 0, 7),
		BackgroundColor3 = Theme.AccentGlow,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = Resize,
	})
	Corner(resizeDot, 4)
	Resize.MouseEnter:Connect(function()
		Tween(resizeDot, 0.2, { BackgroundTransparency = 0, Size = UDim2.new(0, 10, 0, 10) })
	end)
	Resize.MouseLeave:Connect(function()
		Tween(resizeDot, 0.2, { BackgroundTransparency = 0.5, Size = UDim2.new(0, 7, 0, 7) })
	end)
	MakeDrag(Window, Resize, function(pos)
		if Window.Minimized then
			return
		end
		local nx = math.clamp(pos.X - Root.AbsolutePosition.X + 8, 480, 900)
		local ny = math.clamp(pos.Y - Root.AbsolutePosition.Y + 8, 320, 700)
		Root.Size = UDim2.fromOffset(nx, ny)
	end)

	-- déplacement fluide
	local dragStart, startPos
	MakeDrag(Window, Header, function(pos)
		if not dragStart then
			return
		end
		local d = pos - dragStart
		Tween(Root, 0.1, {
			Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y),
		})
	end, function()
		dragStart = nil
	end, function(pos)
		dragStart = pos
		startPos = Root.Position
	end)

	-- Onglets ------------------------------------------------------------
	local function moveIndicator(tab, instant)
		local y = 8 + 4 + (tab._index - 1) * 44 - TabList.CanvasPosition.Y + 8
		if not Indicator.Visible then
			Indicator.Position = UDim2.new(0, 3, 0, y)
			Indicator.Visible = true
		elseif instant then
			Indicator.Position = UDim2.new(0, 3, 0, y)
		else
			Tween(Indicator, 0.45, { Position = UDim2.new(0, 3, 0, y) }, EASE.Back)
		end
	end
	track(TabList:GetPropertyChangedSignal("CanvasPosition"), function()
		if Window.CurrentTab then
			moveIndicator(Window.CurrentTab, true)
		end
	end)

	function Window:SelectTab(tab)
		if type(tab) == "string" then
			for _, t in ipairs(Window.Tabs) do
				if t.Name == tab then
					tab = t
					break
				end
			end
		end
		if type(tab) ~= "table" or Window.CurrentTab == tab then
			return
		end
		Window.CurrentTab = tab
		-- réinitialise la recherche
		for _, t in ipairs(Window.Tabs) do
			for _, e in ipairs(t._elements) do
				e.Frame.Visible = true
			end
		end
		Search.Text = ""
		for _, t in ipairs(Window.Tabs) do
			local active = t == tab
			Tween(t._btn, 0.3, { BackgroundTransparency = active and 0.5 or 1 })
			Tween(t._lbl, 0.3, { TextColor3 = active and Theme.Text or Theme.SubText })
			if t._icon then
				Tween(t._icon, 0.3, { ImageColor3 = active and Theme.AccentGlow or Theme.SubText })
			end
			if not active then
				t._container.Visible = false
			end
		end
		tab._container.Position = UDim2.new(0, 10, 0, 26)
		tab._container.Visible = true
		Tween(tab._container, 0.45, { Position = UDim2.new(0, 10, 0, 8) }, EASE.Quart)
		moveIndicator(tab)
	end

	function Window:MakeTab(tcfg)
		tcfg = type(tcfg) == "string" and { Name = tcfg } or (tcfg or {})
		local tabName = tcfg.Name or "Tab"
		local Tab = { Name = tabName, _elements = {} }
		table.insert(Window.Tabs, Tab)
		Tab._index = #Window.Tabs

		local btn = New("TextButton", {
			Size = UDim2.new(1, -16, 0, 36),
			BackgroundColor3 = Theme.AccentDeep,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = Tab._index,
			ClipsDescendants = true,
			Parent = TabList,
		})
		Corner(btn, 10)
		Gradient(btn, { { 0, Theme.AccentGlow }, { 1, Theme.AccentDeep } }, 0)
		local hasIcon = tcfg.Icon ~= nil
		if hasIcon then
			Tab._icon = New("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 12, 0.5, -9),
				BackgroundTransparency = 1,
				Image = tcfg.Icon,
				ImageColor3 = Theme.SubText,
				Parent = btn,
			})
		end
		local lbl = TextLabel({
			Size = UDim2.new(1, hasIcon and -40 or -16, 1, 0),
			Position = UDim2.new(0, hasIcon and 36 or 14, 0, 0),
			Text = tabName,
			TextColor3 = Theme.SubText,
			Parent = btn,
		})
		Tab._btn, Tab._lbl = btn, lbl

		local Container = New("ScrollingFrame", {
			Size = UDim2.new(1, -20, 1, -16),
			Position = UDim2.new(0, 10, 0, 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.AccentGlow,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			ClipsDescendants = true,
			Parent = ContentArea,
		})
		New("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Container })
		New("UIPadding", {
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 6),
			Parent = Container,
		})
		Tab._container = Container

		btn.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(btn, 0.25, { BackgroundTransparency = 0.8 })
			end
		end)
		btn.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(btn, 0.25, { BackgroundTransparency = 1 })
			end
		end)
		btn.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Ripple(btn, input.Position.X, input.Position.Y)
			end
		end)
		btn.MouseButton1Click:Connect(function()
			Window:SelectTab(Tab)
		end)

		BuildElements(Tab, Container, Tab, Window)

		if #Window.Tabs == 1 then
			Window:SelectTab(Tab)
		end
		return Tab
	end
	Window.CreateTab = Window.MakeTab

	-- recherche ---------------------------------------------------------
	track(Search:GetPropertyChangedSignal("Text"), function()
		local q = string.lower(Search.Text)
		local tab = Window.CurrentTab
		if not tab then
			return
		end
		for _, e in ipairs(tab._elements) do
			e.Frame.Visible = q == "" or string.find(e.Name, q, 1, true) ~= nil
		end
	end)

	-- afficher / masquer / réduire / détruire ---------------------------
	function Window:Toggle(state)
		if state == nil then
			state = not Window.Visible
		end
		Window.Visible = state
		if state then
			Root.Visible = true
			Tween(Scale, 0.55, { Scale = 1 }, EASE.Back)
		else
			Tween(Scale, 0.3, { Scale = 0.05 }, EASE.Quart, DIR.In)
			task.delay(0.3, function()
				if not Window.Visible then
					Root.Visible = false
				end
			end)
		end
	end

	function Window:Minimize(state)
		if state == nil then
			state = not Window.Minimized
		end
		Window.Minimized = state
		if state then
			Tween(Main, 0.45, { Size = UDim2.new(1, 0, 0, HEADER + 2) }, EASE.Exponential)
			Tween(Shadow, 0.45, { Size = UDim2.new(1, 60, 0, HEADER + 62) }, EASE.Exponential)
			Resize.Visible = false
			task.delay(0.3, function()
				if Window.Minimized then
					Body.Visible = false
				end
			end)
		else
			Body.Visible = true
			Resize.Visible = true
			Tween(Main, 0.5, { Size = UDim2.new(1, 0, 1, 0) }, EASE.Exponential)
			Tween(Shadow, 0.5, { Size = UDim2.new(1, 60, 1, 60) }, EASE.Exponential)
		end
	end

	function Window:Destroy()
		for _, c in ipairs(Window._conns) do
			c:Disconnect()
		end
		Window._conns = {}
		Tween(Scale, 0.35, { Scale = 0.05 }, EASE.Quart, DIR.In)
		task.delay(0.4, function()
			Root:Destroy()
		end)
		local i = table.find(Ghostline.Windows, Window)
		if i then
			table.remove(Ghostline.Windows, i)
		end
	end

	function Window:Notify(ncfg)
		Ghostline:Notify(ncfg)
	end

	CloseBtn.MouseButton1Click:Connect(function()
		Window:Destroy()
	end)
	MinBtn.MouseButton1Click:Connect(function()
		Window:Minimize()
	end)
	track(UserInputService.InputBegan, function(input, gpe)
		if gpe or Window.Binding then
			return
		end
		if input.KeyCode == toggleKey then
			Window:Toggle()
		end
	end)

	table.insert(Ghostline.Windows, Window)

	-- animation d'ouverture
	Tween(Scale, 0.8, { Scale = 1 }, EASE.Back)

	return Window
end

Ghostline.CreateWindow = Ghostline.new

function Ghostline:Destroy()
	for _, w in ipairs(table.clone(Ghostline.Windows)) do
		w:Destroy()
	end
	task.delay(0.5, function()
		ScreenGui:Destroy()
	end)
end

return Ghostline
