--// ESP
_G.TeamCheck = true
_G.ShowTeamESP = false

local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local ESPItems = {}

function disableESP(instance)
    if typeof(instance) ~= "Instance" then warn("instance is not valid: disableESP") return end
    local espData = ESPItems[instance]
    if espData then
        if espData.item then
            espData.item.Visible = false
        end
        ESPItems[instance] = nil
    end
end

function enableESP(instance)
    if typeof(instance) ~= "Instance" then warn("instance is not valid: enableESP") return end
    local espData = ESPItems[instance]
    if espData then
        if espData.item then
            espData.item.Visible = true
        end
        ESPItems[instance] = nil
    end
end


function removeESP(instance: Instance)
    if typeof(instance) ~= "Instance" then warn("instance is not valid: removeESP") return end
    local espData = ESPItems[instance]
    if espData then
        if espData.item then
            espData.item:Remove()
        end
        ESPItems[instance] = nil
    end
end

function addESP(instance: Instance)
    if typeof(instance) ~= "Instance" then warn("instance is not valid: addESP") return end

   local espData = ESPItems[instance]

   if espData then
        if espData.item then 
            return
        end
   end

    local esp = Drawing.new("Text")
    esp.Visible = false
    esp.Center = true
    esp.Outline = true
    esp.Font = 2
    esp.Color = Color3.fromRGB(255, 255, 255)
    esp.Size = 13

    local renderstepped = nil

    renderstepped = runService.RenderStepped:Connect(function()
        local instancePos, instanceOnScreen = camera:WorldToViewportPoint(instance.Head.Position)

        if instance.Name == game.Players.LocalPlayer.Name then return end
        if instanceOnScreen then
            esp.Position = Vector2.new(instancePos.X, instancePos.Y)
            esp.Visible = true
            esp.Text = instance.Name
        else
            esp.Visible = false
        end

        instance.Destroying:Connect(function()
            removeESP(instance)
        end)
    end)

    ESPItems[instance] = {
        item = esp
    }

end

while task.wait() do
    for _, v in game.Players:GetPlayers() do
        addESP(v.Character)
    end
end

game.Players.PlayerRemoving:Connect(function(player)
    local espData = ESPItems[player.Character]

    if espData then
        removeESP(player.Character)
    end

end)
