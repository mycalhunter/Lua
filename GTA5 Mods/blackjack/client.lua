local flag, showingNote = false
local blackjack_table = {
  {x = 669.73, y = 560.99, z = 129.05, type = "Blackjack"}
}
-- toggle display of ui
function SetDisplay(bool)
  display = bool
  SetNuiFocus(bool, bool)
  SendNUIMessage({
    type = "ui",
    status = bool
  })
end
-- exit ui cb
RegisterNUICallback("exit", function(data)
  SetDisplay(false)
  showingNote = false
  flag = true
  return
end)
-- citizen thread
Citizen.CreateThread(function()
  while true do
  Wait(0)
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped)
  for _k, _v in pairs(blackjack_table) do
    local npos = GetDistanceBetweenCoords(blackjack_table[_k].x, blackjack_table[_k].y, blackjack_table[_k].z, pos.x, pos.y, pos.z, true)
    local dist = Vdist(pos.x, pos.y, pos.z, blackjack_table[_k].x, blackjack_table[_k].y, blackjack_table[_k].z)
    exports.ui:marker(1, blackjack_table[_k].x, blackjack_table[_k].y, blackjack_table[_k].z - 1.75, 255, 0, 0, 155) -- type, x, y, z, r, g, b, alpha -- change to DrawMarker()
    if (dist < 1.1) then
      exports.ui:drawText(blackjack_table[_k].x, blackjack_table[_k].y, blackjack_table[_k].z, "Play at ~g~" .. blackjack_table[_k].type .. "~w~ table", 0.37) -- change to draw3DTextGlobal()
      if (IsControlJustPressed(1, 46)) then
        SetDisplay(true)
        showingNote = true
        SendNUIMessage({spotType = blackjack_table[_k].type})
      end
    end
  end
  if (showingNote) then
    exports.ui:blockControls()
  end
end
end)