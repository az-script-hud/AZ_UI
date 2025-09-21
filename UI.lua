--====================================================--
-- Gemini / AZ UI Library (مع أزرار Close + Minimize + Drag)
--====================================================--

local GeminiUI = {}
GeminiUI.__index = GeminiUI

-- دالة إنشاء واجهة جديدة
function GeminiUI:Create(title)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AZ_UI") then
        LocalPlayer.PlayerGui.AZ_UI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AZ_UI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.ClipsDescendants = true

    -- تمكين السحب Drag
    local dragging, dragInput, dragStart, startPos
    MainFrame.Active = true
    MainFrame.Draggable = false -- الطريقة القديمة Deprecated
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Header.Size = UDim2.new(1, 0, 0, 30)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Header
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = title or "AZ UI"
    TitleLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)

    -- زر التصغير -
    local Minimize = Instance.new("TextButton")
    Minimize.Parent = Header
    Minimize.Size = UDim2.new(0, 30, 0, 30)
    Minimize.Position = UDim2.new(1, -60, 0, 0)
    Minimize.Text = "-"
    Minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.Font = Enum.Font.SourceSansBold
    Minimize.TextSize = 20

    -- زر الإغلاق ×
    local Close = Instance.new("TextButton")
    Close.Parent = Header
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.Text = "×"
    Close.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Close.Font = Enum.Font.SourceSansBold
    Close.TextSize = 20

    -- أحداث الأزرار
    local minimized = false
    Minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Size = minimized and UDim2.new(0, 450, 0, 30) or UDim2.new(0, 450, 0, 350)
    end)

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- منطقة المحتوى
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Parent = MainFrame
    MainContent.BackgroundTransparency = 1
    MainContent.Position = UDim2.new(0, 0, 0, 30)
    MainContent.Size = UDim2.new(1, 0, 1, -30)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainContent
    TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.Size = UDim2.new(0, 110, 1, 0)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainContent
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 110, 0, 0)
    ContentContainer.Size = UDim2.new(1, -110, 1, 0)

    local UI = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Header = Header,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        Tabs = {}
    }

    return setmetatable(UI, GeminiUI)
end

-- باقي الدوال (AddTab / AddToggle / AddSlider ...) تبقى نفسها مثل المكتبة السابقة

return GeminiUI
