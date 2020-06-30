Citizen.CreateThread(function()
  while true do
  Wait(0)

  local pedCoords = GetEntityCoords(PlayerPedId()) -- get ped coords
  local objectId = GetClosestObjectOfType(pedCoords, 2.0, 200846641, false) -- get nearest object of hash "200846641" = yellow fire hydrant
  local oc = GetEntityCoords(objectId) -- get coords of closest object
  local dist = Vdist(pedCoords, oc) -- get dist between ped coords and object coords, so it doesn't show all the time

  if (dist < 2.0) then -- if dist is less than 2.0 then show the text
    if DoesEntityExist(objectId) then -- make sure the object exists in the world
      exports.ui:drawText(oc.x, oc.y, oc.z + 1.15, "This is a ~y~Fire Hydrant~w~\nIt goes woosh with ~b~water", 0.25)
    end
  end
end
end)