RegisterNetEvent("output")
AddEventHandler("output", function()
  TriggerEvent("chatMessage", "[Success]", {0, 255, 0}, "Added into the database")
end)