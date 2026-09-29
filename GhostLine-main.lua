local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Ghostline = {}
Ghostline.__index = Ghostline

Ghostline.Theme = {
    BackgroundPrimary = Color3.fromRGB(18, 8, 10),
    BackgroundSecondary = Color3.fromRGB(30, 10, 14),
    GlassTint = Color3.fromRGB(45, 12, 18),
    AccentGlow = Color3.fromRGB(240, 20, 70),
    AccentDeep = Color3.fromRGB(160, 10, 45),
    Text = Color3.fromRGB(250, 240, 242),
    SubText = Color3.fromRGB(170, 140, 145),
    Border = Color3.fromRGB(90, 25, 40)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostlineLiquidUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParent = pcall(function() return gethui() end) and gethui() or CoreGui
pcall(function() ScreenGui.Parent = guiParent end)
if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 320, 1, -20)
NotifContainer.Position = UDim2.new(1, -340, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 12)

function Ghostline:MakeNotification(config)
    local title = config.Title or "System"
    local content = config.Content or "Information"
    local time = config.Time or 3.5

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 70)
    NotifFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
    NotifFrame.BackgroundTransparency = 0.35
    NotifFrame.Position = UDim2.new(1, 40, 0, 0)
    NotifFrame.Parent = NotifContainer

    local UICorner = Instance.new("UICorner", NotifFrame)
    UICorner.CornerRadius = UDim.new(0, 16)
    
    local UIStroke = Instance.new("UIStroke", NotifFrame)
    UIStroke.Color = Ghostline.Theme.AccentGlow
    UIStroke.Thickness = 1.2
    UIStroke.Transparency = 0.4

    local UIGradient = Instance.new("UIGradient", NotifFrame)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Ghostline.Theme.GlassTint),
        ColorSequenceKeypoint.new(1, Ghostline.Theme.BackgroundPrimary)
    })
    UIGradient.Rotation = 45

    local TitleLabel = Instance.new("TextLabel", NotifFrame)
    TitleLabel.Size = UDim2.new(1, -24, 0, 22)
    TitleLabel.Position = UDim2.new(0, 14, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Ghostline.Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ContentLabel = Instance.new("TextLabel", NotifFrame)
    ContentLabel.Size = UDim2.new(1, -24, 0, 30)
    ContentLabel.Position = UDim2.new(0, 14, 0, 32)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = content
    ContentLabel.TextColor3 = Ghostline.Theme.SubText
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 12
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true

    TweenService:Create(NotifFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.2
    }):Play()

    task.delay(time, function()
        local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 40, 0, 0),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

