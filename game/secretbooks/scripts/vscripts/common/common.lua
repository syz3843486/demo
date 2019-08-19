require 'behavior/AIHelper'
require 'common/popu'
bDebug = true
local function dp( ... )
	if bDebug then
		print(string.format(...))
	end
end
function GetPlayerVector()
	local player = PlayerInstanceFromIndex(1)
	return player:GetAssignedHero():GetAbsOrigin()
end

function GetRandCircleVec(vec,r)
	local angle = math.random(0,360) 
	local rad = math.rad(angle)
	local x = math.cos(rad)*r
	local y = math.sin(rad)*r
	dp('x %s y %s r %s',x,y,r)
	return vec + Vector(x,y,0)
end

function Ablility_Update_Full(thisEntity)
	thisEntity:SetAbilityPoints(25)
	for i=1,25 do
		thisEntity:HeroLevelUp(false)
	end

	for i=0,5 do
		local ability = thisEntity:GetAbilityByIndex(i)
		for j=1,4 do
			thisEntity:UpgradeAbility(ability)
		end
	end
end

function GetBestCastAbilityPoint(ability,from,target,cut_dis)
	local range = ability:GetCastRange()
	local diff = target-from
	local diff_len = #diff
	if diff_len < range then
		return target
	end
	dp('---new')
	return diff:Normalized()*(diff_len-range) + from
end

function CastAbilityToBestPos(entity,ability,target,cut_dis)
	if target == nil then
		target = GetPlayerVector()
	end

	local pos = GetBestCastAbilityPoint(ability,entity:GetAbsOrigin() ,target,cut_dis)
	entity:CastAbilityOnPosition(pos,ability,0) 
end

function CastAbilityToPlayer(entity,ability)
	entity:CastAbilityOnTarget(GetPlayerHero(),ability, 1)
end

function GetPlayerHero()
	local player = PlayerInstanceFromIndex(1)
	return player:GetAssignedHero()
end

function CreateAINpc(btf,name,pos)
	if pos == nil then
		pos = Vector(10000,10000,10000)
	end
	local unit = CreateUnitByName(name,pos,true,nil,nil,DOTA_TEAM_NEUTRALS)
	print('InitEntityAI')
	AIHelper.InitEntityAI(unit,btf)
	unit.score = 1
	unit.round = 1
	unit.isnpc = true
	return unit
end
_G.DOTA_MAX_ABILITIES = 16
_G.HERO_MAX_LEVEL = 25
function CreateAINpcByID(id,pos)
	if pos == nil then
		pos = Vector(10000,10000,10000)
	end

	local MB_AI_Line = MBTable['AI'][id]
	if MB_AI_Line == nil then
		return 
	end

	local unit = CreateUnitByName(MB_AI_Line['npc_name'],pos,true,nil,nil,DOTA_TEAM_NEUTRALS)
	dp('InitEntityAI %s',MB_AI_Line['npc_name'])
	AIHelper.InitEntityAI(unit,MB_AI_Line['btf'])
	unit.score = 1
	unit.round = 1
	unit.isnpc = true

	unit:AddExperience( 32400, false , false)
	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local hAbility = unit:GetAbilityByIndex( i )
		if hAbility and hAbility:CanAbilityBeUpgraded () == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
			while hAbility:GetLevel() < hAbility:GetMaxLevel() do
				unit:UpgradeAbility( hAbility )
			end
		end
	end

	unit:SetAbilityPoints( 4 )

	return unit
end

function CreateTestNpc(_npc_data,pos)
	if pos == nil then
		pos = Vector(10000,10000,10000)
	end
	local unit = CreateUnitByName(_npc_data.name,pos,true,nil,nil,DOTA_TEAM_NEUTRALS)
	if _npc_data.btf then
		print('InitEntityAI')
		AIHelper.InitEntityAI(unit,_npc_data.btf)
		unit.score = 1
		unit.round = 1
		unit.isnpc = true
	end
	return unit
end

function CheckEntityModifier(entity,modName)
	local cnt = entity:GetModifierCount()
	for i=0,cnt-1 do
		local mod = entity:GetModifierNameByIndex(i)
		if mod == modName then
			return true
		end
	end
	return false
end

