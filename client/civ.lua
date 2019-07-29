local civonduty = false
local lockpicking = false
local handCuffed = false

RegisterNetEvent("ARPF:ToggleCivDuty")
AddEventHandler("ARPF:ToggleCivDuty", function(outfit)
  local duty = nil
  civonduty = not civonduty
  if civonduty then
    duty = "^2 onduty As a Civ"
    if (not outfit) then
      local model = GetHashKey("s_m_y_sheriff_01") -- ignore this 
      RequestModel(model)
      while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
      end
      local playerPed = GetPlayerPed(-1)
    end
  else
    duty = "^1 offduty"
  end
  TriggerEvent('chatMessage', "^1[SYSTEM]:^0 You are now"..duty.."^0.")
end) -- Modified from Lances ARPM script to be used for Civs

function VehicleInFront()
  local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 2.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, player, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
    return result
end --Taken from "elf_weaponfromcar"


RegisterNetEvent("ARPF:adminlockpicks")
AddEventHandler("ARPF:adminlockpicks", function()
  local vehicle = VehicleInFront()
  SetVehicleDoorsLocked(vehicle,1) -- admins have special command to unlock instantly for clean up of cars
end)


RegisterNetEvent("ARPF:lockpicks")
AddEventHandler("ARPF:lockpicks", function()
  if civonduty then -- Users need to do /civ then they are able to use this command if they are not onduty as a civ then a error notification will pop up
   local ped = GetPlayerPed(-1)
    local vehicle = VehicleInFront()
    if GetVehiclePedIsIn(ped, false) == 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
          exports['progressBars']:startUI(14000, "Lockpicking [stage 1]") -- Progress Bar can be changed if you dont have it
          SetVehicleDoorsShut(vehicle, true)
          RequestAnimDict("mini@repair")
          while not HasAnimDictLoaded("mini@repair") do
            Citizen.Wait(100)
          end
          TaskPlayAnim(GetPlayerPed(PlayerId()), "mini@repair", "fixing_a_player", 1.0, -1, -1, 50, 0, 0, 0, 0)
         Citizen.Wait(14000)
          StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
       Citizen.Wait(1000)
       TriggerEvent('ARPF:lockpicks2')
    return
   else
      exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to lockpick it')-- Notification System change to your liking if you dont have it
    end
  else
    exports['mythic_notify']:DoHudText('inform', 'You must be on duty as a civ to do this do /civ')-- Notification System change to your liking if you dont have it
  end
end)




RegisterNetEvent("ARPF:lockpicks2")
AddEventHandler("ARPF:lockpicks2", function()
  if civonduty then
   local ped = GetPlayerPed(-1)
    local vehicle = VehicleInFront()
    if GetVehiclePedIsIn(ped, false) == 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
          exports['progressBars']:startUI(14000, "Lockpicking [stage 2]") -- Progress Bar can be changed if you dont have it
          SetVehicleAlarm(vehicle, true) --starts car alarm 
          -- potentally add in call to police ;) coming soon!
          StartVehicleAlarm(vehicle)
          lockpicking = true
          RequestAnimDict("mini@repair")
          while not HasAnimDictLoaded("mini@repair") do
            Citizen.Wait(100)
          end
          TaskPlayAnim(GetPlayerPed(PlayerId()), "mini@repair", "fixing_a_player", 1.0, -1, -1, 50, 0, 0, 0, 0)
         Citizen.Wait(14000)
          StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
          SetVehicleAlarm(vehicle, true)
          StartVehicleAlarm(vehicle)          
       Citizen.Wait(1000)
       TriggerEvent('ARPF:lockpicks3')
    return
   else
      exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to lockpick it')-- Notification System change to your liking if you dont have it
    end
  else
    exports['mythic_notify']:DoHudText('inform', 'You must be on duty as a civ to do this do /civ')-- Notification System change to your liking if you dont have it
  end
end)



