local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

Script = {
    Version = "1.0.0",
}

local Window = Fluent:CreateWindow({
    Title = "MM2 Script " .. Script.Version,
    SubTitle = "by hexinova",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    AutoWin = Window:AddTab({ Title = "Auto Win", Icon = "crown" }),
    Premium = Window:AddTab({ Title = "Premium", Icon = "star" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

_G.AutoWin = false

local Toggle = Tabs.AutoWin:AddToggle("Auto Win", {Title = "Auto Win", Default = false })

Toggle:OnChanged(function()
    _G.AutoWin = not _G.AutoWin
end)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

RunService.RenderStepped:Connect(function(deltaTime)
    if _G.AutoWin then
        for i, v in Players:GetPlayers() do
            if v.Name == Player.Name then continue end
            if v.Backpack then
                if v.Backpack:FindFirstChild("Knife") then
                    print(v.Name, " has the knife")
                end
                if v.Backpack:FindFirstChild("Gun") then
                    print(v.Name, " has the gun")
                end
            end
        end

        for i, v in game.Workspace:GetChildren() do
            if v.Name == Player.Name then continue end
            if v:FindFirstChild("Humanoid") then
                if v:FindFirstChild("Knife") then
                    print(v.Name, " has the knife")
                end
                if v:FindFirstChild("Gun") then
                    print(v.Name, " has the gun")
                end
            end
        end

        if Player.Backpack:FindFirstChild("Knife") then
            print("You have the knife, finish all of them.")
        elseif Player.Backpack:FindFirstChild("Gun") then
            print("You have the gun, find the murderer.")
        end
    end
end)
