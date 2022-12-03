local function initButton(buttonData, button, player)
	local ButtonPart = game.ReplicatedStorage.Assets.Button:Clone()
end

return {
	Init = function(itemId, itemData, item, player)
		if itemId == "Room1" then
			
		end
		for localButtonId, button in pairs(item.Buttons) do
			initButton(localButtonId, button, player)
		end
	end,

	Save = function(data, roomId, buttonId)
		print("Save Room")
	end,
	
	Items = {	
		Room1 = {
			Buttons = {
				{ -- buy room 2
					Cost = 0,
					ItemId = "Room2",
					Title = "Unlock Room",
					Buttons = {

					}
				}
			}
		},
		Room2 = {
			Buttons = {
				{
					Cost = 0,
					ItemId = "Couch1",
					Title = "Buy Couch"
				}
			}
		}
	}
}