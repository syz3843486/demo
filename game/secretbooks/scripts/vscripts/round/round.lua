local Round = {}
GameRules.Round = Round
Round.Npc_AI_Data = require ("round/npc_ai_data_init")
require ("round/round_data")

function GetFirstHeroWeak()
	local player = PlayerInstanceFromIndex(1)
	return GetHeroWeak(player:GetAssignedHero())
end

function GetHeroWeak(hero)
	local WeakType = GameRules.WeakType
	local item_weak = GameRules.item_weak
	local ability_weak = GameRules.ability_weak

	local weak = {WeakType.run}
	for i=0,5 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability:GetCooldownTimeRemaining() <= 0 then
			local name = ability:GetAbilityName()
			local w = ability_weak[name]
			if w then
				table.insert(weak,w)
			end
		end
	end

	for i=0,5 do
		local item = hero:GetItemInSlot(i)
		if item and item:GetCooldownTimeRemaining() <= 0 then
			local name = item:GetAbilityName()
			local w = item_weak[name]
			if w then
				table.insert(weak,w)
			end
		end
	end

	return weak
end

function IsAIInWeak(id,weak)
	local line = MBTable['AI'][id]
	local aiWeak = line['weak']

	for _ , aiw in pairs(aiWeak) do
		for __ , w in pairs(weak) do
			if aiw == w then
				return true
			end
		end
	end
	return false
end

function Round.SendBtfToClient()
   local MB_AI = Round.Npc_AI_Data.MB_AI
   local btfData = {}
   for id , line in ipairs(MB_AI) do
   	  table.insert(btfData,line.btf)
   end

   CustomGameEventManager:Send_ServerToAllClients("BtfDataSync",btfData)
   print('------SendBtfToClient')
end


GameRules.Round = Round