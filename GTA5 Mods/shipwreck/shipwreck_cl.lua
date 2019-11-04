-- TODO: Look into implementing progress bar when salvaging
-- TODO: Look into animating progress bar
local submarines = {
		[1] = {hash = "SUBMERSIBLE"}, --Submersible
		[2] = {hash = "SUBMERSIBLE2"} --Kraken
}
local subStart = {
		marker = {x = 3854.92, y = 4459.69, z = 1.85},
		spawn = {x = 3873.45, y = 4451.17, z = 0.00, heading = 308.37}
}
local subEnd = {
		marker = {x = 3856.99, y = 4472.80, z = 0.00},
		spawn = {x = 3851.53, y = 4464.00, z = 2.73}
}
local pointsOfInterest = {
		[1] = {x = 4233.06, y = 3594.94, z = -46.46},
		[2] = {x = 3888.78, y = 3056.02, z = -25.40},
		[3] = {x = 3311.96, y = -416.09, z = -123.73},
		[4] = {x = 2659.56, y = -1426.59, z = -21.96},
		[5] = {x = 1851.92, y = -2937.70, z = -46.55},
		[6] = {x = 460.30, y = -2373.75, z = -11.76},
		[7] = {x = -328.90, y = -2300.02, z = -12.53},
		[8] = {x = -276.81, y = -2896.12, z = -17.83},
		[9] = {x = -2847.14, y = -414.80, z = -24.64},
		[10] = {x = -3181.74, y = 3047.80, z = -36.36},
		[11] = {x = -3262.50, y = 3665.76, z = -22.23},
		[12] = {x = -1016.75, y = 6501.45, z = -21.90},
		[13] = {x = 2662.49, y = 6648.11, z = -23.19},
}
local pointsOfInterestBlips = {}
local salvaging = false
local mtime = 0
local mduration = 15000
local activeSub = false
local purchased = false
RequestModel(submarines[1].hash)
RequestModel(submarines[2].hash)
while not HasModelLoaded(submarines[1].hash, submarines[2].hash) do
		Citizen.Wait(0)
end
function drawText(text, r, g, b, y)
		SetTextFont(0)
		SetTextProportional(0)
		SetTextScale(0.32, 0.32)
		SetTextColour(r, g, b, 255)
		SetTextDropShadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextCentre(1)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.475, y)
end
function drawBlip(blipX, blipY, blipZ, blipColour, blipName)
		local dBlip = AddBlipForCoord(blipX, blipY, blipZ)
		SetBlipSprite(dBlip, 308)
		SetBlipDisplay(dBlip, 4)
		SetBlipScale(dBlip, 1.0)
		SetBlipColour(dBlip, blipColour)
		SetBlipAsShortRange(dBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blipName)
		EndTextCommandSetBlipName(dBlip)
