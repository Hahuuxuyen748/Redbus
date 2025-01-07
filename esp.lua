local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Hàm tạo thông báo hiển thị
local function showNotification()
    local gui = Instance.new("ScreenGui")
    gui.Name = "NotificationGUI"
    gui.Parent = player.PlayerGui

    local textLabel = Instance.new("TextLabel", gui)
    textLabel.Size = UDim2.new(0.5, 0, 0.1, 0) -- Kích thước giao diện
    textLabel.Position = UDim2.new(0.25, 0, 0.1, 0) -- Vị trí ở giữa trên màn hình
    textLabel.BackgroundColor3 = Color3.new(0, 0, 0) -- Màu nền đen
    textLabel.BackgroundTransparency = 0.5 -- Độ trong suốt
    textLabel.TextColor3 = Color3.new(1, 1, 1) -- Màu chữ trắng
    textLabel.TextScaled = true -- Chữ tự động co giãn
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = "Code by Hà Hữu Xuyên 🇻🇳"

    -- Tự động xóa thông báo sau 5 giây
    wait(5)
    gui:Destroy()
end

-- Hàm tự động ghim đầu kẻ địch
local function autoAim()
    while true do
        local enemies = {}
        for _, obj in pairs(game.Players:GetPlayers()) do
            if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
                table.insert(enemies, obj.Character)
            end
        end

        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Head") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Ghim đầu vào đầu kẻ địch
                local head = enemy.Head
                character:SetPrimaryPartCFrame(CFrame.new(head.Position))
            end
        end
        wait(0.1) -- Điều chỉnh tốc độ aim
    end
end

-- Hàm tạo tia (beam) xuyên tường
local function createBeam(origin, target)
    local attachment1 = Instance.new("Attachment", origin)
    local attachment2 = Instance.new("Attachment", target)

    local beam = Instance.new("Beam", origin)
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Color = ColorSequence.new(Color3.fromHSV(math.random(), 1, 1)) -- Màu ngẫu nhiên
    beam.LightEmission = 1
    return beam
end

-- Hàm tạo ESP cho địch
local function espEnemies()
    while true do
        local enemies = {}
        for _, obj in pairs(game.Players:GetPlayers()) do
            if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
                table.insert(enemies, obj.Character)
            end
        end

        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Tạo tia xuyên tường cho địch
                local beam = createBeam(character.PrimaryPart, enemy.PrimaryPart)

                -- Hiển thị tên địch trên màn hình
                local nameTag = Instance.new("BillboardGui", enemy.Head)
                nameTag.Adornee = enemy.Head
                nameTag.Size = UDim2.new(0, 200, 0, 50)
                nameTag.StudsOffset = Vector3.new(0, 2, 0)
                local textLabel = Instance.new("TextLabel", nameTag)
                textLabel.Text = enemy.Name
                textLabel.TextSize = 18
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.BackgroundTransparency = 1
                textLabel.TextStrokeTransparency = 0.5
                textLabel.TextScaled = true

                wait(0.1) -- Tia tồn tại trong 0.1 giây
                beam:Destroy()
                nameTag:Destroy()
            end
        end
        wait(0.5) -- Cập nhật ESP sau mỗi 0.5 giây
    end
end

-- Hàm dịch chuyển đến kẻ địch
local function teleportToEnemy()
    while true do
        local enemies = {}
        for _, obj in pairs(game.Players:GetPlayers()) do
            if obj ~= player and obj.Character and obj.Character:FindFirstChild("Humanoid") then
                table.insert(enemies, obj.Character)
            end
        end

        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Dịch chuyển đến vị trí của kẻ địch
                character:SetPrimaryPartCFrame(enemy.PrimaryPart.CFrame)
            end
        end
        wait(1) -- Dịch chuyển tới địch mỗi giây
    end
end

-- Hàm khởi tạo lại các chức năng sau khi respawn
local function onCharacterAdded(newCharacter)
    character = newCharacter
    -- Hiển thị thông báo khi bắt đầu script
    showNotification()

    -- Bắt đầu auto aim, ESP và teleport
    autoAim()
    espEnemies()
    teleportToEnemy()
end

-- Gọi hàm khi nhân vật mới được tạo (sau khi chết và hồi sinh)
player.CharacterAdded:Connect(onCharacterAdded)

-- Khi bắt đầu, nếu nhân vật đã có thì sẽ kích hoạt ngay
if player.Character then
    onCharacterAdded(player.Character)
end