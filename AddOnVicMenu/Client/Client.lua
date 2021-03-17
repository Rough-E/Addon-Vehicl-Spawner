ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

function openCarspawnMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name
	local elements = {
		{label = 'Delete current', value = 'delete_car'},
		{label = 'BMW', value = 'bmw_cars'},
		-- {label = 'gilet_wear', uniform = 'gilet_wear'},
		-- {label = 'police_wear', uniform = grade}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawner', {
		title    = 'Made for Coco with S2',
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'delete_car' then
			ExecuteCommand("dv")
		elseif data.current.value == 'bmw_cars' then
			-- ESX.UI.Menu.CloseAll()
			menu.close()
			openBMWspawnMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openBMWspawnMenu()
	local playerPed = PlayerPedId()
	local elements = {}
	for k, v in ipairs(Config.spawnable.bmw) do
		table.insert(elements, {label = v.label, value = 'car_spawnable', car = v.spawnname})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BMW', {
		title = 'BWM',
		align = 'right',
		elements = elements
	}, function(data, menu)
		for k,v in ipairs(Config.spawnable.bmw) do
			if data.current.value == 'car_spawnable' and data.current.label == v.label and data.current.car == v.spawnname then
				print(data.current.label)
				print(data.current.car)
				local carname = data.current.car
				deletecarOnspawn()
				Citizen.Wait(500)
				ExecuteCommand("car "..carname)
			end
		end
	end, function(data, menu)
		menu.close()
		openCarspawnMenu()
	end)
end

function deletecarOnspawn()
	local player = GetPlayerPed(-1)
	local isinvehicle = GetVehiclePedIsIn(ped, false)
	if isinvehicle then
		ExecuteCommand("dv")
	else
	end
end

RegisterCommand(Config.openCarSpawner, function()
	openCarspawnMenu()
end)
