local WisperUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

if _G.WisperUIInstance then
    _G.WisperUIInstance:Destroy()
    _G.WisperUIInstance = nil
end

local function Create(ClassName, Properties)
    local Instance_ = Instance.new(ClassName)
    for Property, Value in pairs(Properties) do
        Instance_[Property] = Value
    end
    return Instance_
end

local function Tween(Object, Properties, Duration, EasingStyle, EasingDirection)
    EasingStyle = EasingStyle or Enum.EasingStyle.Quad
    EasingDirection = EasingDirection or Enum.EasingDirection.Out
    Duration = Duration or 0.25
    local TweenObj = TweenService:Create(Object, TweenInfo.new(Duration, EasingStyle, EasingDirection), Properties)
    TweenObj:Play()
    return TweenObj
end

local function MakeDraggable(Frame, DragFrame)
    DragFrame = DragFrame or Frame
    local Dragging = false
    local DragInput, MousePos, FramePos
    
    DragFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = Frame.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    DragFrame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - MousePos
            Tween(Frame, {
                Position = UDim2.new(
                    FramePos.X.Scale,
                    FramePos.X.Offset + Delta.X,
                    FramePos.Y.Scale,
                    FramePos.Y.Offset + Delta.Y
                )
            }, 0.1)
        end
    end)
end

