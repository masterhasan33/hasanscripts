local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local anaPlaceId = 3231515867
local yeraltiPlaceId = 6912384795
local hedefPos = Vector3.new(108, 5, -581)

-- Basit GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0,10,0,10)
frame.Size = UDim2.new(0,200,0,120)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local function makeLabel(text, posY)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.Text = text
    return label
end

local info1 = makeLabel("Durum: Bekleniyor...", 5)
local info2 = makeLabel("Süre: 0", 30)

local function moveToPosition(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:MoveTo(position)
    end
end

while true do
    if game.PlaceId == anaPlaceId then
        info1.Text = "Ana Oyunda, yeraltı üssüne teleport ediliyor..."
        wait(1)
        TeleportService:Teleport(yeraltiPlaceId, LocalPlayer)
        wait(10)
    elseif game.PlaceId == yeraltiPlaceId then
        info1.Text = "Yeraltı Üssündesin. 15 saniye bekleniyor..."
        for i=15,1,-1 do
            info2.Text = "Kalan süre: "..i.." sn"
            wait(1)
        end

        info1.Text = "Koordinata yürüyor..."
        moveToPosition(hedefPos)

        local startWalk = tick()
        while tick() - startWalk < 10 do
            for _, npc in pairs(game:GetDescendants()) do
                if npc:IsA("Humanoid") and npc.Health > 0 and npc.Parent.Name ~= LocalPlayer.Name then
                    npc.Health = 0
                end
            end
            info2.Text = "Yürürken NPC öldürülüyor..."
            wait(0.5)
        end

        info1.Text = "NPC öldürme döngüsü başladı. 120 saniye devam edecek."
        local startKill = tick()
        while tick() - startKill < 120 do
            for _, npc in pairs(game:GetDescendants()) do
                if npc:IsA("Humanoid") and npc.Health > 0 and npc.Parent.Name ~= LocalPlayer.Name then
                    npc.Health = 0
                end
            end
            local remaining = math.floor(120 - (tick() - startKill))
            info2.Text = "Kalan NPC öldürme süresi: "..remaining.." sn"
            wait(1)
        end

        info1.Text = "Ana oyuna dönülüyor..."
        TeleportService:Teleport(anaPlaceId, LocalPlayer)
        wait(10)
    else
        info1.Text = "Bilinmeyen yerde bekleniyor..."
        wait(5)
    end
end