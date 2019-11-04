-- EMOTE LIST
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
Citizen.CreateThread(function()
  local crossedarms_lib = "amb@world_human_hang_out_street@female_arms_crossed@base" -- crossed arms with base
  local palm_lib = "anim@mp_player_intupperface_palm" --face palm with idle_a
  local fob_lib = "anim@mp_player_intmenu@key_fob@" --face palm with fob_click
  local cpr_lib = "missheistfbi3b_ig8_2" --paramedic cpr with cpr_loop_paramedic
  RequestAnimDict(crossedarms_lib)
  RequestAnimDict(palm_lib)
  RequestAnimDict(fob_lib)
  RequestAnimDict(cpr_lib)
  while not HasAnimDictLoaded(crossedarms_lib, palm_lib, fob_lib, cpr_lib) do
    Citizen.Wait(100)
  end
  local handsup = false
  while true do
    Citizen.Wait(0)
    
    
    -- Face Palm Emote
    -- Starts face palm emote when "Y" is pressed, will remain in emote until Y is pressed again
    if IsControlJustPressed(1, Keys["Y"]) then --Start holding g
      if not handsup then
        TaskPlayAnim(GetPlayerPed(-1), palm_lib, "idle_a", 8.0, 8.0, - 1, 50, 0, false, false, false) --TASK_PLAY_ANIM(Ped ped, char* animDictionary, char* animationName, float speed, float speedMultiplier, int duration, int flag, float playbackRate, BOOL lockX, BOOL lockY, BOOL lockZ);
        handsup = true
      else
        handsup = false
        ClearPedTasks(GetPlayerPed(-1))
      end
    end
    
    
    -- Crossed Arms Emote
    -- Starts crossed arms emote when "SHIFT+G" is pressed, will remain in emote until SHIFT+G is pressed again
    if IsControlJustPressed(1, Keys["G"]) and IsControlPressed(1, Keys["LEFTSHIFT"]) then --Start holding g
      if not handsup then
        TaskPlayAnim(GetPlayerPed(-1), crossedarms_lib, "base", 8.0, 8.0, - 1, 50, 0, false, false, false)
        handsup = true
      else
        handsup = false
        ClearPedTasks(GetPlayerPed(-1))
      end
    end
    
    
    -- Fob Click Emote
    -- Starts key fob emote when "L" is pressed
    if IsControlJustPressed(1, Keys["L"]) then --Start holding g
      if not handsup then
        TaskPlayAnim(GetPlayerPed(-1), fob_lib, "fob_click", 8.0, 8.0, - 1, 50, 0, false, false, false) --TASK_PLAY_ANIM(Ped ped, char* animDictionary, char* animationName, float speed, float speedMultiplier, int duration, int flag, float playbackRate, BOOL lockX, BOOL lockY, BOOL lockZ);
        handsup = true
      else
        handsup = false
        ClearPedTasks(GetPlayerPed(-1))
      end
    end
    
    
    -- CPR Emote
    -- Starts CPR emote when "SHIFT+B" is pressed, duration is set to 11 seconds to show 10 chest compressions.
    if IsControlJustPressed(1, Keys["B"]) and IsControlPressed(1, Keys["LEFTSHIFT"]) then --Start holding g
      if not handsup then
        TaskPlayAnim(GetPlayerPed(-1), cpr_lib, "cpr_loop_paramedic", 1.0, - 1.0, 11000, 0, 1, true, true, true) --TASK_PLAY_ANIM(Ped ped, char* animDictionary, char* animationName, float speed, float speedMultiplier, int duration, int flag, float playbackRate, BOOL lockX, BOOL lockY, BOOL lockZ);
        handsup = true
      else
        handsup = false
        ClearPedTasks(GetPlayerPed(-1))
      end
    end
    
    
  end
end)