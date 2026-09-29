local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Ghostline = {}
Ghostline.__index = Ghostline

Ghostline.Theme = {
    Background = Color3.fromRGB(12, 12, 12),
    Glass = Color3.fromRGB(20, 15, 18),
    Sidebar = Color3.fromRGB(16, 16, 16),
    ElementBackground = Color3.fromRGB(22, 18, 20),
    ElementHover = Color3.fromRGB(35, 22, 26),
    Accent = Color3.fromRGB(220, 20, 60),
    AccentGlow = Color3.fromRGB(255, 50, 90),
    Text = Color3.fromRGB(245, 245, 245),
    SubText = Color3.fromRGB(140, 140, 140),
    Border = Color3.fromRGB(45, 25, 30)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostlineUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParent = pcall(function() return gethui() end) and gethui() or CoreGui
pcall(function() ScreenGui.Parent = guiParent end)
if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 300, 1, -20)
NotifContainer.Position = UDim2.new(1, -320, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

function Ghostline:MakeNotification(config)
    local title = config.Title or "Notification"
    local content = config.Content or "Texte"
    local time = config.Time or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 65)
    NotifFrame.BackgroundColor3 = Ghostline.Theme.Glass
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.Parent = NotifContainer

    local UICorner = Instance.new("UICorner", NotifFrame)
    UICorner.CornerRadius = UDim.new(0, 10)
    
    local UIStroke = Instance.new("UIStroke", NotifFrame)
    UIStroke.Color = Ghostline.Theme.Accent
    UIStroke.Thickness = 1.2
    UIStroke.Transparency = 1

    local TitleLabel = Instance.new("TextLabel", NotifFrame)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Ghostline.Theme.AccentGlow
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1

    local ContentLabel = Instance.new("TextLabel", NotifFrame)
    ContentLabel.Size = UDim2.new(1, -20, 0, 30)
    ContentLabel.Position = UDim2.new(0, 12, 0, 28)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = content
    ContentLabel.TextColor3 = Ghostline.Theme.Text
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 12
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.TextTransparency = 1

    TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.25}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.2}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(ContentLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

    task.delay(time, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        local fadeOut = TweenService:Create(ContentLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

function Ghostline.new(config)
    local Window = { Tabs = {}, CurrentTab = nil }
    local titleText = config.Name or "Ghostline"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 560, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
    MainFrame.BackgroundColor3 = Ghostline.Theme.Glass
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Ghostline.Theme.Border
    Stroke.Thickness = 1.5

    -- Animation d'ouverture fluide de la fenêtre
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 560, 0, 360),
        Position = UDim2.new(0.5, -280, 0.5, -180)
    }):Play()

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Ghostline.Theme.AccentGlow
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Line = Instance.new("Frame", MainFrame)
    Line.Size = UDim2.new(1, 0, 0, 1.5)
    Line.Position = UDim2.new(0, 0, 0, 40)
    Line.BackgroundColor3 = Ghostline.Theme.Accent
    Line.BorderSizePixel = 0

    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Size = UDim2.new(0, 140, 1, -41)
    Sidebar.Position = UDim2.new(0, 0, 0, 41)
    Sidebar.BackgroundColor3 = Ghostline.Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.4
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local SidebarPadding = Instance.new("UIPadding", Sidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -140, 1, -41)
    ContentArea.Position = UDim2.new(0, 140, 0, 41)
    ContentArea.BackgroundTransparency = 1

    function Window:MakeTab(config)
        local tabName = config.Name or "Tab"
        local Tab = {}

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 34)
        TabBtn.BackgroundColor3 = Ghostline.Theme.ElementBackground
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Ghostline.Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local Container = Instance.new("ScrollingFrame", ContentArea)
        Container.Size = UDim2.new(1, -20, 1, -20)
        Container.Position = UDim2.new(0, 10, 0, 10)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 3
        Container.Visible = false

        local ContainerLayout = Instance.new("UIListLayout", Container)
        ContainerLayout.Padding = UDim.new(0, 8)
        ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseEnter:Connect(function()
            if TabBtn.TextColor3 ~= Ghostline.Theme.AccentGlow then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Ghostline.Theme.ElementHover, BackgroundTransparency = 0.5}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.TextColor3 ~= Ghostline.Theme.AccentGlow then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Ghostline.Theme.SubText, BackgroundTransparency = 1}):Play()
                end
            end
            for _, frame in pairs(ContentArea:GetChildren()) do
                if frame:IsA("ScrollingFrame") then frame.Visible = false end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Ghostline.Theme.AccentGlow, BackgroundTransparency = 0.3, BackgroundColor3 = Ghostline.Theme.ElementHover}):Play()
            Container.Visible = true
        end)

        if #Sidebar:GetChildren() == 3 then 
            TabBtn.TextColor3 = Ghostline.Theme.AccentGlow
            TabBtn.BackgroundTransparency = 0.3
            TabBtn.BackgroundColor3 = Ghostline.Theme.ElementHover
            Container.Visible = true 
        end

        function Tab:MakeLabel(text)
            local lbl = Instance.new("TextLabel", Container)
            lbl.Size = UDim2.new(1, 0, 0, 25)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Ghostline.Theme.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:MakeButton(cfg)
            local BtnFrame = Instance.new("TextButton", Container)
            BtnFrame.Size = UDim2.new(1, 0, 0, 36)
            BtnFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            BtnFrame.BackgroundTransparency = 0.3
            BtnFrame.Text = cfg.Name
            BtnFrame.TextColor3 = Ghostline.Theme.Text
            BtnFrame.Font = Enum.Font.GothamBold
            BtnFrame.TextSize = 13
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 8)

            BtnFrame.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Ghostline.Theme.ElementHover}):Play()
            end)
            BtnFrame.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Ghostline.Theme.ElementBackground}):Play()
            end)
            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 34)}):Play()
                task.delay(0.1, function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                end)
                cfg.Callback()
            end)
        end

        function Tab:MakeToggle(cfg)
            local state = cfg.Default or false
            local TglFrame = Instance.new("TextButton", Container)
            TglFrame.Size = UDim2.new(1, 0, 0, 36)
            TglFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            TglFrame.BackgroundTransparency = 0.3
            TglFrame.Text = "  " .. cfg.Name
            TglFrame.TextColor3 = Ghostline.Theme.Text
            TglFrame.Font = Enum.Font.Gotham
            TglFrame.TextSize = 13
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 8)

            local Indicator = Instance.new("Frame", TglFrame)
            Indicator.Size = UDim2.new(0, 22, 0, 22)
            Indicator.Position = UDim2.new(1, -32, 0.5, -11)
            Indicator.BackgroundColor3 = state and Ghostline.Theme.Accent or Ghostline.Theme.Border
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 6)

            TglFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundColor3 = state and Ghostline.Theme.AccentGlow or Ghostline.Theme.Border
                }):Play()
                cfg.Callback(state)
            end)
        end

        function Tab:MakeSlider(cfg)
            local val = cfg.Default or cfg.Min
            local SldFrame = Instance.new("Frame", Container)
            SldFrame.Size = UDim2.new(1, 0, 0, 48)
            SldFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            SldFrame.BackgroundTransparency = 0.3
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", SldFrame)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name .. " : " .. tostring(val)
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame", SldFrame)
            Track.Size = UDim2.new(1, -20, 0, 6)
            Track.Position = UDim2.new(0, 10, 0, 32)
            Track.BackgroundColor3 = Ghostline.Theme.Background
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((val - cfg.Min) / (cfg.Max - cfg.Min), 0, 1, 0)
            Fill.BackgroundColor3 = Ghostline.Theme.AccentGlow
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local isDragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                val = math.floor(cfg.Min + pos * (cfg.Max - cfg.Min))
                Label.Text = cfg.Name .. " : " .. tostring(val)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                cfg.Callback(val)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
            end)
        end

        function Tab:MakeTextbox(cfg)
            local BoxFrame = Instance.new("Frame", Container)
            BoxFrame.Size = UDim2.new(1, 0, 0, 36)
            BoxFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            BoxFrame.BackgroundTransparency = 0.3
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", BoxFrame)
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Input = Instance.new("TextBox", BoxFrame)
            Input.Size = UDim2.new(0.4, 0, 0, 24)
            Input.Position = UDim2.new(0.6, -10, 0.5, -12)
            Input.BackgroundColor3 = Ghostline.Theme.Background
            Input.Text = ""
            Input.PlaceholderText = "..."
            Input.TextColor3 = Ghostline.Theme.Text
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 12
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

            Input.FocusLost:Connect(function() cfg.Callback(Input.Text) end)
        end

        function Tab:MakeKeybind(cfg)
            local currentKey = cfg.Default or Enum.KeyCode.E
            local KeyFrame = Instance.new("Frame", Container)
            KeyFrame.Size = UDim2.new(1, 0, 0, 36)
            KeyFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            KeyFrame.BackgroundTransparency = 0.3
            Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", KeyFrame)
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local BindBtn = Instance.new("TextButton", KeyFrame)
            BindBtn.Size = UDim2.new(0, 85, 0, 24)
            BindBtn.Position = UDim2.new(1, -95, 0.5, -12)
            BindBtn.BackgroundColor3 = Ghostline.Theme.Background
            BindBtn.Text = currentKey.Name
            BindBtn.TextColor3 = Ghostline.Theme.AccentGlow
            BindBtn.Font = Enum.Font.GothamBold
            BindBtn.TextSize = 12
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 6)

            local isBinding = false
            BindBtn.MouseButton1Click:Connect(function()
                isBinding = true
                BindBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    BindBtn.Text = currentKey.Name
                    isBinding = false
                elseif not processed and input.KeyCode == currentKey and not isBinding then
                    cfg.Callback()
                end
            end)
        end

        function Tab:MakeColorPicker(cfg)
            local CPFrame = Instance.new("Frame", Container)
            CPFrame.Size = UDim2.new(1, 0, 0, 36)
            CPFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            CPFrame.BackgroundTransparency = 0.3
            Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel", CPFrame)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ColorView = Instance.new("Frame", CPFrame)
            ColorView.Size = UDim2.new(0, 45, 0, 22)
            ColorView.Position = UDim2.new(1, -55, 0.5, -11)
            ColorView.BackgroundColor3 = cfg.Default or Color3.new(1, 1, 1)
            Instance.new("UICorner", ColorView).CornerRadius = UDim.new(0, 6)

            local ColorBtn = Instance.new("TextButton", ColorView)
            ColorBtn.Size = UDim2.new(1, 0, 1, 0)
            ColorBtn.BackgroundTransparency = 1
            ColorBtn.Text = ""

            ColorBtn.MouseButton1Click:Connect(function()
                cfg.Callback(ColorView.BackgroundColor3)
            end)
        end

        return Tab
    end
    return Window
end

return Ghostline
