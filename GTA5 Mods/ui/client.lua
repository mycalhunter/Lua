function blockControls()
  DisableControlAction(0, 1, true) -- LookLeftRight
  DisableControlAction(0, 2, true) -- LookUpDown
  DisableControlAction(0, 24, true) -- Attack
  DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
  DisableControlAction(0, 142, true) -- MeleeAttackAlternate
  DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
end

function drawText(x, y, z, text, sc)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local px, py, pz = table.unpack(GetGameplayCamCoords())
  local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
  local scale = (1 / dist) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if (onScreen) then
    SetTextScale(0.0 * scale, sc or 0.55 * scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
  end
end

function chat(str, color)
  TriggerEvent('chat:addMessage', { color = color, multiline = true, args = {str} })
end

function marker(type, x, y, z, r, g, b, a)
  DrawMarker(
    type, -- type
    x, -- x coord
    y, -- y coord
    z, -- z coord
    0, -- dirX
    0, -- dirY
    0, -- dirZ
    0, -- rotX
    0, -- rotY
    0, -- rotZ
    1.0, -- scaleX
    1.0, -- scaleY
    1.0, -- scaleZ
    r, -- red
    g, -- green
    b, -- blue
    a, -- alpha
    0, -- bobUpAndDown
    0, -- faceCamera
    2, -- p19
    0, -- rotate
    0, -- textueDict
    0, -- textureName
    0 -- drawOnEnts
  )
end