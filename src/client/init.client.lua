local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cutscene = require(script.CutsceneHelper)

local Remotes = ReplicatedStorage.Remotes

Remotes.StartCutscene.OnClientEvent:Connect(function()
    local Tycoon = Players.LocalPlayer.OwnedTycoon.Value
    local Cams = Tycoon.BaseTycoonModel.CutsceneParts

    Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
    Players.LocalPlayer.Character.Humanoid.JumpHeight = 0

    local OriginalCFrame = workspace.CurrentCamera.CFrame

    Cutscene.StartCutscene()
    task.wait(.1)
    Cutscene.Speak("Welcome!")
    task.wait(Cutscene.SlideCamera(Cams[1].CFrame, 4))
    Cutscene.Speak("This is your tycoon")
    task.wait(Cutscene.SlideCamera(Cams[2].CFrame, 2))
    task.wait(Cutscene.SlideCamera(Cams[3].CFrame, 2))
    task.wait(Cutscene.SlideCamera(OriginalCFrame))
    Cutscene.Speak("")
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    

    Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    Players.LocalPlayer.Character.Humanoid.JumpHeight = 7.2

end)