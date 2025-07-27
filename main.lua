-- credits to 0x83 for aimbot tut, build so much on it :D
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local CurrentCamera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Settings = {
    AimAssist = {
        Enabled = false, -- Toggle with your keybind below
        AimPart = "Head", -- "Head" or "HumanoidRootPart"
        TeamCheck = false, -- Ignore teammates if true
        Keybind = Enum.KeyCode.T, -- Use Enum.Keycode or quotes eg. Enum.Keycode.K or "K"
        FOVCircle = false, -- A circle to indicate your range
        FOVRadius = 250, -- How big your range will be
        FOVColour = Color3.fromRGB(255, 255, 255), -- The colour of your circle
        FOVFilled = false, -- If your circle is filled in with the colour above 
        FOVTransparency = 1, -- 1 = not transparent 0 = transparent
        WallCheck = nil, -- If you want to AimAssist through walls (NOT FINISHED)
    },

    ESP = {

    },
}

local FOVCircle = Drawing.new("Circle") -- bassicaly just refrencing the settings we put above
FOVCircle.Visible = false
FOVCircle.Radius = Settings.AimAssist.FOVRadius
FOVCircle.Color = Settings.AimAssist.FOVColour
FOVCircle.Thickness = 1 -- i mean if you wanna change this then.... you can but like idk
FOVCircle.Filled = Settings.AimAssist.FOVFilled
FOVCircle.Transparency = Settings.AimAssist.FOVTransparency

if Settings.AimAssist.FOVCircle then 
    FOVCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
end

-- too lazy to document
local function GetClosestPlayer()
    local BestTarget = nil
    local BestHealth = math.huge
    local ClosestDistance = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild(Settings.AimAssist.AimPart) then
            local humanoid = plr.Character:FindFirstChild("Humanoid")

            if humanoid.Health > 0 then
                if Settings.AimAssist.TeamCheck and plr.Team == Player.Team then
                    continue
                end

                local aimPart = plr.Character[Settings.AimAssist.AimPart]
                local screenPoint, onScreen = CurrentCamera:WorldToScreenPoint(aimPart.Position)

                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if distance <= Settings.AimAssist.FOVRadius then
                        -- Priority logic:
                        -- 1. Lower HP gets top priority
                        -- 2. If same HP, pick closer one
                        if humanoid.Health < BestHealth or (humanoid.Health == BestHealth and distance < ClosestDistance) then
                            BestHealth = humanoid.Health
                            ClosestDistance = distance
                            BestTarget = plr.Character
                        end
                    end
                end
            end
        end
    end

    return BestTarget
end


-- too lazy to document
RunService.RenderStepped:Connect(function()
    if Settings.AimAssist.Enabled then
        local closestCharacter = GetClosestPlayer()
        if closestCharacter and closestCharacter:FindFirstChild(Settings.AimAssist.AimPart) then
            local aimPart = closestCharacter[Settings.AimAssist.AimPart]
            local success, err = pcall(function()
                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, aimPart.Position)
            end)
            if not success then
                warn("AimAssist Camera Error:", err)
            end
        end
    end

    if FOVCircle.Visible and Settings.AimAssist.FOVCircle then
        FOVCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
        FOVCircle.Radius = Settings.AimAssist.FOVRadius
        FOVCircle.Color = Settings.AimAssist.FOVColour
        FOVCircle.Filled = Settings.AimAssist.FOVFilled
        FOVCircle.Transparency = Settings.AimAssist.FOVTransparency
    end

    if Settings.AimAssist.Enabled and Settings.AimAssist.FOVCircle then
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

shared.VapeIndependent = true
local vape = loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua', true))()

local AimAssist = vape.Categories.Combat:CreateModule({
    Name = 'AimAssist',
    Function = function(callback)
        Settings.AimAssist.Enabled = callback
        print("AimAssist Toggled:", Settings.AimAssist.Enabled)
    end,
    Tooltip = 'Aims for you'
})

local FOVCircleToggle
local FilledFOVCircleToggle
local FOVCircleColourToggle
local AimAssistTeamCheck
local FOVCircleRadiusSlider
local FOVCircleTransparencySlider
local AimAssistAimPart

AimAssistTeamCheck = AimAssist:CreateToggle({
    Name = 'Team Check',
    Function = function(callback)
        Settings.AimAssist.TeamCheck = not Settings.AimAssist.TeamCheck
    end,
    Tooltip = 'Ignore teammates if true'
})

FOVCircleToggle = AimAssist:CreateToggle({
    Name = 'FOV Circle',
    Function = function(callback)
        Settings.AimAssist.FOVCircle = not Settings.AimAssist.FOVCircle
    end,
    Tooltip = 'A circle to indicate your range'
})

FilledFOVCircleToggle = AimAssist:CreateToggle({
    Name = 'Filled',
    Function = function(callback)
        Settings.AimAssist.FOVFilled = not Settings.AimAssist.FOVFilled
    end,
    Tooltip = 'If your circle is filled in.'
})

FOVCircleRadiusSlider = AimAssist:CreateSlider({
    Name = 'Radius',
    Min = 1,
    Max = 500,
    Function = function(val)
        Settings.AimAssist.FOVRadius = val
    end,
    Tooltip = 'How big your range will be'
})

FOVCircleColourToggle = AimAssist:CreateColorSlider({
    Name = 'Colour',
    Function = function(hue, sat, val, opacity)
        Settings.AimAssist.FOVColour = Color3.fromHSV(hue, sat, val)
        Settings.AimAssist.FOVTransparency = opacity
    end,
    Tooltip = 'The colour of your circle'
})


AimAssistAimPart = AimAssist:CreateDropdown({
    Name = 'AimPart',
    List = {'Head', 'HumanoidRootPart'},
    Function = function(val)
        Settings.AimAssist.AimPart = val
    end,
    Tooltip = 'Where the aimassist aims. Head or Torso'
})

vape:Init()