function RefreshAbilitys(hero)
	for i=1,6 do
		ability = hero:GetAbilityByIndex(i)
		if ability then
			ability:EndCooldown()
		end
	end

	for i=1,6 do
		ability = hero:GetItemInSlot(i)
		if ability then
			ability:EndCooldown()
		end
	end

	ParticleManager:CreateParticle("particles/items2_fx/refresher_b.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	print('refresh!!')
end

function HasDebuff(entity)
	local cnt = entity:GetModifierCount()
	for i=0,cnt-1 do
		local modName = entity:GetModifierNameByIndex(i)
	 	local mod = entity:FindModifierByName(modName)
		DeepPrintTable(mod)
	end
	return false
end

function AddSpeechBubble(entityIdx,text,duration)
	local event_data = {
		unit = entityIdx,
		text = text,
		duration = duration,
	}
	CustomGameEventManager:Send_ServerToAllClients( "avalon_display_bubble", event_data )
end

function SendEvadeRst(rst)
	local event_data = {
		rst = rst,
	}
	CustomGameEventManager:Send_ServerToAllClients( "evade_rst", event_data )
end

function Defualt_AddItem(thisEntity)
	thisEntity:AddItemByName("item_blink")
	thisEntity:AddItemByName("item_force_staff")
	thisEntity:AddItemByName("item_invis_sword")
	thisEntity:AddItemByName("item_travel_boots")
	
end

string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

function SplitStrToNumArr(str)
    local arr = string.split(str,'*')
	for k , v in ipairs(arr) do
		arr[k] = tonumber(v)
	end

	return arr
end

function SynScoreData(hero)
	CustomGameEventManager:Send_ServerToAllClients( "SynScore", { id= hero:GetEntityIndex() , score_data = hero.score_data} )
end

function SynComboData(hero)
	CustomGameEventManager:Send_ServerToAllClients( "SynCombo", { id= hero:GetEntityIndex() , combo_data = hero.combo_data} )
end
function SynRoundData(hero)
	CustomGameEventManager:Send_ServerToAllClients( "SynRound", { id= hero:GetEntityIndex() , round_data = hero.round_data} )
end

function RemoveWearables(hero)
	local model_name = hero:GetModelName()
	print("model_name" ,model_name)
    if string.find(model_name,"jugg") then
        local wearables = {}
        -- 获取英雄的第一个子模型
        local childs = hero:GetChildren()
        -- 循环所有模型
        for k,model in pairs(childs)  do
        	if model ~= nil and model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
                 print("name ",model:GetModelName() )
                 table.insert(wearables, model)
             end
        end

        -- while model ~= nil do
        --     -- 确保获取到的是 dota_item_wearable 的模型
        --     if model ~= nil and model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
        --         table.insert(wearables, model)
        --     end
        --     -- 获取下一个模型
        --     model = model:NextMovePeer()
        -- end
        -- 循环所有的模型，并移除
        for i = 1, #wearables do
            print("removed 1 wearable", wearables[i])
            UTIL_Remove(wearables[i])
            --wearables[i]:RemoveSelf()
            --wearables[i]:SetModel("models/items/juggernaut/arcana/juggernaut_arcana_front_page.vmdl")
            --wearables[i]:SetRenderColor(255,0,0)
        end
        if #wearables >= 1 then
            print("MODEL REMOVED, RESPAWNING HERO")
            -- hero:SetRespawnPosition(hero:GetOrigin())
            hero:RespawnHero(false,false)
        end
    end
end

function InitJuggWearAble(hero)
	RemoveWearables(hero)
    --hero:SetContextThink(DoUniqueString("remove"), function() RemoveWearables(hero) return 1 end ,1)
end

function InitPlayerItemSKill(idx)
	local player = PlayerInstanceFromIndex(idx)
	local hero = player:GetAssignedHero()
	hero:AddItemByName("item_blink")
	hero:AddItemByName("item_abyssal_blade")
	hero:AddItemByName("item_manta")
	--hero:AddItemByName("item_mjollnir")
	hero:AddItemByName("item_phase_boots")
	local hero = GetPlayerHero()
	hero.isplayer = true
	for i=1 , 25 do
		hero:HeroLevelUp(true)
	end

	for i=0,5 do
		local ability = hero:GetAbilityByIndex(i)
		ability:SetLevel(4)
	end
end

function InitPlayerHeroData(idx)
	local player = PlayerInstanceFromIndex(idx)
	local hero = player:GetAssignedHero()
	hero.isplayer = true

	hero.round_data = {
		id = 0,
		sub_id = 0,
	}

	hero.score_data ={
		score = 0,
	}
	hero.combo_data = {
		lasttime = 0,
		combo = 0,
	}

	hero:SetDayTimeVisionRange(5000)
	hero:SetNightTimeVisionRange(4000)
	CustomGameEventManager:Send_ServerToAllClients( "PlayerInit", { unit= hero:GetEntityIndex()} )
	SynScoreData(hero)
	SynComboData(hero)
	SynRoundData(hero)	
	hero:SetMana(0)
end

local Score_Componet = {}

function AddScore(hero,_add,popuTarget)
	if _add == 0 then
		return
	end
	
	if not hero:IsAlive() then
		return
	end

	local score = hero.score_data.score 
	hero.score_data.score = score + _add
	local data = {
		score = hero.score_data.score,
		add = _add,
	}
	if popuTarget then
		PopupGoldGain(popuTarget,_add)
	end
	dp('PopupGoldGain %s',_add)
	CustomGameEventManager:Send_ServerToAllClients( "SynScore", { id= hero:GetEntityIndex() , score_data = data} )
end

function ClearScore(hero)
	hero.score_data.score = 0
	local data = {
		score = 0,
		add = 0,
	}
	CustomGameEventManager:Send_ServerToAllClients( "SynScore", { id= hero:GetEntityIndex() , score_data = data} )
end


local function CalComboScore(_combo)
	if _combo <= 8 then
		return math.floor(_combo/4)
	elseif _combo > 8 then
		return math.floor(_combo/3)
	end
end

function AddCombo(hero)
	local combo_data = hero.combo_data
	combo_data.lasttime = GameRules:GetGameTime() 
	combo_data.combo = combo_data.combo + 1
	SynComboData(hero)
end

function ClearCombo(hero)
	local combo_data = hero.combo_data
	combo_data.lasttime = 0
	local combo = combo_data.combo
	if combo == 0 then
		return 0
	end

	local score = CalComboScore(combo)
	combo_data.combo = 0
	SynComboData(hero)
	return score
end

local combo_interval = 6
function TickCombo(hero)
	if hero == nil then return end

	local combo_data = hero.combo_data
	if combo_data == nil then return end
	local lasttime = combo_data.lasttime
	if lasttime == 0 or GameRules:GetGameTime() -lasttime> combo_interval then
		AddScore(hero,ClearCombo(hero))
	end
end

function GameRules:GetRoundScore(playerIdx)
	local round_list = MBTable['round_list']
	local books = {}
	for id , line in pairs(round_list) do
		table.insert(books,id)
	end
	GetBookScoreData(playerIdx,books)
end


function GameRules:UpdateRoundScore(hero)
	local round_list_id = GameRules.Round.roundTask.round_list_id
	local score = hero.score_data.score
	local pre_score = GameRules.BookScores[round_list_id]
	
	if pre_score == nil or pre_score < score then
		SetBookScoreData(1,round_list_id,score)
	end
	if pre_score == nil then
		pre_score = 0
	end
	CustomGameEventManager:Send_ServerToAllClients( "update_round_score", {id=round_list_id,score = score , pre_score = pre_score})
end

function GameRules:SycnBookScoreFromPlayFab(playerIdx,playfab_data)
	local lua_data = {}
	for id , score in pairs(playfab_data) do
		id = tonumber(id)
		if id then
			lua_data[id] = tonumber(score) 
		end
	end

	GameRules:SycnBookScore(playerIdx,lua_data)
end
function GameRules:SycnBookScore(playerIdx,data)
	local player = PlayerInstanceFromIndex(playerIdx)
	local hero = player:GetAssignedHero()
	for id , score in pairs(data) do
		local pre_score = GameRules.BookScores[id]
		if pre_score ~= nil and pre_score < score then
			GameRules:PlayWinSound(hero)
		end
		print('GameRules.BookScores[',id,'] type',type(id))
   		GameRules.BookScores[id] = score
	end
    CustomGameEventManager:Send_ServerToAllClients( "book_score_data", data)
end

dp('-reload')