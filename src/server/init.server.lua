local Datastore = require(script.Parent.Datastore)

local Tycoons = workspace.Tycoons
local Tycoon = Tycoons.Tycoon:Clone()

Tycoons.Tycoon:Destroy()

-- Functions

function CreateTycoon()
    local NewTycoon = Tycoon:Clone()
    NewTycoon.Name = #Tycoons:GetChildren() + 1
    NewTycoon.BaseTycoonModel:SetPrimaryPartCFrame(CFrame.new(
        2,
        .2, -- basepart height
        (50 * -#Tycoons:GetChildren()) - 5
    ))
    NewTycoon.Parent = Tycoons

    return NewTycoon
end

function MainTycoon(TycoonModel)
    local Owner = TycoonModel.Owner
    local Connections = {}
end

function PlayerAdded(Player:Player)
    local MainCurrency = Instance.new("ObjectValue")
    MainCurrency.Name = "MainCurrency"
    MainCurrency.Value = 0 or Datastore.GetMainCurrency(Player)
    MainCurrency.Parent = Player

    local SecondaryCurrency = Instance.new("ObjectValue")
    SecondaryCurrency.Name = "SecondaryCurrency"
    SecondaryCurrency.Value = 0 or Datastore.GetSecondaryCurrency(Player)
    SecondaryCurrency.Parent = Player

    local OwnedTycoon = Instance.new("ObjectValue")
    OwnedTycoon.Name = "OwnedTycoon"
    OwnedTycoon.Value = nil
    OwnedTycoon.Parent = Player
    
    Player.CharacterAdded:Connect(function(Character)
        if OwnedTycoon.Value then
            Character:MoveTo(
                OwnedTycoon.Value.BaseTycoonModel._Spawn.Position -- move char on spawn
            )
        end
    end)
end

-- Main

for _=1,4 do
    MainTycoon(CreateTycoon())
end

-- Connections

game:GetService("Players").PlayerAdded:Connect(PlayerAdded)