function Ghostline.new(config)
    local Window = { Tabs = {}, CurrentTab = nil }
    local titleText = config.Name or "Ghostline OS"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Ghostline.Theme.BackgroundPrimary
    MainFrame.BackgroundTransparency = 0.25
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Ghostline.Theme.Border
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.3

    local MainGradient = Instance.new("UIGradient", MainFrame)
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Ghostline.Theme.BackgroundSecondary),
        ColorSequenceKeypoint.new(0.5, Ghostline.Theme.BackgroundPrimary),
        ColorSequenceKeypoint.new(1, Ghostline.Theme.GlassTint)
    })
    MainGradient.Rotation = 135

    local GlassHighlight = Instance.new("Frame", MainFrame)
    GlassHighlight.Size = UDim2.new(1, 0, 0, 1)
    GlassHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassHighlight.BackgroundTransparency = 0.7
    GlassHighlight.BorderSizePixel = 0

    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundTransparency = 1
    
    TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 580, 0, 380),
        Position = UDim2.new(0.5, -290, 0.5, -190),
        BackgroundTransparency = 0.25
    }):Play()

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Ghostline.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local AccentBar = Instance.new("Frame", MainFrame)
    AccentBar.Size = UDim2.new(1, 0, 0, 2)
    AccentBar.Position = UDim2.new(0, 0, 0, 45)
    AccentBar.BackgroundColor3 = Ghostline.Theme.AccentGlow
    AccentBar.BorderSizePixel = 0

    local BarGradient = Instance.new("UIGradient", AccentBar)
    BarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Ghostline.Theme.AccentDeep),
        ColorSequenceKeypoint.new(0.5, Ghostline.Theme.AccentGlow),
        ColorSequenceKeypoint.new(1, Ghostline.Theme.AccentDeep)
    })

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
    Sidebar.Size = UDim2.new(0, 150, 1, -47)
    Sidebar.Position = UDim2.new(0, 0, 0, 47)
    Sidebar.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 8)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local SidebarPadding = Instance.new("UIPadding", Sidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -150, 1, -47)
    ContentArea.Position = UDim2.new(0, 150, 0, 47)
    ContentArea.BackgroundTransparency = 1

    function Window:MakeTab(config)
        local tabName = config.Name or "Tab"
        local Tab = {}

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 36)
        TabBtn.BackgroundColor3 = Ghostline.Theme.GlassTint
        TabBtn.BackgroundTransparency = 0.8
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Ghostline.Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)

        local Container = Instance.new("ScrollingFrame", ContentArea)
        Container.Size = UDim2.new(1, -20, 1, -20)
        Container.Position = UDim2.new(0, 10, 0, 10)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 2
        Container.Visible = false

        local ContainerLayout = Instance.new("UIListLayout", Container)
        ContainerLayout.Padding = UDim.new(0, 10)
        ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseEnter:Connect(function()
            if TabBtn.TextColor3 ~= Ghostline.Theme.Text then
                TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.4, BackgroundColor3 = Ghostline.Theme.GlassTint}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.TextColor3 ~= Ghostline.Theme.Text then
                TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.8}):Play()
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {TextColor3 = Ghostline.Theme.SubText, BackgroundTransparency = 0.8}):Play()
                end
            end
            for _, frame in pairs(ContentArea:GetChildren()) do
                if frame:IsA("ScrollingFrame") then frame.Visible = false end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                TextColor3 = Ghostline.Theme.Text,
                BackgroundTransparency = 0.2,
                BackgroundColor3 = Ghostline.Theme.AccentDeep
            }):Play()
            Container.Visible = true
        end)

        if #Sidebar:GetChildren() == 3 then 
            TabBtn.TextColor3 = Ghostline.Theme.Text
            TabBtn.BackgroundTransparency = 0.2
            TabBtn.BackgroundColor3 = Ghostline.Theme.AccentDeep
            Container.Visible = true 
        end

        function Tab:MakeLabel(text)
            local lbl = Instance.new("TextLabel", Container)
            lbl.Size = UDim2.new(1, 0, 0, 25)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Ghostline.Theme.SubText
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:MakeButton(cfg)
            local BtnFrame = Instance.new("TextButton", Container)
            BtnFrame.Size = UDim2.new(1, 0, 0, 38)
            BtnFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
            BtnFrame.BackgroundTransparency = 0.4
            BtnFrame.Text = cfg.Name
            BtnFrame.TextColor3 = Ghostline.Theme.Text
            BtnFrame.Font = Enum.Font.GothamBold
            BtnFrame.TextSize = 13
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 10)

            local Stroke = Instance.new("UIStroke", BtnFrame)
            Stroke.Color = Ghostline.Theme.Border
            Stroke.Transparency = 0.5

            BtnFrame.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.15, BackgroundColor3 = Ghostline.Theme.GlassTint}):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.1, Color = Ghostline.Theme.AccentGlow}):Play()
            end)
            BtnFrame.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.4, BackgroundColor3 = Ghostline.Theme.BackgroundSecondary}):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.5, Color = Ghostline.Theme.Border}):Play()
            end)
            BtnFrame.MouseButton1Click:Connect(function()
                local tweenBounceIn = TweenService:Create(BtnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(1, -6, 0, 35)})
                tweenBounceIn:Play()
                tweenBounceIn.Completed:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                end)
                cfg.Callback()
            end)
        end

        function Tab:MakeToggle(cfg)
            local state = cfg.Default or false
            local TglFrame = Instance.new("TextButton", Container)
            TglFrame.Size = UDim2.new(1, 0, 0, 38)
            TglFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
            TglFrame.BackgroundTransparency = 0.4
            TglFrame.Text = "  " .. cfg.Name
            TglFrame.TextColor3 = Ghostline.Theme.Text
            TglFrame.Font = Enum.Font.GothamMedium
            TglFrame.TextSize = 13
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 10)

            local Indicator = Instance.new("Frame", TglFrame)
            Indicator.Size = UDim2.new(0, 24, 0, 24)
            Indicator.Position = UDim2.new(1, -34, 0.5, -12)
            Indicator.BackgroundColor3 = state and Ghostline.Theme.AccentGlow or Ghostline.Theme.Border
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 7)

            TglFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    BackgroundColor3 = state and Ghostline.Theme.AccentGlow or Ghostline.Theme.Border
                }):Play()
                cfg.Callback(state)
            end)
        end

        function Tab:MakeSlider(cfg)
            local val = cfg.Default or cfg.Min
            local SldFrame = Instance.new("Frame", Container)
            SldFrame.Size = UDim2.new(1, 0, 0, 50)
            SldFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
            SldFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 10)

            local Label = Instance.new("TextLabel", SldFrame)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name .. " : " .. tostring(val)
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame", SldFrame)
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 0, 34)
            Track.BackgroundColor3 = Ghostline.Theme.BackgroundPrimary
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
                TweenService:Create(Fill, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
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
            BoxFrame.Size = UDim2.new(1, 0, 0, 38)
            BoxFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
            BoxFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 10)

            local Label = Instance.new("TextLabel", BoxFrame)
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Input = Instance.new("TextBox", BoxFrame)
            Input.Size = UDim2.new(0.4, 0, 0, 26)
            Input.Position = UDim2.new(0.6, -10, 0.5, -13)
            Input.BackgroundColor3 = Ghostline.Theme.BackgroundPrimary
            Input.Text = ""
            Input.PlaceholderText = "..."
            Input.TextColor3 = Ghostline.Theme.Text
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 12
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 7)

            Input.FocusLost:Connect(function() cfg.Callback(Input.Text) end)
        end

        function Tab:MakeKeybind(cfg)
            local currentKey = cfg.Default or Enum.KeyCode.E
            local KeyFrame = Instance.new("Frame", Container)
            KeyFrame.Size = UDim2.new(1, 0, 0, 38)
            KeyFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
            KeyFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)

            local Label = Instance.new("TextLabel", KeyFrame)
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local BindBtn = Instance.new("TextButton", KeyFrame)
            BindBtn.Size = UDim2.new(0, 90, 0, 26)
            BindBtn.Position = UDim2.new(1, -100, 0.5, -13)
            BindBtn.BackgroundColor3 = Ghostline.Theme.BackgroundPrimary
            BindBtn.Text = currentKey.Name
            BindBtn.TextColor3 = Ghostline.Theme.AccentGlow
            BindBtn.Font = Enum.Font.GothamBold
            BindBtn.TextSize = 12
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 7)

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
            CPFrame.Size = UDim2.new(1, 0, 0, 38)
            CPFrame.BackgroundColor3 = Ghostline.Theme.BackgroundSecondary
            CPFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 10)

            local Label = Instance.new("TextLabel", CPFrame)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ColorView = Instance.new("Frame", CPFrame)
            ColorView.Size = UDim2.new(0, 48, 0, 24)
            ColorView.Position = UDim2.new(1, -58, 0.5, -12)
            ColorView.BackgroundColor3 = cfg.Default or Color3.new(1, 1, 1)
            Instance.new("UICorner", ColorView).CornerRadius = UDim.new(0, 7)

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
