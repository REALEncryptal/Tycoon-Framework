return function(Button)
    local Tycoon = Button.Parent.Parent
    Tycoon.Expansions[Button.Name]:Destroy()
end