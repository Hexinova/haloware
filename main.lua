
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Camera = workspace.CurrentCamera

getgenv().ESP = false
getgenv().NameESP = false
getgenv().Aimbot = false

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "haloware",
    Footer = "v1.0.0",
    ToggleKeybind = Enum.KeyCode.Home,
    Center = true,
    AutoShow = true
})

local AimbotTab = Window:AddTab("Aimbot", "box", "Aimbot features")
local ESPTab = Window:AddTab("ESP", "box", "ESP features")
local SettingsTab = Window:AddTab({Name = "Settings", Description = "Change the settings on the hub", Icon = "settings"})

local ESPRightGroupbox = ESPTab:AddRightGroupbox("ESP", "box")
local ESPLeftGroupbox = ESPTab:AddLeftGroupbox("ESP Customization", "box")

local AimbotRightGroupbox = AimbotTab:AddRightGroupbox("Aimbot", "box")
local AimbotLeftGroupbox = AimbotTab:AddLeftGroupbox("Aimbot Customization", "box")

local AimbotToggle = AimbotRightGroupbox:AddCheckbox("Aimbot", {
    Text = "Aimbot",
    Default = false,
    Callback = function(v)
        getgenv().Aimbot = v
    end
})

local ESPToggle = ESPRightGroupbox:AddCheckbox("ESP", {
    Text = "ESP",
    Default = false,
    Callback = function(v)
        getgenv().ESP = v
    end
})

local NameESPToggle = ESPLeftGroupbox:AddCheckbox("Name ESP", {
    Text = "Name ESP",
    Default = false,
    Callback = function(v)
        getgenv().NameESP = v
    end
})

function ESP(plr: Player)
    local ESPConnection

    local Drawings = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        NameOutline = Drawing.new("Text"),
    }

    local function clearESP(type)
        if type == "Box" then
            Drawings.Box.Visible = false
            Drawings.BoxOutline.Visible = false
        end

        if type == "Name" then
            Drawings.Name.Visible = false
            Drawings.NameOutline.Visible = false
        end

        if type == "All" then
            for _, drawing in Drawings do
                drawing.Visible = false
            end
        end
    end

    local UpdateESP = function()
        ESPConnection = RunService.RenderStepped:Connect(function()
            local Character = plr.Character

            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local Position, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)

                local scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 1000
                local boxwidth, boxheight = math.floor(4.5 * scale), math.floor(6 * scale)
                local boxX, boxY = math.floor(Position.X), math.floor(Position.Y)
                local boxXPosition, boxYPosition = math.floor(boxX - boxwidth * 0.5), math.floor((boxY - boxheight * 0.5) + (0.5 * scale))

                local nameX = boxXPosition + (boxwidth / 2)
                local nameY = boxYPosition - 15

                
                if OnScreen then
                    if HumanoidRootPart then
                        if getgenv().ESP then

                            Drawings.Box.Size = Vector2.new(boxwidth, boxheight)
                            Drawings.Box.Position = Vector2.new(boxXPosition, boxYPosition)
                            Drawings.Box.Visible = true
                            Drawings.Box.Color = Color3.fromRGB(255, 255, 255)
                            Drawings.Box.Thickness = 1

                            Drawings.BoxOutline.Size = Vector2.new(boxwidth, boxheight)
                            Drawings.BoxOutline.Position = Vector2.new(boxXPosition, boxYPosition)
                            Drawings.BoxOutline.Visible = true
                            Drawings.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
                            Drawings.BoxOutline.Thickness = 2

                            Drawings.NameOutline.ZIndex = 1
                            Drawings.Name.ZIndex = 2
                            Drawings.BoxOutline.ZIndex = 1
                            Drawings.Box.ZIndex = 2
                        else
                            clearESP("Box")
                        end

                        if getgenv().NameESP then
                                Drawings.NameOutline.Text = plr.Name
                                Drawings.NameOutline.Center = true
                                Drawings.NameOutline.Size = 13
                                Drawings.NameOutline.Position = Vector2.new(nameX, nameY)
                                Drawings.NameOutline.Visible = true
                                Drawings.NameOutline.Color = Color3.fromRGB(0, 0, 0)
                                Drawings.NameOutline.ZIndex = 1

                                Drawings.Name.Text = plr.Name
                                Drawings.Name.Center = true
                                Drawings.Name.Size = 13
                                Drawings.Name.Position = Vector2.new(nameX, nameY)
                                Drawings.Name.Visible = true
                                Drawings.Name.Color = Color3.fromRGB(255, 255, 255)
                                Drawings.Name.ZIndex = 2
                            else
                                clearESP("Name")
                        end
                    else
                        clearESP("All")
                    end
                else
                    clearESP("All")
                end
            else
                clearESP("All")
            end
        end)
    end

    coroutine.wrap(UpdateESP)()
end

function lock(plr)
    
end

for _, v in Players:GetPlayers() do
    if v.Name ~= Player.Name then
        coroutine.wrap(ESP)(v)
    end
end

Players.PlayerAdded:Connect(function(v)
    task.delay(1, function()
        coroutine.wrap(ESP)(v)
    end)
end)
