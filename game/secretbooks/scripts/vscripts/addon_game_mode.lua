-------------------------------------------------------------------------------------------------------------
-- 类似于python中的文件载入机制
-- 使用一个文件夹中的_loader载入文件夹中的所有需要载入的文件
-- 这个函数当然会同时运行_loader中的所有语句
-- path表示文件夹
-------------------------------------------------------------------------------------------------------------
function xrequire(path)
	local files = require(path .. '._loader')
	if not files then
		error('xrequire Failed to load' .. path)
	end

	if files and type(files) == 'table' then
		for _, file in pairs(files) do
			require(path .. '.' .. file)
		end
	elseif files and not type(files) == 'table' then
		print(path, 'doesnt return a table contains files to require, ignoring!!!!')
	end
end

xrequire 'modifiers'
-- Generated from template
require("playfab")
require("playfabEx")
require("mb/lua/_MBLoader")

require("common/common")
require("round/gold_bag")
require("round/round")
require 'common/timers'
require("gm")
bDebug = true
local function dp( ... )
	if bDebug then
		print(string.format(...))
	end
end
if CPracticeWorld == nil then
	CPracticeWorld = class({})
	_G.CPracticeWorld = CPracticeWorld
end

Precache = require "Precache" -- 预载入在这里！！！

require 'behavior/BehaviorTreeMgr'

g_BehaviorTreeMgr:LoadAllBtf()


-- Create the game mode when we activate
function Activate()
	GameRules.practiceWorld = CPracticeWorld()
	GameRules.practiceWorld:InitGameMode()
end

function GameRules:RegisterUIEventListeners()
    CustomGameEventManager:RegisterListener("gm",function(_,netData)DeepPrintTable(netData)
     GameRules.gm.parse(netData.text) 
    end)

    CustomGameEventManager:RegisterListener("start_book",function(_,netData)
    	DeepPrintTable(netData)
    	GameRules.Round.EnterRound(tonumber(netData.id),0)
    end)
end

function CPracticeWorld:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetPreGameTime(3.0)                                                --设置游戏开始时间为3秒（这个放在前面）
	GameRules:SetCustomGameSetupAutoLaunchDelay(1.0)
	GameRules:SetHeroSelectionTime(1.0)
	print( "CEventGameMode:InitGameMode is loaded." )
	--ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(CPracticeWorld,"OnPlayerPickHero"), self)
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CPracticeWorld,"OnGameRulesStateChange"), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(CPracticeWorld,"Player_Chat"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CPracticeWorld,"Entity_Killed"), self)
    local gamemode = GameRules:GetGameModeEntity()
    gamemode:SetModifierGainedFilter(Dynamic_Wrap(CPracticeWorld, 'ModifierFilter'), self)
    gamemode:SetDamageFilter(Dynamic_Wrap(CPracticeWorld, 'DamageFilter'), self)
    print('-=========123123123')
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(CPracticeWorld, "OnNPCSpawned"), self)
    GameRules:RegisterUIEventListeners()
    GameRules.Round.SendBtfToClient()
	gamemode:SetCameraDistanceOverride(1600)
	gamemode:SetStashPurchasingDisabled(true)
	gamemode:SetRemoveIllusionsOnDeath(true)
    math.randomseed(GameRules:GetTimeOfDay())

    GameRules.BookScores = {}
end

function CPracticeWorld:OnPlayerPickHero(keys)
	local player = EntIndexToHScript(keys.player)
    local hero = player:GetAssignedHero()
    RemoveWearables(hero)
end

local fish_unit = nil
function CPracticeWorld:Player_Chat(event)
	dp('event.text %s,event.userid %s ',event.text,event.userid)
	GameRules.gm.parse(event.text)
end

function Ability_Channel_Finished(event)
	local casterUnit = EntIndexToHScript( event.caster_entindex )
	if casterUnit then
		if casterUnit.AI and casterUnit.AI.Ability_Channel_Finished then
			casterUnit.AI.Ability_Channel_Finished( event.abilityname )
		end
	end
end