end
function spawnSub()
		math.randomseed(GetGameTimer())
		local randSub = math.random(1, #submarines)
		subVeh = CreateVehicle(submarines[randSub].hash, subStart.spawn.x, subStart.spawn.y, subStart.spawn.z, subStart.spawn.heading, true, true)
		SetPedIntoVehicle(playerPed, subVeh, -1)
end
function rentvehicle()
		if (purchased) then
				TriggerServerEvent("bms:jobs:shipwreck:rentvehicle")
				purchased = false
		end
end
function returnvehicle()
		if (activeSub) then
				TriggerServerEvent("bms:jobs:shipwreck:returnvehicle")
				activeSub = false
		end
end
RegisterNetEvent("bms:jobs:shipwreck:rentvehiclecomplete")
AddEventHandler("bms:jobs:shipwreck:rentvehiclecomplete", function(rentalCost, success)
		if (success) then
				exports.pnotify:SendNotification({text = string.format("You have rented a submersible for <font color='skyblue'>$%s</font> from Catfish Rentals", rentalCost)})
				print("submersible rented")
		else
				exports.pnotify:SendNotification({text = string.format("You do not have enough money on your person to rent a submersible")})
		end
end)
RegisterNetEvent("bms:jobs:shipwreck:returnvehiclecomplete")
AddEventHandler("bms:jobs:shipwreck:returnvehiclecomplete", function(rentalDeposit, success)
		if (success) then
				exports.pnotify:SendNotification({text = string.format("You have returned a submersible and received a <font color='skyblue'>$%s</font> rental deposit", rentalDeposit)})
				print("submersible returned")
		else
				exports.pnotify:SendNotification({text = string.format("You must return the submersible to receive a deposit.")})
		end
end)
RegisterNetEvent("bms:jobs:shipwreck:salvageComplete")
AddEventHandler("bms:jobs:shipwreck:salvageComplete", function()
		salvaging = false
		mtime = 0
		SendNUIMessage({hideJobProgress = true})
end)
-- WHEN PURCHASED, ACTIVATE THIS THREAD
Citizen.CreateThread(function()
		while true do
		Wait(100)
		if (purchased) then
				rentvehicle()
		end
		end
end)
-- WHILE MINING OR IN SUB, ACTIVATE THIS THREAD
Citizen.CreateThread(function()
		local reptime = 15000
		while true do
				Wait(0)
				if (salvaging) then
						--drawText("Searching wreckage for artifacts..", 0, 255, 255, 0.88)
						SendNUIMessage({updateJobProgress = true, title = "Searching for artifacts.. Please Wait", maxvalue = 15, progvalue = reptime / 1000})
				end
				if (activeSub) then
						local inSub = IsPedInVehicle(playerPed, subVeh)
						local depth = math.ceil(pos.z * 3.2808)
						subDepth = string.gsub(depth, "-", "")
						if (inSub) then
								drawText("Current Depth: " .. subDepth .. " feet", 255, 255, 255, 0.05)
								drawText("Max Recommended Depth: 492 feet", 255, 48, 48, 0.08)
						end
				end
		end
end)
-- WHEN DONE MINING, ACTIVATE THIS THREAD
Citizen.CreateThread(function()
		while true do
				Wait(1000)
				if (salvaging) then
						mtime = mtime + 1000
						if (mtime == mduration) then
								TriggerServerEvent("bms:jobs:shipwreck:finishSalvaging")
						end
				end
		end
end)
Citizen.CreateThread(function()
		while true do
				Citizen.Wait(0)
				playerPed = PlayerPedId()
				pos = GetEntityCoords(playerPed, true)
				local currentVeh = GetVehiclePedIsIn(playerPed, false)
				local dist = Vdist(pos.x, pos.y, pos.z, subStart.marker.x, subStart.marker.y, subStart.marker.z)
				DrawMarker(1, subStart.marker.x, subStart.marker.y, subStart.marker.z - 1.0001, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 1.1, 60, 201, 252, 172, 0, 0, 0, 0, 0, 0, 0) -- show return marker

				--Spawn Submersible
				if dist < 1.0 then
						drawText("Press ~y~E~s~ to rent a submersible", 0, 255, 255, 0.88)
						if IsControlJustPressed(1, 38) then --press E to spawn vehicle
								purchased = true
								activeSub = true
								if (activeSub) then
										drawBlip(3856.99, 4472.80, 0.00, 59, "Salvage Company")
										rentvehicle()
										spawnSub()
										if (#pointsOfInterestBlips == 0) then
												for i = 1, #pointsOfInterest do
														local blip = AddBlipForCoord(pointsOfInterest[i].x, pointsOfInterest[i].y, pointsOfInterest[i].z)
														SetBlipSprite(blip, 308)
														SetBlipDisplay(blip, 4)
														SetBlipScale(blip, 1.0)
														SetBlipColour(blip, 3)
														SetBlipAsShortRange(blip, true)
														BeginTextCommandSetBlipName("STRING")
														AddTextComponentString("Salvage Location")
														EndTextCommandSetBlipName(blip)
														table.insert(pointsOfInterestBlips, blip)
												end
										end
								end
						end
				end

				--Points of Interest
				for _,v in pairs(pointsOfInterest) do
						local searchDist =  Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z)
						if searchDist < 80.0 then
								DrawMarker(1, v.x, v.y, v.z - 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 2.0 + 0.5, 66, 176, 244, 172, 0, 0, 0, 0, 0, 0, 0)
						end
						if searchDist < 5.0 then
								if (not salvaging) then
										drawText("Press ~y~E~s~ to salvage wreckage", 0, 255, 255, 0.88)
										if IsControlJustPressed(1, 38) then --press E to spawn vehicle
												salvaging = true
										end
								end
						end
				end

				-- Return Vehicle
				if (activeSub) then
						local distReturn = Vdist(pos.x, pos.y, pos.z, subEnd.marker.x, subEnd.marker.y, subEnd.marker.z)
						DrawMarker(1, subEnd.marker.x, subEnd.marker.y, subEnd.marker.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 8.0, 2.0, 255, 0, 0, 172, 0, 0, 0, 0, 0, 0, 0)
						if distReturn < 8.0 then
								drawText("Press ~y~E~s~ to return submersible", 0, 255, 255, 0.88)
								if IsControlJustPressed(1, 38) then --press E to spawn vehicle
										SetEntityAsMissionEntity(subVeh, true, true)
										DeleteEntity(subVeh)
										SetEntityCoords(playerPed, subEnd.spawn.x, subEnd.spawn.y, subEnd.spawn.z, 1, 0, 0, 1)
										Wait(500)
										returnvehicle()
								end
						end
				end

		end --end while true loop
end) --end Citizen.CreateThread