Citizen.CreateThread(function()
  while true do
    Wait(0)
    local pc = GetEntityCoords(PlayerPedId()) -- get ped coords
    local oid = GetClosestObjectOfType(pc, 2.0, 200846641, false) -- get nearest object of hash "200846641" within 2 meters = yellow fire hydrant
    local oidc = GetEntityCoords(oid) -- get coords of closest object
    local dist = Vdist(pc, oidc) -- get dist between ped coords and object coords, so it doesn't show all the time
    if (dist < 2.0) then -- if dist is less than 2.0 then show the text
      if DoesEntityExist(oid) then -- make sure the object exists in the world
        exports.ui:drawText(oidc.x, oidc.y, oidc.z + 1.15, "This is a ~y~Fire Hydrant~w~\nIt goes woosh with ~b~water", 0.25)
      end
    end
  end
end)