function WisperUI:CreateWindow(Config)
    Config = Config or {}
    Config.Title = Config.Title or "Wisper"
    Config.BuildDate = Config.BuildDate or os.date("%b. %d, %Y")
    
    local ScreenGui = Create("ScreenGui", {
        Name = "WisperUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    _G.WisperUIInstance = ScreenGui
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 800, 0, 600),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0
    })
    
    local UICorner = Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 0)
    })
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0
    })
    
    local TopBarLine = Create("Frame", {
        Name = "TopBarLine",
        Parent = TopBar,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0
    })
    
    local TitleLabel = Create("TextLabel", {
        Name = "TitleLabel",
        Parent = TopBar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Text = Config.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    })
    
    local BuildLabel = Create("TextLabel", {
        Name = "BuildLabel",
        Parent = TopBar,
        Position = UDim2.new(1, -200, 0, 0),
        Size = UDim2.new(0, 185, 1, 0),
        BackgroundTransparency = 1,
        Text = "Build: " .. Config.BuildDate,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.Gotham
    })
    
    local ContentFrame = Create("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -90),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0
    })
    
    local BottomBar = Create("Frame", {
        Name = "BottomBar",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 1, -50),
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0
    })
    
    local BottomBarLine = Create("Frame", {
        Name = "BottomBarLine",
        Parent = BottomBar,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0
    })
    
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = BottomBar,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, -10, 1, 0),
        BackgroundTransparency = 1
    })
    
    local TabLayout = Create("UIListLayout", {
        Parent = TabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 15)
    })
    
    local PlayerLabel = Create("TextLabel", {
        Name = "PlayerLabel",
        Parent = BottomBar,
        Position = UDim2.new(1, -200, 0, 0),
        Size = UDim2.new(0, 185, 1, 0),
        BackgroundTransparency = 1,
        Text = Player.Name,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.Gotham
    })
    
    MakeDraggable(MainFrame, TopBar)
    
    local Window = {
        MainFrame = MainFrame,
        ContentFrame = ContentFrame,
        TabContainer = TabContainer,
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:CreateTab(TabName, Icon)
        local TabButton = Create("TextButton", {
            Name = "TabButton_" .. TabName,
            Parent = self.TabContainer,
            Size = UDim2.new(0, 100, 0, 40),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false
        })
        
        local TabIcon = Create("ImageLabel", {
            Name = "TabIcon",
            Parent = TabButton,
            Position = UDim2.new(0, 5, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Image = Icon or "rbxassetid://7733960981",
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        })
        
        local TabLabel = Create("TextLabel", {
            Name = "TabLabel",
            Parent = TabButton,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -30, 1, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham
        })
        
        local TabContent = Create("ScrollingFrame", {
            Name = "TabContent_" .. TabName,
            Parent = self.ContentFrame,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
        
        local ContentLayout = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Icon = TabIcon,
            Label = TabLabel,
            Name = TabName,
            Active = false
        }
        
        TabButton.MouseButton1Click:Connect(function()
            self:SelectTab(Tab)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if not Tab.Active then
                Tween(TabIcon, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.15)
                Tween(TabLabel, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not Tab.Active then
                Tween(TabIcon, {ImageColor3 = Color3.fromRGB(150, 150, 150)}, 0.15)
                Tween(TabLabel, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.15)
            end
        end)
        
        table.insert(self.Tabs, Tab)
        
        if #self.Tabs == 1 then
            self:SelectTab(Tab)
        end
        
        local TabAPI = {
            Tab = Tab,
            Content = TabContent
        }
        
        function TabAPI:AddToggle(Config)
            Config = Config or {}
            Config.Name = Config.Name or "Toggle"
            Config.Default = Config.Default or false
            Config.Callback = Config.Callback or function() end
            
            local ToggleFrame = Create("Frame", {
                Name = "Toggle_" .. Config.Name,
                Parent = self.Content,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BorderSizePixel = 0
            })
            
            local ToggleCorner = Create("UICorner", {
                Parent = ToggleFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local ToggleButton = Create("TextButton", {
                Name = "ToggleButton",
                Parent = ToggleFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            })
            
            local ToggleLabel = Create("TextLabel", {
                Name = "ToggleLabel",
                Parent = ToggleFrame,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                Text = Config.Name,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham
            })
            
            local ToggleIndicator = Create("Frame", {
                Name = "ToggleIndicator",
                Parent = ToggleFrame,
                Position = UDim2.new(1, -35, 0.5, -8),
                Size = UDim2.new(0, 25, 0, 16),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0
            })
            
            local IndicatorCorner = Create("UICorner", {
                Parent = ToggleIndicator,
                CornerRadius = UDim.new(1, 0)
            })
            
            local ToggleCircle = Create("Frame", {
                Name = "ToggleCircle",
                Parent = ToggleIndicator,
                Position = UDim2.new(0, 2, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                BorderSizePixel = 0
            })
            
            local CircleCorner = Create("UICorner", {
                Parent = ToggleCircle,
                CornerRadius = UDim.new(1, 0)
            })
            
            local Toggled = Config.Default
            
            local function UpdateToggle()
                if Toggled then
                    Tween(ToggleIndicator, {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}, 0.2)
                    Tween(ToggleCircle, {
                        Position = UDim2.new(1, -14, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }, 0.2)
                else
                    Tween(ToggleIndicator, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
                    Tween(ToggleCircle, {
                        Position = UDim2.new(0, 2, 0.5, -6),
                        BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    }, 0.2)
                end
                
                pcall(Config.Callback, Toggled)
            end
            
            UpdateToggle()
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
            end)
            
            ToggleButton.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.15)
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.15)
            end)
            
            return {
                SetValue = function(Value)
                    Toggled = Value
                    UpdateToggle()
                end,
                GetValue = function()
                    return Toggled
                end
            }
        end
        
        function TabAPI:AddButton(Config)
            Config = Config or {}
            Config.Name = Config.Name or "Button"
            Config.Callback = Config.Callback or function() end
            
            local ButtonFrame = Create("Frame", {
                Name = "Button_" .. Config.Name,
                Parent = self.Content,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BorderSizePixel = 0
            })
            
            local ButtonCorner = Create("UICorner", {
                Parent = ButtonFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local Button = Create("TextButton", {
                Name = "Button",
                Parent = ButtonFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = Config.Name,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false
            })
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.1)
                pcall(Config.Callback)
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.15)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.15)
            end)
        end
        
        function TabAPI:AddLabel(Text)
            local LabelFrame = Create("Frame", {
                Name = "Label",
                Parent = self.Content,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1
            })
            
            local Label = Create("TextLabel", {
                Name = "Label",
                Parent = LabelFrame,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = Text,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham
            })
            
            return {
                SetText = function(NewText)
                    Label.Text = NewText
                end
            }
        end
        
        return TabAPI
    end
    
    function Window:SelectTab(Tab)
        for _, OtherTab in ipairs(self.Tabs) do
            if OtherTab == Tab then
                OtherTab.Active = true
                OtherTab.Content.Visible = true
                Tween(OtherTab.Icon, {ImageColor3 = Color3.fromRGB(100, 150, 255)}, 0.2)
                Tween(OtherTab.Label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            else
                OtherTab.Active = false
                OtherTab.Content.Visible = false
                Tween(OtherTab.Icon, {ImageColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
                Tween(OtherTab.Label, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
            end
        end
        self.CurrentTab = Tab
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
        _G.WisperUIInstance = nil
    end
    
    return Window
end

return WisperUI
