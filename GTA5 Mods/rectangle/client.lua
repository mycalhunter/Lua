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
-- citizen thread
Citizen.CreateThread(function()
  while true do
  Wait(0)
  SetDisplay(true)
end
end)