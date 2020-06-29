-- if vehicle locked
local flag = false
local random1
local random2
local random3
local r1
local r2
local r3
local total
local scrambled
local scramble
local l1
local l2
local l3

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)
  local playerPed = GetPlayerPed(-1)
  local playerPos = GetEntityCoords(playerPed)
  local frontVehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 5.0, 0, 0) -- get vehicle within 5 meters
  local vehicleLockStatus = GetVehicleDoorLockStatus(frontVehicle) -- get lock status of closest vehicle
  local vehicleClass = GetVehicleClass(frontVehicle)
  local currentVehicle = GetVehiclePedIsIn(playerPed, false)
  local currentVehicleLockStatus = GetVehicleDoorLockStatus(currentVehicle)
  
  
  local IsRunning = GetIsVehicleEngineRunning(currentVehicle)

  if (not IsRunning) then -- not turned on if off, else turn off if on
    if (IsControlJustPressed(0, 57)) then -- F10
      SetVehicleEngineOn(currentVehicle, true, true, true) -- turns on engine
    end
  end


  if (IsRunning) then -- not turned on if off, else turn off if on
    if (IsControlJustPressed(0, 57)) then -- F10
      SetVehicleEngineOn(currentVehicle, false, true, true) -- turns off engine
    end
  end


  -- If player is outside vehicle
  if (IsControlJustPressed(0, 7) and vehicleLockStatus == 1) then -- unlocked
    TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Vehicle: " .. " ^0Locked ["..vehicleLockStatus.."]"}})
    SetVehicleDoorsLocked(frontVehicle, 2) -- lock
    -- 1 = Unlocked
    -- 2 = Locked
  end
  local display = false
  function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
      type = "ui",
      status = bool,
    })
  end
  function chat(str, color)
    TriggerEvent(
      'chat:addMessage',
      {
        color = color,
        multiline = true,
        args = {str}
      }
    )
  end  
  
  -- Non-Super Vehicles
  if (IsControlJustPressed(0, 7) and vehicleLockStatus == 2 and vehicleClass < 7) then
    TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Vehicle: " .. " ^0Non-Super Vehicle Unlocked! ["..vehicleLockStatus.."]"}})
    SetVehicleDoorsLocked(frontVehicle, 1) -- unlock
  end

  -- Super vehicles Only
  if (IsControlJustPressed(0, 7) and vehicleLockStatus == 2 and vehicleClass == 7) then -- locked
    SetDisplay(true)
    random1 = math.random(9)
    random2 = math.random(9)
    random3 = math.random(9)
    r1 = tostring(random1)
    r2 = tostring(random2)
    r3 = tostring(random3)
    total = r1 .. r2 .. r3
    l1 = string.sub(r1, 1, 1)
    l2 = string.sub(r2, 1, 2)
    l3 = string.sub(r3, 1, 3)
    scramble = math.random(3)

    if (scramble == 1) then
      scrambled = l1 .. l2 .. l3
      TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Secret Codes: " .. total .. ". Scrambled: " .. scrambled }})
      else if (scramble == 2) then
        scrambled = l2 .. l1 .. l3
        TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Secret Codes: " .. total .. ". Scrambled: " .. scrambled }})
        else if (scramble == 3) then
          scrambled = l3 .. l2 .. l1
          TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Secret Codes: " .. total .. ". Scrambled: " .. scrambled }})
        end -- end else if
      end -- end else if
    end -- end if

    -- [[NUI EVENT]]
    if (SetDisplay == true) then
      Citizen.CreateThread(function()
        while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
      end -- end while
    end) -- end thread
  end -- end if

  if flag == false then
    --very important cb
    RegisterNUICallback("exit", function(data)
      chat(data.close, {0, 255, 0})
      SetDisplay(false)
      flag = true
      return
    end) -- end NUI callback
  end -- end if

  if flag == false then
    RegisterNUICallback("main", function(data)
      local message = data.text .. "/" .. total -- show code and input
      chat(message, {0, 255, 0})
      SetDisplay(false)
      if string.match(data.text, total) then -- match code and input
        TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Vehicle: " .. " ^0Now Unlocked! ["..vehicleLockStatus.."]"}})
        SetVehicleDoorsLocked(frontVehicle, 1) -- unlock
        flag = true
      else
        TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Vehicle: " .. " ^0Still Locked! ["..vehicleLockStatus.."]"}})
        SetVehicleDoorsLocked(frontVehicle, 2) -- lock
        flag = true
      end -- end if
    end) -- end NUI callback
  end -- end if

  if flag == false then
    RegisterNUICallback("error", function(data)
      SetDisplay(false)
      flag = true
      return
    end) -- end NUI callback
  end -- end if
end -- end button press if



-- If player is in vehicle
if (IsControlJustPressed(0, 7) and currentVehicleLockStatus == 1) then -- unlocked
  TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Vehicle: " .. " ^0Locked ["..currentVehicleLockStatus.."]"}})
  SetVehicleDoorsLocked(currentVehicle, 2) -- lock
end
if (IsControlJustPressed(0, 7) and currentVehicleLockStatus == 2) then -- locked
  TriggerEvent('chat:addMessage', {color = { 0, 255, 0}, multiline = true, args = {"Vehicle: " .. " ^0Unlocked ["..currentVehicleLockStatus.."]"}})
  SetVehicleDoorsLocked(currentVehicle, 1) -- unlock
end



end -- end while true
end) -- end thread