function CPracticeWorld:OnNPCSpawned(keys)
	local entindex = keys.entindex
	local unit = EntIndexToHScript( entindex )
	if unit.isplayer then
		Timers:CreateTimer(1,function() unit:SetMana(0) end)
	end

	if unit:IsIllusion() or not unit.isnpc and not unit:IsHero() then
		Timers:CreateTimer(2,function() 
			if not unit:IsNull() then
				unit:ForceKill(true)
			end
		end)		
	end
end


function CPracticeWorld:OnGameRulesStateChange( keys )
    --GameRules:SetPreGameTime( 10.0)  --设置等待游戏开始时间为10秒

    --获取游戏进度
    local newState = GameRules:State_Get()

    if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        print("Player begin select hero")  --玩家处于选择英雄界面
    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        print("Player ready game begin")  --玩家处于游戏准备状态
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        print("Player game begin")  --玩家开始游戏
    end
end
local damageNpcList = {}
---------------------------------------------------------------------------------
-- buff过滤器
---------------------------------------------------------------------------------
function CPracticeWorld:ModifierFilter(filterTable)
    --DeepPrintTable(filterTable)
	-- local caster = EntIndexToHScript(filterTable.entindex_caster_const)
	-- local target = EntIndexToHScript(filterTable.entindex_parent_const)
    
 --    if caster.isnpc and target.isplayer then
 --    	if damageNpcList[caster] == nil then
 --    		ClearCombo(GetPlayerHero())
	--     	local dechp =target:GetMaxHealth()/3
	--     	local curhp = target:GetHealth() - dechp
	--     	if curhp < 0 then
	--     		target:ForceKill(false)
	--     	else
	--     		target:SetHealth(curhp) 
	--     	end
 --    		damageNpcList[caster] = true
 --    	end
 --    end
    return true
end

function CPracticeWorld:DamageFilter(damageTable)
	--print('--------1111')
	if damageTable.entindex_attacker_const == nil then
		return false
	end

	local attacker = EntIndexToHScript(damageTable.entindex_attacker_const)
    local victim = EntIndexToHScript(damageTable.entindex_victim_const)
    local hp = victim:GetHealth()
	hp = hp - damageTable.damage
	if victim.isnpc then
		damageTable.damage = 1
	end
	if attacker.isplayer and victim.isnpc then
		attacker:EmitSound("jug_new_attack")
		attacker.lastcombotime = GameRules:GetGameTime()
		AddCombo(attacker)
		AddScore(attacker,1,victim)

	elseif victim.isplayer and attacker.isnpc and damageTable.damage > 1 then
		attacker.lastcombotime = 0
		AddScore(victim,ClearCombo(victim,0)) 
		victim:SetMana(0)
		if damageNpcList[attacker] == nil then
			local dechp =victim:GetMaxHealth()/3
	    	local curhp = victim:GetHealth() - dechp
	    	if curhp < 0 then
	    		victim:ForceKill(false)
	    		GameRules:HeroFail(victim)
	    	else
	    		victim:SetHealth(curhp) 
	    	end
	    	damageNpcList[attacker] = true
			victim:RemoveModifierByName("modifier_add_atksp")
  			victim:RemoveModifierByName('modifier_max_atksp')
	    else
	    	return false
		end
	end
	return true
end


function CPracticeWorld:Entity_Killed(keys)
    --DeepPrintTable(keys)
    local unit = EntIndexToHScript(keys.entindex_killed)
    if unit.isnpc then
    	AddScore(GetPlayerHero(),unit.score)
		GameRules.RepeatCreateGoldBag(3,1000,"addscore",10)
    elseif unit.isplayer then
    	unit.round_data.id = 1
    	GameRules.Round.ExitRound()
    	GameRules:UpdateRoundScore(unit)
    	ClearScore(unit)
    	Timers:CreateTimer(5,function() 
    		print('RespawnUnit!')
    		unit:RespawnUnit() 
    		end)
    	dp('-----------------player killed!!')
    end
    return true
end


function GameRules:InitGameData()
	Login(1)
	CustomGameEventManager:Send_ServerToAllClients( "init_books_event", MBTable['round_list'] )
end

local first = true

-- Evaluate the state of the game
function CPracticeWorld:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if first and GetPlayerHero() then
			InitPlayerHeroData(1)
			GameRules:InitGameData()
			InitPlayerItemSKill(1)

			first = false
    	end
    	TickCombo(GetPlayerHero())
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end