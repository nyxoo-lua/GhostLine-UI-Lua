local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Ghostline = {}
Ghostline.__index = Ghostline

Ghostline.Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(20, 20, 20),
    ElementBackground = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(220, 20, 60),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(40, 40, 40)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostlineUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 300, 1, -20)
NotifContainer.Position = UDim2.new(1, -320, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.Parent = NotifContainer

function Ghostline:MakeNotification(config)
    local title = config.Title or "Notification"
    local content = config.Content or "Texte"
    local time = config.Time or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.BackgroundColor3 = Ghostline.Theme.Background
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.Parent = NotifContainer

    local UICorner = Instance.new("UICorner", NotifFrame)
    UICorner.CornerRadius = UDim.new(0, 6)
    
    local UIStroke = Instance.new("UIStroke", NotifFrame)
    UIStroke.Color = Ghostline.Theme.Accent
    UIStroke.Thickness = 1
    UIStroke.Transparency = 1

    local TitleLabel = Instance.new("TextLabel", NotifFrame)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Ghostline.Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1

    local ContentLabel = Instance.new("TextLabel", NotifFrame)
    ContentLabel.Size = UDim2.new(1, -20, 0, 30)
    ContentLabel.Position = UDim2.new(0, 10, 0, 25)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = content
    ContentLabel.TextColor3 = Ghostline.Theme.Text
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 12
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.TextTransparency = 1

    TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(ContentLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(time, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        local fadeOut = TweenService:Create(ContentLabel, TweenInfo.new(0.3), {TextTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

function Ghostline.new(config)
    local Window = { Tabs = {}, CurrentTab = nil }
    local titleText = config.Name or "Ghostline"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = Ghostline.Theme.Background
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Ghostline.Theme.Border
    Stroke.Thickness = 1

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -15, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Ghostline.Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Line = Instance.new("Frame", MainFrame)
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0, 35)
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
    Sidebar.Size = UDim2.new(0, 130, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Ghostline.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)
    
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -130, 1, -36)
    ContentArea.Position = UDim2.new(0, 130, 0, 36)
    ContentArea.BackgroundTransparency = 1

    function Window:MakeTab(config)
        local tabName = config.Name or "Tab"
        local Tab = {}

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Ghostline.Theme.SubText
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

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

        TabBtn.MouseButton1Click:Connect(function()
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = Ghostline.Theme.SubText end
            end
            for _, frame in pairs(ContentArea:GetChildren()) do
                if frame:IsA("ScrollingFrame") then frame.Visible = false end
            end
            TabBtn.TextColor3 = Ghostline.Theme.Accent
            Container.Visible = true
        end)

        if #Sidebar:GetChildren() == 2 then 
            TabBtn.TextColor3 = Ghostline.Theme.Accent
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
            BtnFrame.Size = UDim2.new(1, 0, 0, 35)
            BtnFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            BtnFrame.Text = cfg.Name
            BtnFrame.TextColor3 = Ghostline.Theme.Text
            BtnFrame.Font = Enum.Font.GothamBold
            BtnFrame.TextSize = 13
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
            
            BtnFrame.MouseButton1Click:Connect(function() cfg.Callback() end)
        end

        function Tab:MakeToggle(cfg)
            local state = cfg.Default or false
            local TglFrame = Instance.new("TextButton", Container)
            TglFrame.Size = UDim2.new(1, 0, 0, 35)
            TglFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            TglFrame.Text = "  " .. cfg.Name
            TglFrame.TextColor3 = Ghostline.Theme.Text
            TglFrame.Font = Enum.Font.Gotham
            TglFrame.TextSize = 13
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 6)

            local Indicator = Instance.new("Frame", TglFrame)
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(1, -30, 0.5, -10)
            Indicator.BackgroundColor3 = state and Ghostline.Theme.Accent or Ghostline.Theme.Border
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

            TglFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Ghostline.Theme.Accent or Ghostline.Theme.Border}):Play()
                cfg.Callback(state)
            end)
        end

        function Tab:MakeSlider(cfg)
            local val = cfg.Default or cfg.Min
            local SldFrame = Instance.new("Frame", Container)
            SldFrame.Size = UDim2.new(1, 0, 0, 45)
            SldFrame.BackgroundColor3 = Ghostline.Theme.ElementBackground
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", SldFrame)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = cfg.Name .. " : " .. tostring(val)
            Label.TextColor3 = Ghostline.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame", SldFrame)
            Track.Size = UDim2.new(1, -20, 0, 6)
            Track.Position = UDim2.new(0, 10, 0, 30)
            Track.BackgroundColor3 = Ghostline.Theme.Background
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((val - cfg.Où est le script ? Colle-le ici et je retire tous les commentaires en gardant le reste du code intact.
