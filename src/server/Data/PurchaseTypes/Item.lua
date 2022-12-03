local ItemTypes = {
    ["Workers"] = function()
        print("Subtype worker")
    end
}

return function(Button)
    local ItemId = Button.name
    local Tycoon = Button.Parent.Parent

    local Item = game.ReplicatedStorage.Assets.Items[ItemId]:Clone()
    Item:SetPrimaryPartCFrame(Tycoon.Items[ItemId].CFrame)
    Tycoon.Items[ItemId]:Destroy()
    Item.Parent = Tycoon.Items
    
    (ItemTypes[Button:GetAttribute("ItemType")] or function()end)()
end