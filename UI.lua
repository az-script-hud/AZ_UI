--====================================================--
-- Gemini UI Library (فصل المكتبة عن السكربت الأساسي)
-- الإصدار: V4.1
--====================================================--

local GeminiUI = {}
GeminiUI.__index = GeminiUI

-- إنشاء واجهة رئيسية
function GeminiUI:Create(title)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("CustomUI_Gemini_V4") then
        LocalPlayer.PlayerGui.CustomUI_Gemini_V4:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUI_Gemini_V4"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    MainFrame.BorderSizePixel = 1
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.ClipsDescendants = true

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Header.Size = UDim2.new(1, 0, 0, 30)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Font = Enum.Font.SourceSans
    Title.Text = title or "Gemini Controls"
    Title.TextColor3 = Color3.fromRGB(225, 225, 225)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0.05, 0, 0, 0)

    -- تبويبات
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

-- إنشاء تبويب جديد
function GeminiUI:AddTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    TabButton.Font = Enum.Font.SourceSansSemibold
    TabButton.TextSize = 16
    TabButton.Parent = self.TabContainer

    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.Visible = false
    Content.BackgroundTransparency = 1
    Content.CanvasSize = UDim2.new(0, 0, 0, 500)
    Content.ScrollBarThickness = 6
    Content.Parent = self.ContentContainer

    self.Tabs[name] = {Button = TabButton, Content = Content, Y = 15}

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        Content.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)

    return self.Tabs[name]
end

-- إضافة زر Toggle
function GeminiUI:AddToggle(tabName, text, callback)
    local t = self.Tabs[tabName]
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, t.Y)
    btn.Text = text .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 14
    btn.Parent = t.Content
    t.Y = t.Y + 40

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        if callback then callback(state) end
    end)
end

-- إضافة Slider
function GeminiUI:AddSlider(tabName, text, min, max, default, callback)
    local t = self.Tabs[tabName]

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = UDim2.new(0.05, 0, 0, t.Y)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = t.Content
    t.Y = t.Y + 25

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 25)
    box.Position = UDim2.new(0.05, 0, 0, t.Y)
    box.Text = tostring(default)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.ClearTextOnFocus = false
    box.Parent = t.Content
    t.Y = t.Y + 35

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            n = math.clamp(n, min, max)
            label.Text = text .. ": " .. n
            if callback then callback(n) end
        else
            box.Text = tostring(default)
        end
    end)
end

return GeminiUI
