local Helper = {}
Helper.Tween = game:GetService("TweenService")

function Helper.StartCutscene()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
end

function Helper.EndCutscene()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end

function Helper.Speak(Text)
    game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Cutscene").TextLabel.Text = Text
end

function Helper.SlideCamera(Goal, Time, Style)
    Time = Time or 1 
    Style = Style or Enum.EasingStyle.Linear

    Helper.Tween:Create(
        workspace.CurrentCamera,
        TweenInfo.new(
            Time,
            Style,
            Enum.EasingDirection.Out
        ),
        {CFrame = Goal}
    ):Play()

    return Time
end

return Helper