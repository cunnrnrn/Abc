-- Script: √12kientomato.lua (Ultimate Mobile & PC Edition) -- UI Library: Rayfield (Tối ưu vuốt chạm cho Mobile / Delta)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players") local TeleportService = game:GetService("TeleportService") local HttpService = game:GetService("HttpService") local CoreGui = game:GetService("CoreGui") local LocalPlayer = Players.LocalPlayer
-- Biến lưu trữ vị trí & cấu hình local basePositionA = nil local basePositionB = nil local autoMoveActive = false
-- CHỨC NĂNG TẠO NÚT NỔI TOGGLE MENU (CHO MOBILE)
local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "TomatoMiniToggleUI" ScreenGui.ResetOnSpawn = false pcall(function() ScreenGui.Parent = CoreGui end) if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local ToggleButton = Instance.new("TextButton") ToggleButton.Parent = ScreenGui ToggleButton.Size = UDim2.new(0, 65, 0, 35) ToggleButton.Position = UDim2.new(0.02, 0, 0.25, 0) ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25) ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 127) ToggleButton.Text = "MENU" ToggleButton.TextSize = 12 ToggleButton.Font = Enum.Font.SourceSansBold ToggleButton.Active = true ToggleButton.Draggable = true
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 8) Corner.Parent = ToggleButton
local Stroke = Instance.new("UIStroke") Stroke.Color = Color3.fromRGB(0, 255, 127) Stroke.Thickness = 1.5 Stroke.Parent = ToggleButton
ToggleButton.MouseButton1Click:Connect(function() Rayfield:SelectTab(1) end)
-- TẠO CỬA SỔ MENU RAYFIELD
local Window = Rayfield:CreateWindow({ Name = "√12kientomato Hub", LoadingTitle = "Đang tải Giao diện Mobile...", LoadingSubtitle = "by 12kientomato", ConfigurationSaving = { Enabled = false }, Discord = { Enabled = false }, KeySystem = false })
-- TAB 1: DỊCH CHUYỂN & LƯU BASE (2 VỊ TRÍ)
local BaseTab = Window:CreateTab("Vị Trí Base", 4483362458)
BaseTab:CreateSection("--- Vị Trí A ---")
BaseTab:CreateButton({ Name = "Lưu Vị Trí Base A", Callback = function() local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then basePositionA = char.HumanoidRootPart.CFrame Rayfield:Notify({ Title = "Thành công", Content = "Đã lưu vị trí Base A!", Duration = 2.5 }) end end, })
BaseTab:CreateButton({ Name = "Teleport Tức Thời Về Base A", Callback = function() if basePositionA and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = basePositionA else Rayfield:Notify({ Title = "Lỗi", Content = "Chưa lưu Base A!", Duration = 2.5 }) end end, })
BaseTab:CreateSection("--- Vị Trí B ---")
BaseTab:CreateButton({ Name = "Lưu Vị Trí Base B", Callback = function() local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then basePositionB = char.HumanoidRootPart.CFrame Rayfield:Notify({ Title = "Thành công", Content = "Đã lưu vị trí Base B!", Duration = 2.5 }) end end, })
BaseTab:CreateButton({ Name = "Teleport Tức Thời Về Base B", Callback = function() if basePositionB and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = basePositionB else Rayfield:Notify({ Title = "Lỗi", Content = "Chưa lưu Base B!", Duration = 2.5 }) end end, })
-- TAB 2: GIẢ LẬP DI CHUYỂN (TỐC ĐỘ GỐC / WALK)
local MoveTab = Window:CreateTab("Giả Lập Tự Chạy", 4483363465)
local function simulateWalkTo(targetCFrame) local char = LocalPlayer.Character if not char then return end local humanoid = char:FindFirstChildOfClass("Humanoid") local hrp = char:FindFirstChild("HumanoidRootPart")
if not humanoid or not hrp then return end
autoMoveActive = true Rayfield:Notify({ Title = "Thông báo", Content = "Đang đi bộ về vị trí bằng tốc độ game...", Duration = 3 })
-- Giả lập di chuyển từng bước chuẩn tốc độ gốc (Humanoid:MoveTo) humanoid:MoveTo(targetCFrame.Position)
-- Vòng lặp giữ nhân vật tự đi và giả lập cần gạt / nút W task.spawn(function() while autoMoveActive and (hrp.Position - targetCFrame.Position).Magnitude > 4 do humanoid:MoveTo(targetCFrame.Position) task.wait(0.2) end if autoMoveActive then Rayfield:Notify({ Title = "Hoàn thành", Content = "Đã tự di chuyển đến vị trí!", Duration = 2.5 }) autoMoveActive = false end end) end
MoveTab:CreateButton({ Name = "Giả Lập Đi Bộ Về Base A (Tốc Độ Thật)", Callback = function() if basePositionA then simulateWalkTo(basePositionA) else Rayfield:Notify({ Title = "Lỗi", Content = "Chưa lưu Base A!", Duration = 2.5 }) end end, })
MoveTab:CreateButton({ Name = "Giả Lập Đi Bộ Về Base B (Tốc Độ Thật)", Callback = function() if basePositionB then simulateWalkTo(basePositionB) else Rayfield:Notify({ Title = "Lỗi", Content = "Chưa lưu Base B!", Duration = 2.5 }) end end, })
MoveTab:CreateButton({ Name = "Dừng Giả Lập Di Chuyển", Callback = function() autoMoveActive = false local char = LocalPlayer.Character if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):MoveTo(char.HumanoidRootPart.Position) end Rayfield:Notify({ Title = "Thông báo", Content = "Đã dừng di chuyển!", Duration = 2 }) end, })
-- TAB 3: TIỆN ÍCH SERVER (REJOIN & HOP SERVER ÍT NGƯỜI)
local ServerTab = Window:CreateTab("Quản Lý Server", 4483362748)
ServerTab:CreateButton({ Name = "Vào Lại Server Hiện Tại (Rejoin)", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end, })
ServerTab:CreateButton({ Name = "Chuyển Server Ít Người Nhất (Lowest Player Hop)", Callback = function() Rayfield:Notify({ Title = "Server Hop", Content = "Đang tìm server ít người...", Duration = 3 })
local placeId = game.PlaceId local serversUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(serversUrl)) end)
if success and result and result.data then for _, server in pairs(result.data) do if server.playing < server.maxPlayers and server.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer) return end end Rayfield:Notify({ Title = "Cảnh báo", Content = "Không tìm thấy server ít người hơn!", Duration = 3 }) else Rayfield:Notify({ Title = "Lỗi", Content = "Không thể lấy danh sách server!", Duration = 3 }) end end, })
Rayfield:Notify({ Title = "√12kientomato Hub", Content = "Đã tải xong Script! Bấm MENU để bật/tắt.", Duration = 4 })