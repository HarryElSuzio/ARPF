print('ARPF by Xerxes468893 (Peter Greek) for BCDOJRP.') -- Do not Remove Pls!
RegisterCommand("civ", function(source, args, raw)
	local player = source 

	if (player > 0) then
		--local civonduty = true
		TriggerClientEvent("ARPF:ToggleCivDuty", source)
		--exports.ghmattibanking:signIn(player, GetPlayerName(player)) -- Future update
		CancelEvent()
	end
end, false)
--local ems = 'ARPM.ems'
RegisterCommand("ems", function(source, args, raw)
 local player = source
  --if IsPlayerAceAllowed(source, ems) then
	if (player > 0) then
	  TriggerClientEvent("ARPM:emsduty", player)
	   CancelEvent()
	--end
end
end, false)

RegisterCommand("healself", function(source, args, raw)
	local player = source 
	if (player > 0) then
		TriggerClientEvent("ARPF:heal", source)
		CancelEvent()
	end
end, false)

RegisterCommand("civrepair", function(source, args, raw)
	local player = source 
	if (player > 0) then
		TriggerClientEvent('ARPF:repair', source)
		CancelEvent()
	end
end, false)

RegisterCommand("adminunlock", function(source, args, raw)
	local player = source 
	if (player > 0) then
		TriggerClientEvent('ARPF:adminlockpicks', source)
		CancelEvent()
	end
end, true)


RegisterCommand("lockpick", function(source, args, raw)
	local player = source 
	if (player > 0) then
		TriggerClientEvent('ARPF:lockpicks', source)
		CancelEvent()
	end
end, false)

RegisterCommand("cleancar", function(source, args, raw)
	local player = source 
	if (player > 0) then
		TriggerClientEvent('ARPF:clean', source)
		CancelEvent()
	end
end, false)
