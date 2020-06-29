local flag, showingNote = false
local notespot = {
  {x = 667.0, y = 562.71, z = 129.05, type = "weed", author = "J. Dough"},
  {x = 664.49, y = 564.69, z = 129.05, type = "cocaine", author = "Schno Flake"}
}
-- toggle display of ui
function SetDisplay(bool)
  display = bool
  showingNote = bool
  SetNuiFocus(bool, bool)
  SendNUIMessage({
    type = "ui",
    status = bool
  })
end
-- exit ui cb
RegisterNUICallback("exit", function(data)
  SetDisplay(false)
  flag = true
  return
end)
-- citizen thread
Citizen.CreateThread(function()
  while true do
  Wait(0)
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped)
  for _k, _v in pairs(notespot) do
    local npos = GetDistanceBetweenCoords(notespot[_k].x, notespot[_k].y, notespot[_k].z, pos.x, pos.y, pos.z, true)
    local dist = Vdist(pos.x, pos.y, pos.z, notespot[_k].x, notespot[_k].y, notespot[_k].z)
    exports.ui:marker(1, notespot[_k].x, notespot[_k].y, notespot[_k].z - 1.75, 255, 0, 0, 155) -- type, x, y, z, r, g, b, alpha -- change to DrawMarker()
    if (dist < 1.1) then
      exports.ui:drawText(notespot[_k].x, notespot[_k].y, notespot[_k].z, "Read note from ~g~" .. notespot[_k].author, 0.37) -- change to draw3DTextGlobal()
      if (IsControlJustPressed(1, 46)) then
        SetDisplay(true)
        SendNUIMessage({spotType = notespot[_k].type})
      end
    end
  end
  if (showingNote) then
    exports.ui:blockControls()
  end
end
end)