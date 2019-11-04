local props = 0
while props == 0 do
  local drill = CreateObject(GetHashKey("prop_tool_bench02"), 1626.00, 2652.63, 45.56 - 1.0, true, true, false)
  local tablesaw_l = CreateObject(GetHashKey("prop_tool_bench02_ld"), 1629.50, 2648.76, 45.56 - 1.0, true, true, false)
  local locker = CreateObject(GetHashKey("p_cs_locker_01_s"), 1624.51, 2653.97, 45.56 - 1.0, true, true, false)
  local lumber = CreateObject(GetHashKey("prop_woodpile_01a"), 1624.27, 2646.67, 45.56 - 1.0, true, true, false)
  local lumber2 = CreateObject(GetHashKey("prop_woodpile_01a"), 1622.0, 2646.69, 45.56 - 1.0, true, true, false)
  SetEntityHeading(drill, 230.00)
  props = 1
end