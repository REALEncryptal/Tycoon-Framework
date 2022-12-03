local Library = {}

local PurchaseTypes = require(script.Parent.Parent.Data.PurchaseTypes)

local Assets = game.ReplicatedStorage.Assets
local ErrorRemote = game.ReplicatedStorage.Remotes.Error

local function currencyRequirement(button, currencyType, OwnerData)
    local currency, buttonCost = OwnerData.Statistics:GetAttribute(currencyType),  button:GetAttribute(currencyType)
    local validation = currency >= buttonCost
 
    if validation then
      button:SetAttribute(currency-buttonCost)
    else
      ErrorRemote:FireClient("You cannot afford this")
    end
 
    return validation
 end

function Library.InitTycoon(Tycoon)
    local SpawnedButtonIds = {}

    for _,Button in ipairs(Tycoon.Buttons:GetChildren()) do
        assert(not SpawnedButtonIds[Button.Name], "Button id is not unique: "..Button.Name)
        SpawnedButtonIds[Button.Name] = true

        Button.Transparency = 1

        Library.InitButton(Button)
    end
end

function Library.RenderButtons(Tycoon)
    for _, Button in ipairs(Tycoon.Buttons:GetChildren()) do
        local MakeVisible = Tycoon.Owner.Value.Data.Unlocked:GetAttribute(Button.Name) and true or false

        Button.VisualButton.GuiAttatchment.Title.Enabled = MakeVisible
        Button.VisualButton.Button.Transparency = MakeVisible and 0 or 1
        Button.VisualButton.Button.Base.Transparency = MakeVisible and 0 or 1
    end
end

function Library.InitButton(Button:MeshPart) : Model
    local IsPaid = Button:GetAttribute("Cost") ~= 0 and Button:GetAttribute("SecondCost") ~= 0
    
    local VisualButton = Assets.Button:Clone()  
    VisualButton:SetPrimaryPartCFrame(Button.CFrame)
    
    local TitleGui = VisualButton.GuiAttatchment.Title
    TitleGui.Paid.Visible = IsPaid
    TitleGui.Free.Visible = not IsPaid

    local TitleFrame = TitleGui.Free
    if IsPaid then
        TitleFrame = TitleGui.Paid
        TitleFrame.Cost.Text = "$"..Button:GetAttribute("SecondCost")
        if Button:GetAttribute("Cost") ~= 0 then
            TitleFrame.Cost.Text = "$"..Button:GetAttribute("Cost")
        end
    end

    TitleFrame.ItemName.Text = Button:GetAttribute("Label Name")

    Button.Touched:Connect(function(touch)
        local Owner = Button.Parent.Parent.Owner.Value
        if not Owner then return end
        if game.Players:GetPlayerFromCharacter(touch.Parent) ~= Owner then return end

        local OwnerData = Owner.Data

        if OwnerData.Unlocked:GetAttribute(Button.Name) then ErrorRemote:FireClient(Owner, "You already have that item!");return end
        if not OwnerData.Unlocked:GetAttribute(Button:GetAttribute("RequiredItem")) then ErrorRemote:FireClient(Owner, "You can't buy this yet!");return end
        if not currencyRequirement(Button, "MainCurrency") then return end
        if not currencyRequirement(Button, "SecondaryCurrency") then return end 

        OwnerData.Unlocked:SetAttribute(Button.Name, true)
        PurchaseTypes[Button.Name](Button)
        -- Render
        Library.RenderButtons(Button.Parent.Parent)
    end)

    return VisualButton
end

return Library