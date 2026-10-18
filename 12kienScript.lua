local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CUSTOM_IMAGE_ID = "rbxassetid://117828154165313"

if CoreGui:FindFirstChild("HubGUI") then
    CoreGui.HubGUI:Destroy()
end

local C = {
    Background = Color3.fromRGB(10, 10, 14),
    Panel = Color3.fromRGB(17, 17, 23),
    Card = Color3.fromRGB(24, 24, 32),
    Red = Color3.fromRGB(255, 48, 75),
    RedDark = Color3.fromRGB(120, 20, 40),
    White = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(145, 145, 160),
    Green = Color3.fromRGB(70, 230, 155),
    Pink = Color3.fromRGB(255, 105, 180),
}

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(parent, radius)
    create("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or C.Red,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function tween(obj, duration, props)
    local t = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function playClickSound()
    local sound = Instance.new("Sound", SoundService)
    sound.SoundId = "rbxassetid://6042053636"
    sound.Volume = 0.6
    sound:Play()
    task.delay(1, function() sound:Destroy() end)
end

local gui = create("ScreenGui", {
    Name = "HubGUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, CoreGui)

local function notify(message)
    playClickSound()
    local toast = create("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 15),
        Size = UDim2.fromOffset(310, 38),
        BackgroundColor3 = C.Card,
        TextColor3 = C.White,
        Text = "⚡ " .. message,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 999,
    }, gui)
    round(toast, 10)
    stroke(toast, C.Red, 1.5)
    
    tween(toast, 0.3, {Position = UDim2.new(0.5, 0, 0, 25)})
    task.delay(2.2, function()
        tween(toast, 0.2, {TextTransparency = 1, BackgroundTransparency = 1})
        task.delay(0.2, function() toast:Destroy() end)
    end)
end

local openButton = create("ImageButton", {
    Name = "OpenButton",
    Size = UDim2.fromOffset(48, 48),
    Position = UDim2.new(0.01, 0, 0.3, 0),
    BackgroundColor3 = C.Background,
    Image = CUSTOM_IMAGE_ID,
    AutoButtonColor = false,
}, gui)
round(openButton, 14)
stroke(openButton, C.Red, 2)

local StopFlyButton = create("TextButton", {
    Parent = gui,
    Name = "StopFlyButton",
    BackgroundColor3 = Color3.fromRGB(230, 30, 50),
    Position = UDim2.new(0.92, 0, 0.02, 0),
    Size = UDim2.fromOffset(38, 38),
    Font = Enum.Font.GothamBold,
    Text = "✕",
    TextColor3 = C.White,
    TextSize = 18,
    Visible = false,
}, gui)
round(StopFlyButton, 12)
stroke(StopFlyButton, C.White, 2)

local ShiftLockButton = create("TextButton", {
    Parent = gui,
    BackgroundColor3 = Color3.fromRGB(18, 22, 32),
    Position = UDim2.new(0.08, 0, 0.3, 0),
    Size = UDim2.fromOffset(36, 36),
    Font = Enum.Font.GothamBold,
    Text = "🎯",
    TextColor3 = C.White,
    TextSize = 16,
    Visible = false,
}, gui)
round(ShiftLockButton, 10)
stroke(ShiftLockButton, Color3.fromRGB(255, 60, 60), 2)

local main = create("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.fromOffset(650, 420),
    BackgroundColor3 = C.Background,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
}, gui)
round(main, 16)
stroke(main, C.Red, 1.5)

local BgImage = create("ImageLabel", {
    Image = CUSTOM_IMAGE_ID,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ImageTransparency = 0.78,
    ScaleType = Enum.ScaleType.Crop,
}, main)
round(BgImage, 16)

local scale = create("UIScale", { Scale = 1 }, main)
local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    scale.Scale = math.min(viewport.X / 690, viewport.Y / 460, 1)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local top = create("Frame", {
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundColor3 = C.Panel,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
}, main)

create("Frame", {
    Position = UDim2.new(0, 0, 1, -2),
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = C.Red,
    BorderSizePixel = 0,
}, top)

create("TextLabel", {
    Position = UDim2.new(0, 20, 0, 12),
    Size = UDim2.new(0, 400, 0, 25),
    BackgroundTransparency = 1,
    Text = "👑 TRƯƠNG TRỌNG KIÊN - HUB PRO MAX",
    TextColor3 = C.White,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBlack,
    TextSize = 15,
}, top)

create("TextLabel", {
    Position = UDim2.new(0, 21, 0, 37),
    Size = UDim2.new(0, 350, 0, 15),
    BackgroundTransparency = 1,
    Text = "LỚP 9.4 • TRƯỜNG THCS NHUẬN PHÚ TÂN",
    TextColor3 = C.Muted,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
}, top)

local close = create("TextButton", {
    Position = UDim2.new(1, -45, 0, 15),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = C.Card,
    Text = "×",
    TextColor3 = C.Red,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, top)
round(close, 9)

local sidebar = create("Frame", {
    Position = UDim2.new(0, 0, 0, 66),
    Size = UDim2.new(0, 155, 1, -66),
    BackgroundColor3 = C.Panel,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
}, main)

create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, sidebar)

create("UIPadding", {
    PaddingTop = UDim.new(0, 15),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
}, sidebar)

local content = create("Frame", {
    Position = UDim2.new(0, 155, 0, 66),
    Size = UDim2.new(1, -155, 1, -66),
    BackgroundTransparency = 1,
}, main)

local pageTitle = create("TextLabel", {
    Position = UDim2.new(0, 20, 0, 12),
    Size = UDim2.new(1, -40, 0, 25),
    BackgroundTransparency = 1,
    Text = "TIỆN ÍCH",
    TextColor3 = C.White,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
}, content)

local pageBody = create("ScrollingFrame", {
    Position = UDim2.new(0, 15, 0, 45),
    Size = UDim2.new(1, -30, 1, -55),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Red,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, content)

create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, pageBody)
local function clearBody()
    for _, child in ipairs(pageBody:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local function makeCard(titleText, descText, height)
    local card = create("Frame", {
        Size = UDim2.new(1, -4, 0, height or 62),
        BackgroundColor3 = C.Card,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
    }, pageBody)
    round(card, 10)
    stroke(card, C.RedDark, 1, 0.4)

    create("TextLabel", {
        Position = UDim2.new(0, 12, 0, 10),
        Size = UDim2.new(1, -24, 0, 20),
        BackgroundTransparency = 1,
        Text = titleText,
        TextColor3 = C.White,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
    }, card)

    create("TextLabel", {
        Position = UDim2.new(0, 12, 0, 30),
        Size = UDim2.new(1, -24, 0, 22),
        BackgroundTransparency = 1,
        Text = descText,
        TextColor3 = C.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextWrapped = true,
    }, card)

    return card
end

local noclipConn = nil
local espActive = false
local boxEspActive = false
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESPFolder"
local boxEspFolder = Instance.new("Folder", gui)
boxEspFolder.Name = "BoxESPFolder"

local shiftLockEnabled = false
local isLocked = false
local slConn = nil
local savedPos1 = nil
local savedPos2 = nil
local isFlying = false
local selectedTarget = nil

local function flyToCFrame(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local myHrp = char.HumanoidRootPart
        isFlying = true
        StopFlyButton.Visible = true
        notify("Đang bay mượt (Bấm nút ✕ để DỪNG)!")
        
        task.spawn(function()
            local speed = 165
            while isFlying and targetCFrame do
                local direction = (targetCFrame.Position - myHrp.Position)
                local distance = direction.Magnitude
                if distance < 5 or not isFlying then break end
                local step = math.min(distance, speed * 0.03)
                myHrp.CFrame = myHrp.CFrame + (direction.Unit * step)
                RunService.RenderStepped:Wait()
            end
            if isFlying then myHrp.CFrame = targetCFrame end
            isFlying = false
            StopFlyButton.Visible = false
            notify("Đã đến nơi!")
        end)
    end
end

StopFlyButton.MouseButton1Click:Connect(function()
    isFlying = false
    StopFlyButton.Visible = false
    notify("Đã dừng bay!")
end)

local MiniFrame = create("Frame", {
    Parent = gui,
    Size = UDim2.new(0, 160, 0, 110),
    Position = UDim2.new(0.85, -80, 0.2, 0),
    BackgroundColor3 = C.Background,
    BackgroundTransparency = 0.1,
    Visible = false,
    Active = true,
    Draggable = true,
}, gui)
round(MiniFrame, 12)
stroke(MiniFrame, C.Red, 2)

create("TextLabel", {
    Parent = MiniFrame,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "📌 MINI BASE TELEPORT",
    TextColor3 = C.White,
    TextSize = 10,
}, MiniFrame)

local mBtn1 = create("TextButton", {
    Parent = MiniFrame,
    Position = UDim2.new(0, 8, 0, 30),
    Size = UDim2.new(1, -16, 0, 32),
    BackgroundColor3 = C.RedDark,
    Font = Enum.Font.GothamBold,
    Text = "🚀 VỊ TRÍ 1",
    TextColor3 = C.White,
    TextSize = 10,
}, MiniFrame)
round(mBtn1, 6)

local mBtn2 = create("TextButton", {
    Parent = MiniFrame,
    Position = UDim2.new(0, 8, 0, 68),
    Size = UDim2.new(1, -16, 0, 32),
    BackgroundColor3 = C.RedDark,
    Font = Enum.Font.GothamBold,
    Text = "🚀 VỊ TRÍ 2",
    TextColor3 = C.White,
    TextSize = 10,
}, MiniFrame)
round(mBtn2, 6)

mBtn1.MouseButton1Click:Connect(function()
    if savedPos1 then flyToCFrame(savedPos1) else notify("Chưa lưu Vị Trí 1!") end
end)
mBtn2.MouseButton1Click:Connect(function()
    if savedPos2 then flyToCFrame(savedPos2) else notify("Chưa lưu Vị Trí 2!") end
end)

local pages = {
    UTILITY = {
        title = "TIỆN ÍCH HỮU ÍCH",
        build = function()
            local c1 = makeCard("Đi Xuyên Tường (Noclip)", "Đi xuyên qua mọi vật cản")
            local b1 = create("TextButton", {
                Parent = c1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(55, 26), BackgroundColor3 = C.RedDark, Text = "BẬT", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10
            }, c1) round(b1, 6)
            local noclipOn = false
            b1.MouseButton1Click:Connect(function()
                noclipOn = not noclipOn
                b1.BackgroundColor3 = noclipOn and C.Green or C.RedDark
                b1.Text = noclipOn and "TẮT" or "BẬT"
                if noclipOn then
                    noclipConn = RunService.Stepped:Connect(function()
                        local char = LocalPlayer.Character
                        if char then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
                    end)
                    notify("Đã bật Xuyên Tường")
                else
                    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
                    notify("Đã tắt Xuyên Tường")
                end
            end)

            -- ESP Chữ màu đỏ, không mũi tên
            local c2 = makeCard("Định Vị Người Chơi (ESP Tên Đỏ)", "Hiển thị tên và khoảng cách màu đỏ rõ nét")
            local b2 = create("TextButton", {
                Parent = c2, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(55, 26), BackgroundColor3 = C.RedDark, Text = "BẬT", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10
            }, c2) round(b2, 6)
            
            local function addESPToPlayer(v)
                if v == LocalPlayer then return end
                if not v.Character then return end
                local root = v.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                local bg = Instance.new("BillboardGui")
                bg.Name = v.Name
                bg.Parent = espFolder
                bg.Adornee = root
                bg.AlwaysOnTop = true
                bg.Size = UDim2.new(0, 150, 0, 40)
                bg.StudsOffset = Vector3.new(0, 3, 0)
                
                local txt = Instance.new("TextLabel")
                txt.Parent = bg
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 12
                txt.TextColor3 = Color3.fromRGB(255, 50, 50) -- Màu đỏ chuẩn
                txt.TextStrokeTransparency = 0
                txt.Text = v.DisplayName
                
                task.spawn(function()
                    while espActive and v.Character and root and root.Parent do
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((myChar.HumanoidRootPart.Position - root.Position).Magnitude)
                            txt.Text = v.DisplayName .. " [" .. dist .. "m]"
                        end
                        task.wait(0.1)
                    end
                    bg:Destroy()
                end)
            end

            b2.MouseButton1Click:Connect(function()
                espActive = not espActive
                b2.BackgroundColor3 = espActive and C.Green or C.RedDark
                b2.Text = espActive and "TẮT" or "BẬT"
                espFolder:ClearAllChildren()
                if espActive then
                    for _, v in ipairs(Players:GetPlayers()) do
                        addESPToPlayer(v)
                    end
                    notify("Đã bật Định Vị tên màu đỏ!")
                else
                    notify("Đã tắt Định Vị!")
                end
            end)

            -- Tính năng Bao bọc người chơi màu hồng (Box ESP)
            local cBox = makeCard("Bao Bọc Người Chơi (Box ESP Hồng)", "Bọc khung 3D màu hồng quanh nhân vật")
            local bBox = create("TextButton", {
                Parent = cBox, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(55, 26), BackgroundColor3 = C.RedDark, Text = "BẬT", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10
            }, cBox) round(bBox, 6)

            local function addBoxToPlayer(v)
                if v == LocalPlayer then return end
                if not v.Character then return end
                local root = v.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end

                local box = Instance.new("Highlight")
                box.Name = v.Name
                box.Parent = boxEspFolder
                box.Adornee = v.Character
                box.FillColor = C.Pink
                box.OutlineColor = Color3.fromRGB(255, 255, 255)
                box.FillTransparency = 0.5
                box.OutlineTransparency = 0
            end

            bBox.MouseButton1Click:Connect(function()
                boxEspActive = not boxEspActive
                bBox.BackgroundColor3 = boxEspActive and C.Green or C.RedDark
                bBox.Text = boxEspActive and "TẮT" or "BẬT"
                boxEspFolder:ClearAllChildren()
                if boxEspActive then
                    for _, v in ipairs(Players:GetPlayers()) do
                        addBoxToPlayer(v)
                    end
                    notify("Đã bật bao bọc người chơi màu hồng!")
                else
                    notify("Đã tắt bao bọc!")
                end
            end)

            -- Khóa màn hình fix chuẩn
            local c3 = makeCard("Khóa Màn Hình (Shift Lock Mobile)", "Cố định hướng camera di động mượt mà")
            local b3 = create("TextButton", {
                Parent = c3, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(55, 26), BackgroundColor3 = C.RedDark, Text = "BẬT", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10
            }, c3) round(b3, 6)
            b3.MouseButton1Click:Connect(function()
                shiftLockEnabled = not shiftLockEnabled
                ShiftLockButton.Visible = shiftLockEnabled
                b3.BackgroundColor3 = shiftLockEnabled and C.Green or C.RedDark
                b3.Text = shiftLockEnabled and "TẮT" or "BẬT"
                if shiftLockEnabled then
                    if slConn then slConn:Disconnect() end
                    slConn = RunService.RenderStepped:Connect(function()
                        if isLocked then
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local hrp = char.HumanoidRootPart
                                local camLook = Camera.CFrame.LookVector
                                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.atan2(-camLook.X, -camLook.Z), 0)
                            end
                        end
                    end)
                    notify("Đã bật Shift Lock (Bấm nút 🎯 màn hình)")
                else
                    isLocked = false
                    ShiftLockButton.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
                    if slConn then slConn:Disconnect(); slConn = nil end
                    notify("Đã tắt Shift Lock")
                end
            end)

            ShiftLockButton.MouseButton1Click:Connect(function()
                if shiftLockEnabled then
                    isLocked = not isLocked
                    ShiftLockButton.BackgroundColor3 = isLocked and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(18, 22, 32)
                    notify(isLocked ? "Đã khóa hướng nhìn" : "Đã mở khóa hướng nhìn")
                end
            end)

            local c4 = makeCard("Nhặt Đồ Tức Thì", "Không cần giữ nút tương tác")
            local b4 = create("TextButton", {
                Parent = c4, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(55, 26), BackgroundColor3 = C.RedDark, Text = "BẬT", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10
            }, c4) round(b4, 6)
            b4.MouseButton1Click:Connect(function()
                getgenv().FastInteract = not getgenv().FastInteract
                b4.BackgroundColor3 = getgenv().FastInteract and C.Green or C.RedDark
                b4.Text = getgenv().FastInteract and "TẮT" or "BẬT"
                task.spawn(function()
                    while getgenv().FastInteract do
                        task.wait(0.3)
                        for _, prompt in ipairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
                        end
                    end
                end)
                notify(getgenv().FastInteract and "Đã bật nhặt đồ tức thì" or "Đã tắt")
            end)
        end,
    },
    TELEPORT = {
        title = "LƯU & BAY TỌA ĐỘ",
        build = function()
            local c1 = makeCard("Hệ Thống Lưu Tọa Độ (2 Base)", "Lưu vị trí và bay đến lập tức")
            
            local bSave1 = create("TextButton", { Parent = c1, Position = UDim2.new(0, 12, 0, 56), Size = UDim2.new(0.47, 0, 0, 30), BackgroundColor3 = C.Panel, Text = "💾 LƯU VỊ TRÍ 1", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9 }, c1) round(bSave1, 6)
            local bSave2 = create("TextButton", { Parent = c1, Position = UDim2.new(0.51, 0, 0, 56), Size = UDim2.new(0.47, 0, 0, 30), BackgroundColor3 = C.Panel, Text = "💾 LƯU VỊ TRÍ 2", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9 }, c1) round(bSave2, 6)
            
            bSave1.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    savedPos1 = char.HumanoidRootPart.CFrame
                    notify("Đã lưu Vị Trí 1!")
                end
            end)
            bSave2.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    savedPos2 = char.HumanoidRootPart.CFrame
                    notify("Đã lưu Vị Trí 2!")
                end
            end)

            local bFly1 = create("TextButton", { Parent = c1, Position = UDim2.new(0, 12, 0, 92), Size = UDim2.new(0.47, 0, 0, 32), BackgroundColor3 = C.RedDark, Text = "🚀 BAY VỊ TRÍ 1", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9 }, c1) round(bFly1, 6)
            local bFly2 = create("TextButton", { Parent = c1, Position = UDim2.new(0.51, 0, 0, 92), Size = UDim2.new(0.47, 0, 0, 32), BackgroundColor3 = C.RedDark, Text = "🚀 BAY VỊ TRÍ 2", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9 }, c1) round(bFly2, 6)
            
            bFly1.MouseButton1Click:Connect(function()
                if savedPos1 then flyToCFrame(savedPos1) else notify("Chưa lưu Vị Trí 1!") end
            end)
            bFly2.MouseButton1Click:Connect(function()
                if savedPos2 then flyToCFrame(savedPos2) else notify("Chưa lưu Vị Trí 2!") end
            end)

            local bMini = create("TextButton", { Parent = c1, Position = UDim2.new(0, 12, 0, 132), Size = UDim2.new(1, -24, 0, 32), BackgroundColor3 = Color3.fromRGB(120, 40, 180), Text = "📌 TÁCH BẢNG MINI BẬT NHANH", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10 }, c1) round(bMini, 6)
            bMini.MouseButton1Click:Connect(function()
                MiniFrame.Visible = not MiniFrame.Visible
                notify(MiniFrame.Visible and "Đã hiện Bảng Mini!" or "Đã ẩn Bảng Mini")
            end)

            c1.Size = UDim2.new(1, -4, 0, 178)
        end,
    },
}
local function appendPart3()
    pages.PLAYERTP = {
        title = "BAY ĐẾN NGƯỜI CHƠI",
        build = function()
            local cTop = makeCard("Quét & Chọn Người Chơi Trong Server", "Chọn mục tiêu để bay tốc độ mượt 165")
            cTop.Size = UDim2.new(1, -4, 0, 45)

            local bRefresh = create("TextButton", {
                Parent = cTop, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(80, 26), BackgroundColor3 = C.RedDark, Text = "🔄 RESET", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10
            }, cTop) round(bRefresh, 6)

            local listContainer = create("ScrollingFrame", {
                Parent = pageBody,
                Size = UDim2.new(1, -4, 0, 190),
                BackgroundColor3 = C.Card,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
            }, pageBody)
            round(listContainer, 8)
            create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, listContainer)

            local function loadPlayers()
                for _, child in ipairs(listContainer:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer then
                        local pBtn = create("TextButton", {
                            Parent = listContainer,
                            Size = UDim2.new(1, -4, 0, 32),
                            BackgroundColor3 = C.Panel,
                            BackgroundTransparency = 0.3,
                            Font = Enum.Font.GothamBold,
                            Text = "👤 " .. plr.DisplayName .. " (@" .. plr.Name .. ")",
                            TextColor3 = C.White,
                            TextSize = 10,
                        }, listContainer)
                        round(pBtn, 6)
                        pBtn.MouseButton1Click:Connect(function()
                            selectedTarget = plr
                            notify("Đã chọn mục tiêu: " .. plr.DisplayName)
                        end)
                    end
                end
            end

            bRefresh.MouseButton1Click:Connect(function()
                loadPlayers()
                notify("Đã quét lại danh sách người chơi trong server!")
            end)
            loadPlayers()

            local bGo = create("TextButton", {
                Parent = pageBody,
                Size = UDim2.new(1, -4, 0, 38),
                BackgroundColor3 = Color3.fromRGB(255, 140, 0),
                Font = Enum.Font.GothamBold,
                Text = "🚀 BAY MƯỢT ĐẾN NGƯỜI CHƠI ĐÃ CHỌN",
                TextColor3 = C.White,
                TextSize = 11,
            }, pageBody)
            round(bGo, 8)

            bGo.MouseButton1Click:Connect(function()
                if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
                    flyToCFrame(selectedTarget.Character.HumanoidRootPart.CFrame)
                else
                    notify("Chưa chọn người chơi hoặc mục tiêu chưa vào game!")
                end
            end)
        end,
    }

    pages.SERVER = {
        title = "QUẢN LÝ SERVER",
        build = function()
            local c1 = makeCard("Đổi Server (Server Hop)", "Tìm server ít người hoặc đổi server mới")
            local b1 = create("TextButton", {
                Parent = c1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(75, 26), BackgroundColor3 = C.RedDark, Text = "ĐỔI SERVER", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9
            }, c1) round(b1, 6)
            b1.MouseButton1Click:Connect(function()
                notify("Đang tìm server mới...")
                local servers = {}
                local success, err = pcall(function()
                    local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
                    for _, s in ipairs(req.data) do
                        if type(s) == "table" and s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                            table.insert(servers, s.id)
                        end
                    end
                end)
                if #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
                else
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)

            local c2 = makeCard("Vào Lại Server Cũ (Rejoin)", "Kết nối lại ngay lập tức vào server hiện tại")
            local b2 = create("TextButton", {
                Parent = c2, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(75, 26), BackgroundColor3 = C.RedDark, Text = "REJOIN", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9
            }, c2) round(b2, 6)
            b2.MouseButton1Click:Connect(function()
                notify("Đang kết nối lại server...")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end,
    }

    pages.BOOST = {
        title = "TỐI ƯU & FPS",
        build = function()
            local c1 = makeCard("Siêu Anti-Lag Cường Hóa", "Tối ưu hóa đồ họa để tăng FPS tối đa")
            local b1 = create("TextButton", {
                Parent = c1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(65, 26), BackgroundColor3 = C.RedDark, Text = "KÍCH HOẠT", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 9
            }, c1) round(b1, 6)
            b1.MouseButton1Click:Connect(function()
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 1
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then v.Enabled = false end
                end
                notify("Đã bật Anti-Lag tối đa!")
            end)
        end,
    }
end

appendPart3()

local navItems = {
    {name = "TIỆN ÍCH", id = "UTILITY"},
    {name = "LƯU VỊ TRÍ", id = "TELEPORT"},
    {name = "BAY PLAYER", id = "PLAYERTP"},
    {name = "SERVER", id = "SERVER"},
    {name = "TỐI ƯU FPS", id = "BOOST"},
}

local navButtons = {}
local function renderPage(id)
    pageTitle.Text = pages[id].title
    clearBody()
    pages[id].build()
end

for index, info in ipairs(navItems) do
    local button = create("TextButton", {
        Name = info.id,
        LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = info.id == "UTILITY" and C.RedDark or C.Panel,
        Text = info.name,
        TextColor3 = info.id == "UTILITY" and C.White or C.Muted,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
    }, sidebar)
    round(button, 8)
    navButtons[info.id] = button

    button.MouseButton1Click:Connect(function()
        for k, btn in pairs(navButtons) do
            tween(btn, 0.15, {BackgroundColor3 = C.Panel})
            btn.TextColor3 = C.Muted
        end
        tween(button, 0.15, {BackgroundColor3 = C.RedDark})
        button.TextColor3 = C.White
        renderPage(info.id)
    end)
end

local function setOpen(visible)
    if visible then
        main.Visible = true
        main.Size = UDim2.fromOffset(610, 390)
        tween(main, 0.22, {Size = UDim2.fromOffset(650, 420)})
    else
        tween(main, 0.18, {Size = UDim2.fromOffset(610, 390)})
        task.delay(0.19, function() main.Visible = false end)
    end
end

openButton.MouseButton1Click:Connect(function() setOpen(not main.Visible) end)
close.MouseButton1Click:Connect(function() setOpen(false) end)

local dragging, dragStart, startPosition = false, nil, nil
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

renderPage("UTILITY")
notify("Chào mừng Trương Trọng Kiên trở lại!")
