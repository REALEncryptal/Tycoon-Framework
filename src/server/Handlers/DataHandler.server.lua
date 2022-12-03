--services
local dataStoreService = game:GetService("DataStoreService")
local dataStore = dataStoreService:GetDataStore("Currency")

--data to folder
local function dataToFolder(data, name)
	local folder = Instance.new("Folder")
	folder.Name = name
	
	for i,v in pairs(data) do
		if type(v) == "table" then
			dataToFolder(v, i).Parent = folder
		else
			folder:SetAttribute(i, v)
		end
	end
	
	return folder
end

--
local function folderToData(folder)
	local data = {}
	
	for i,v in pairs(folder:GetAttributes()) do
		
		data[i] = v
	end
	
	for _,folder in pairs(folder:GetChildren()) do
		data[folder.Name] = folderToData(folder)
	end

	return data
end

--
local function loadData(player)
	local data = dataStore:GetAsync(player.UserId) or {
		Statistics = {
			MainCurrency = 0,
			SecondaryCurrency = 0
		},
		Rooms = {
			{
				Buttons = {}
			}
		}
	}
	dataToFolder(data, "SavedData").Parent = player
end

local function saveData(player)
	local dataFolder = player:FindFirstChild("SavedData")
	if not dataFolder then return end
	dataStore:SetAsync(player.UserId, folderToData(dataFolder))
	dataFolder:Destroy()
end

game.Players.PlayerAdded:Connect(loadData)
game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	task.wait(2)
end)