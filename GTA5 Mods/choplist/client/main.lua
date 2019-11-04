-- client-side chopshop job
Citizen.CreateThread(function()
info = AddBlipForCoord(-93.28, 19.40, 71.48)
SetBlipSprite(info, 66)
SetBlipDisplay(info, 4)
SetBlipScale(info, 1.0)
SetBlipColour(info, 5)
SetBlipAsShortRange(info, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Chop List")
EndTextCommandSetBlipName(info)
startLoc = {
  [1] = { x = - 93.28, y = 19.40, z = 71.48 }
}
-- /tp -93.28 19.40 71.48
droplocs = {
  [1] = { x = -515.90, y = 163.29, z = 70.93 },
  [2] = { x = 947.48, y = -1697.85, z = 30.09 },
  [3] = { x = -2952.00, y = 55.06, z = 11.20 },
  [4] = { x = -1502.31, y = -563.26, z = 22.81 },
  [5] = { x = 1903.72, y = 4922.19, z = 48.82 },
  [6] = { x = 437.0, y = 6454.41, z = 28.09 },
  [7] = { x = -678.63, y = 5797.29, z = 16.68 }
}
function drawText(text)
  SetTextFont(0)
  SetTextProportional(1)
  SetTextScale(0.0, 0.5)
  SetTextColour(255, 255, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(0, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(0.35, 0.85)
end
function meatOfJob()
  if IsPedInVehicle(playerPed, veh, true) then
    drawText("Press ~y~E~s~ to deliver ~b~" .. name .. "~s~.")
    if IsControlJustPressed(1, eKey) then
      if name == vehicleList[chance].vehicle then
        if GetVehicleBodyHealth(veh) < 900.00 then
          exports.pNotify:SendNotification({text = "Did you get this " .. name .. " from the junkyyard!? Go repair it!", type = "info", timeout = 5000, layout = "centerRight"})
        elseif GetVehicleBodyHealth(veh) >= 900.00 then
          local lastveh = GetVehiclePedIsIn(playerPed, true)
          local x2, y2, z2 = table.unpack(GetEntityCoords(playerPed, true))
          exports.pNotify:SendNotification({text = "Good job, you have delivered a " .. name .. ". Leave the area before someone sees you!", type = "info", timeout = 5000, layout = "centerRight"})
          Wait(1000)
          TriggerServerEvent("choplistjob", amount)
          Wait(5000)
          TriggerEvent('chatMessage', '^3[SERVER]^0', {255, 255, 255}, "Completed Chop Order: " .. vehicleList[chance].vehicle .. " for $" .. amount .. ".")
          Citizen.Wait(1000)
          DeleteEntity(lastveh)
          location = 0
        end
      else
        exports.pNotify:SendNotification({text = "Does this look like a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to you? Get out of here.. ", type = "info", timeout = 8000, layout = "centerRight"})
      end
    end
  end
end
function locationDisplay()
  if location == 1 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the Generic parking deck.", type = "info", timeout = 8000, layout = "centerRight"})
  elseif location == 2 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the storage unit.", type = "info", timeout = 8000, layout = "centerRight"})
  elseif location == 3 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the Pacific Bluffs Country Club.", type = "info", timeout = 8000, layout = "centerRight"})
  elseif location == 4 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the LOM Bank.", type = "info", timeout = 8000, layout = "centerRight"})
  elseif location == 5 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the Grapeseed barn.", type = "info", timeout = 8000, layout = "centerRight"})
  elseif location == 6 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the Paleto barn.", type = "info", timeout = 8000, layout = "centerRight"})
  elseif location == 7 then
    exports.pNotify:SendNotification({text = "Deliver a <font color='#FFFF00'>" .. vehicleList[chance].vehicle .. "</font> to the Paleto parking lot.", type = "info", timeout = 8000, layout = "centerRight"})
  end
end
model = GetHashKey("a_m_y_mexthug_01")
RequestModel(model)
while not HasModelLoaded(model) do
  Wait(0)
end
chopPed = CreatePed(26, model, - 93.28, 19.40, 71.48 - 1.0, 172.48, false, true)
while true do
  Citizen.Wait(0)
  playerPed = GetPlayerPed(-1)
  AddArmourToPed(playerPed, 100)
  eKey = 38
  handoff = "handposes-0"
  RequestAnimDict(handoff)
  veh = GetVehiclePedIsIn(playerPed, false)
  model = GetEntityModel(veh)
  displaytext = GetDisplayNameFromVehicleModel(model)
  name = GetLabelText(displaytext)
  hour = GetClockHours()
  minute = GetClockMinutes()
  if (hour < 7 or hour > 22) then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, startLoc[1].x, startLoc[1].y, startLoc[1].z) < 20.0) then
      DrawMarker(1, startLoc[1].x, startLoc[1].y, startLoc[1].z - 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0 + 0.5, 255, 0, 0, 500, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, startLoc[1].x, startLoc[1].y, startLoc[1].z) < 1.0) then
      drawText("Press ~y~E~s~ to get chop order from Vinny")
      if IsControlJustPressed(1, eKey) then
        TaskPlayAnim(playerPed, handoff, "p_notepad_01_s-0", 8.0, 8.0, 15000, 1, 1, false, true, true)
        TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
        exports.pNotify:SendNotification({text = "Getting name of a wanted vehicle..", type = "info", timeout = 15000, layout = "centerRight"})
        Citizen.Wait(16000)
        ClearPedTasksImmediately(playerPed)
        chance = math.floor(math.random(1, #vehicleList))
        location = math.floor(math.random(1, #droplocs))
        amount = math.floor(vehicleList[chance].payout * 0.075)
        locationDisplay()
        TriggerEvent('chatMessage', '^3[SERVER]^0', {255, 255, 255}, "Active Chop Order: " .. vehicleList[chance].vehicle .. ".")
        SetNewWaypoint(droplocs[location].x, droplocs[location].y, droplocs[location].z)
      end
    end
  else
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, startLoc[1].x, startLoc[1].y, startLoc[1].z) < 20.0) then
      DrawMarker(1, startLoc[1].x, startLoc[1].y, startLoc[1].z - 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0 + 0.5, 255, 0, 0, 500, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, startLoc[1].x, startLoc[1].y, startLoc[1].z) < 1.0) then
      drawText("Los Angeles Los-Cost Auto Insurance is ~r~Closed~s~")
    end
  end
  if location == 1 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[1].x, droplocs[1].y, droplocs[1].z) < 100.0) then
      DrawMarker(1, droplocs[1].x, droplocs[1].y, droplocs[1].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[1].x, droplocs[1].y, droplocs[1].z) < 4.0) then
      meatOfJob()
    end
  end
  if location == 2 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[2].x, droplocs[2].y, droplocs[2].z) < 100.0) then
      DrawMarker(1, droplocs[2].x, droplocs[2].y, droplocs[2].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[2].x, droplocs[2].y, droplocs[2].z) < 4.0) then
      meatOfJob()
    end
  end
  if location == 3 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[3].x, droplocs[3].y, droplocs[3].z) < 100.0) then
      DrawMarker(1, droplocs[3].x, droplocs[3].y, droplocs[3].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[3].x, droplocs[3].y, droplocs[3].z) < 4.0) then
      meatOfJob()
    end
  end
  if location == 4 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[4].x, droplocs[4].y, droplocs[4].z) < 100.0) then
      DrawMarker(1, droplocs[4].x, droplocs[4].y, droplocs[4].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[4].x, droplocs[4].y, droplocs[4].z) < 4.0) then
      meatOfJob()
    end
  end
  if location == 5 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[5].x, droplocs[5].y, droplocs[5].z) < 100.0) then
      DrawMarker(1, droplocs[5].x, droplocs[5].y, droplocs[5].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[5].x, droplocs[5].y, droplocs[5].z) < 4.0) then
      meatOfJob()
    end
  end
  if location == 6 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[6].x, droplocs[6].y, droplocs[6].z) < 100.0) then
      DrawMarker(1, droplocs[6].x, droplocs[6].y, droplocs[6].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[6].x, droplocs[6].y, droplocs[6].z) < 4.0) then
      meatOfJob()
    end
  end
  if location == 7 then
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    if (Vdist(x, y, z, droplocs[7].x, droplocs[7].y, droplocs[7].z) < 100.0) then
      DrawMarker(1, droplocs[7].x, droplocs[7].y, droplocs[7].z - 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0 + 0.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
    end
    if (Vdist(x, y, z, droplocs[7].x, droplocs[7].y, droplocs[7].z) < 4.0) then
      meatOfJob()
    end
  end
end
end)