RegisterNetEvent("ARPF:lockpicks3")
AddEventHandler("ARPF:lockpicks3", function()
  if civonduty then
   local ped = GetPlayerPed(-1)
    local vehicle = VehicleInFront()
    if GetVehiclePedIsIn(ped, false) == 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
          exports['progressBars']:startUI(6000, "Lockpicking [stage 3]") -- Progress Bar can be changed if you dont have it
          SetVehicleAlarm(vehicle, true)
          StartVehicleAlarm(vehicle)
          RequestAnimDict("mini@repair")
          while not HasAnimDictLoaded("mini@repair") do
            Citizen.Wait(100)
          end
          TaskPlayAnim(GetPlayerPed(PlayerId()), "mini@repair", "fixing_a_player", 1.0, -1, -1, 50, 0, 0, 0, 0)
         Citizen.Wait(6000)
          SetVehicleAlarm(vehicle, true)
          StartVehicleAlarm(vehicle)
         ClearPedTasksImmediately(ped)
          StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
        SetVehicleDoorOpen(vehicle, 0, false, false)
        SetVehicleDoorsLocked(vehicle,1)

        exports['mythic_notify']:DoHudText('success', 'Vehicle Unlocked')-- Notification System change to your liking if you dont have it
        Citizen.Wait(2000)
       TriggerEvent('ARPF:stopa')
    return
   else
      exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to lockpick it') -- Notification System change to your liking if you dont have it
    end
  else
    exports['mythic_notify']:DoHudText('inform', 'You must be on duty as a civ to do this do /civ') -- Notification System change to your liking if you dont have it
  end
end)

RegisterNetEvent("ARPF:stopa")
AddEventHandler("ARPF:stopa", function()
  local vehicle = VehicleInFront()
  SetVehicleAlarm(vehicle, true)
  StartVehicleAlarm(vehicle)
  SetVehicleAlarm(vehicle, false)
  SetVehicleAlarm(vehicle, false)
  lockpicking = false
end)




RegisterNetEvent("ARPF:heal")
AddEventHandler("ARPF:heal", function()
  local prop = "prop_ld_health_pack"
  playerPed = GetPlayerPed(-1)
      local pedPos = GetEntityCoords(playerPed, false)
    exports['progressBars']:startUI(7000, "Healing") -- Progress Bar can be changed if you dont have it
    RequestAnimDict("misslsdhsclipboard@idle_a")
    while not HasAnimDictLoaded("misslsdhsclipboard@idle_a") do
      Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(PlayerId()), "misslsdhsclipboard@idle_a", "idle_a", 1.0, -1, -1, 50, 0, 0, 0, 0)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), 18905) -- 18905  28422
    local heals = CreateObject(GetHashKey(prop), 1.0, 1.0, 1.0, 1, 1, 0)
    shieldEntitys = heals
    --AttachEntityToEntity(shieldEntitys, playerPed, bone, 0.18, 0.0, 0.0, 135.0, -100.0, 0.0, 1, 0, 0, 0, 2, 1)
    AttachEntityToEntity(shieldEntitys, playerPed, bone, 0.15, 0.05, -0.01, 180.0, 220.0, 20.0, 1, 1, 0, 0, 2, 1)
    -- ["xR"] = 315.0,["yR"] = 288.0, ["zR"] = 0.0 
    Citizen.Wait(7000)
    DeleteEntity(shieldEntitys)
    health = GetEntityHealth(playerPed)
    chelth = health + 30
    SetEntityHealth(playerPed, chelth)
    StopAnimTask(PlayerPedId(), 'misslsdhsclipboard@idle_a', 'idle_a', 1.0)
    exports['mythic_notify']:DoHudText('success', 'You Healed Yourself') -- Notification System change to your liking if you dont have it
end)

