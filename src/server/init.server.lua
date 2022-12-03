local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
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

    local ClaimPart = TycoonModel.BaseTycoonModel._Claim
    local ClaimPartGui = ClaimPart.Att.Gui

    ---/ Functions
    local function StartTycoon()
        Remotes.StartCutscene:FireClient(Owner.Value) -- play cutscene

    end

    ---/ Connections
    -- ClaimPart
    Connections.ClaimConnection = ClaimPart.Touched:Connect(function(Touch)
        if not Touch.Parent:FindFirstChild("Humanoid") then return end
        if not Players:FindFirstChild(Touch.Parent.Name) then return end
        if Owner.Value then return end
        if Players:FindFirstChild(Touch.Parent.Name).OwnedTycoon.Value then return end

        Owner.Value = Players:FindFirstChild(Touch.Parent.Name)
        Owner.Value.OwnedTycoon.Value = TycoonModel

        ClaimPart.Transparency = 1
        ClaimPartGui.TextLabel.Text = Owner.Value.Name.. string.format(" ( %s )", Owner.Value.DisplayName)
        ClaimPartGui.TextLabel.TextColor3 = Color3.new(0.725490, 1, 0.717647)

        Connections.ClaimConnection:Disconnect()

        StartTycoon()
    end)
    -- Player leaving
    Connections.PlayerLeaving = Players.PlayerRemoving:Connect(function(Player)
        if Player ~= Owner.Value then return end

        -- do reset
    end)
end

function PlayerAdded(Player:Player)
    local OwnedTycoon = Instance.new("ObjectValue")
    OwnedTycoon.Name = "OwnedTycoon"
    OwnedTycoon.Value = nil
    OwnedTycoon.Parent = Player
    
    Player.CharacterAdded:Connect(function(Character)
        if OwnedTycoon.Value then
            task.wait(.1)
            Character:SetPrimaryPartCFrame(
                OwnedTycoon.Value.BaseTycoonModel._Spawn.CFrame -- move char on spawn
            )
        end
    end)
end

-- Main

for _=1,4 do
    MainTycoon(CreateTycoon())
end

-- Connections

Players.PlayerAdded:Connect(PlayerAdded)