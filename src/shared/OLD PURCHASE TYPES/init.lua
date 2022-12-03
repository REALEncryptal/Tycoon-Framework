--collect all the items in the modules together
local items = {}
local purchaseTypes = {}

for _, purchaseTypeModule in pairs(script:GetChildren()) do
	local purchaseType = require(purchaseTypeModule)
	local purchaseTypeId = purchaseTypeModule.Name
	purchaseTypes[purchaseTypeId] = purchaseType
	
	for itemId, item in pairs(purchaseType.Items) do
		item.PurchaseTypeId = purchaseTypeId
		items[itemId] = item
	end
end

local function defaultSave(data, roomId, buttonId)
	data.Rooms[roomId][buttonId] = true
end

return {
	GetItem = function(self, itemId)
		return items[itemId]
	end,
	
	Init = function(self, itemId, player)
		local item = self:GetItem(itemId)
		purchaseTypes[item.PurchaseTypeId].Init(itemId, item, player)
	end,
	
	Purchase = function(self, player, roomId, buttonId)
		--roomId is the room that houses the button you're stepping on
		--itemId is the new room / item ur purchasing
		
		--the data for the button you're stepping on
		local buttonData = self:GetItem(roomId).Buttons[buttonId]
		
		--the item you're purchasing because u stepped on the button
		local itemId = buttonData.ItemId
		local item = self:GetItem(itemId)
		
		--player's data
		local data = player.SavedData
		
		--purchase
		local coins = data.Statistics:GetAttribute("PrimaryCurrency")
		data.Statistics:SetAttribute("PrimaryCurrency", coins-buttonData.Cost)
	
		--save the fact that you purchased the button in that room
		data.Rooms[roomId].Buttons:SetAttribute(buttonId, true)
		
		--rooms specifically, we create an additional room
		if item.PurchaseTypeId == "Room" then
			local room = Instance.new("Folder")
			room.Name = itemId
			room.Parent = data.Rooms
		end
		
		self:Init(itemId)
	end,
}