RegisterNetEvent('ARPF:repair')
AddEventHandler('ARPF:repair', function()
  if civonduty or onduty then
   local ped = GetPlayerPed(-1)
    local vehicle = VehicleInFront()
    if GetVehiclePedIsIn(ped, false) == 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
      SetVehicleDoorOpen(vehicle, 4, 1, 1)
          exports['progressBars']:startUI(14000, "Repairing")
          TriggerEvent('ARPF:animationrepair',source)
        Citizen.Wait(14000)
        SetVehicleFixed(vehicle)
        healthBodyLast=1000.0
        healthEngineLast=1000.0
        healthPetrolTankLast=1000.0
        SetVehicleEngineOn(vehicle, true, true, true)
        exports['mythic_notify']:DoHudText('success', 'You repaired the car!')
      return
   else
      exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to repair it')
    end
  else
    exports['mythic_notify']:DoHudText('inform', 'You must be on duty as a civ to do this do /civ')
  end
end)

RegisterNetEvent('ARPF:animationrepair')
AddEventHandler('ARPF:animationrepair', function()

inanimation = true

    ClearPedTasksImmediately(IPed)
    if not handCuffed then

      local lPed = GetPlayerPed(-1)

      RequestAnimDict("mini@repair")
      while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
      end
      
      if IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
        ClearPedSecondaryTask(lPed)
        TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
      else
        ClearPedTasksImmediately(IPed)
        TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        seconds = 27
        while seconds > 0 do
          Citizen.Wait(1000)
          seconds = seconds - 1
        end
        ClearPedSecondaryTask(lPed)
      end   
    else
      ClearPedSecondaryTask(lPed)
    end
inanimation = false
end) 


--amb@world_human_maid_clean@base
RegisterNetEvent('ARPF:clean')
AddEventHandler('ARPF:clean', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = VehicleInFront()
    if civonduty then
      if GetVehiclePedIsIn(playerPed, false) == 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        exports['progressBars']:startUI(10000, "Cleaning Car")
        RequestAnimDict("amb@world_human_maid_clean")
          while not HasAnimDictLoaded("amb@world_human_maid_clean") do
            Citizen.Wait(100)
          end
          TaskPlayAnim(GetPlayerPed(PlayerId()), "amb@world_human_maid_clean", "base", 1.0, -1, -1, 50, 0, 0, 0, 0)
         Citizen.Wait(10000)
         ClearPedTasksImmediately(ped)
          StopAnimTask(PlayerPedId(), 'amb@world_human_maid_clean', 'base', 1.0)
        SetVehicleDirtLevel(vehicle, 0)
        exports['mythic_notify']:DoHudText('success', 'Your vehicle has been cleaned!')
      else
        exports['mythic_notify']:DoHudText('inform', 'You must be near a vehicle to be able to clean it')
      end
    else
      exports['mythic_notify']:DoHudText('inform', 'You must be use /civ to use thic command')
  end
end)


local isIntrunk = false

RegisterCommand('trunkgetin', function(source, args, rawCommand)
 local pos = GetEntityCoords(GetPlayerPed(-1), false)
 local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)
 if DoesEntityExist(vehicle) and GetVehicleDoorLockStatus(vehicle) == 1 and not kidnapped then
  if not isIntrunk then
   AttachEntityToEntity(GetPlayerPed(-1), vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
   RaiseConvertibleRoof(vehicle, false)
   if IsEntityAttached(GetPlayerPed(-1)) then
    RequestAnimDict('timetable@floyd@cryingonbed@base')
    while not HasAnimDictLoaded('timetable@floyd@cryingonbed@base') do
     Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'timetable@floyd@cryingonbed@base', 'base', 1.0, -1, -1, 1, 0, 0, 0, 0)
   end
  end
  isIntrunk = true
 end
end)

RegisterCommand('trunkgetout', function(source, args, rawCommand)
 local pos = GetEntityCoords(GetPlayerPed(-1), false)
 local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)
 if DoesEntityExist(vehicle) and GetVehicleDoorLockStatus(vehicle) == 1 and not kidnapped then
  if isIntrunk then
   DetachEntity(GetPlayerPed(-1), 0, true)
   SetEntityVisible(GetPlayerPed(-1), true)
   ClearPedTasksImmediately(GetPlayerPed(-1))
  end
  isInTrunk = false
 end
end)
