--require "mb/lua/parse/mb2lua"
require "playfabEx"
local gm = {}

gm.parse = function(str,event)
	-- if not IsInToolsMode() then
	-- 	return
	-- end
	if string.find(str,'-') == 1 then
		print('str ',str)
		str = string.sub(str,2,-1)
	end

	if str == nil then
		return
	end
	print('str[1]',str)

	local args = string.split(str,' ')
	if #args == 0 then
		return
	end

	local funcName = args[1]
	local funcArgs = {}
	for i=2 , #args do
		table.insert(funcArgs,args[i])
	end
	print('gm parse ',funcName)
	
	if gm[funcName] then
		gm[funcName](funcArgs,event)
	end
end

gm.rs = function(args)
	--GameRules:MB2Lua()
	SendToConsole("script_reload")
end

gm.t = function (args)
	local btf = args[1]
	local Btf_AI_List = GameRules.Round.Npc_AI_Data.Btf_AI_List
	
	local ai_list = Btf_AI_List[btf]
	if ai_list then
		local unit = CreateAINpc(btf,ai_list.npc_name)
		unit:SetLevel(iLevel)
		Defualt_AddItem(unit)
	end
end

gm.ai = function( args)
	local unit = CreateAINpcByID(tonumber(args[1]))
	Defualt_AddItem(unit)
end

gm.p = function (args)
	local hero = GetPlayerHero()
	hero.isplayer = true
	for i=1 , 25 do
		hero:HeroLevelUp(true)
	end

	hero:AddItemByName("item_blink")
	hero:AddItemByName("item_abyssal_blade")
	hero:AddItemByName("item_manta")
	hero:AddItemByName("item_mjollnir")
	hero:AddItemByName("item_phase_boots")
end

gm.x = function (args)
	local hero = GetPlayerHero()
	hero:RespawnUnit()
end

gm.send_btf = function (args)
	GameRules.Round.SendBtfToClient();
end

gm.register = function(args)
	GameRules:RegisterUIEventListeners()
end

gm.wear = function(args)
	local items = LoadKeyValues("scripts/npc/items_game.txt")
	items = items.items

	local heros = {}
	
	for key , v in pairs(items) do
		if type(v.used_by_heroes) == 'table' and v.item_slot ~= nil then
			
			for heroName , _ in pairs(v.used_by_heroes) do
				if heros[heroName] == nil then
					heros[heroName] = {slot = {} ,}
				end

				local slot = heros[heroName].slot
				slot[v.item_slot] = key
			end
		end
	end
	print('------!!')
	local logFile =io.open('D:\\Game_Install\\SteamBox\\Steam\\steamapps\\common\\dota 2 beta\\game\\dota_addons\\test1\\scripts\\vscriptslog.txt','w+')
	if logFile then
		for heroName , v in pairs(heros) do
			logFile:write('--->\n'..heroName .. '\n"AttachWearables"\n\t\t{\n')
			local idx = 1
			for _ , itemDef in pairs(v.slot)  do
				logFile:write(string.format('\t\t\t"Wearable%s" {"ItemDef" "%s"}\n',idx,itemDef))
				idx = idx + 1
				if idx > 6 then
					break
				end
			end
			logFile:write("\t\t}\n")
		end

		logFile:close()
	end

end

gm.net = function()
	local req = CreateHTTPRequestScriptVM("POST", "http://39.96.55.180:8080/")
	 req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
	 local reqTable = {
        a=1,
       }
  print("json.encode(reqTable) ",json.encode(reqTable))
  req:SetHTTPRequestRawPostBody("application/json",json.encode(reqTable))
  req:Send(function(res) print(res.Body) end)
end

gm.round = function(args)
	GameRules.Round.EnterRound(tonumber(args[1]))
end

gm.c = function (args)
	local unit = CreateUnitByName("npc_dota_hero_earthshaker",GetPlayerVector(),true,nil,nil,DOTA_TEAM_NEUTRALS)
end

gm.wudi = function(args)
	Entities:FindByName(nil,"npc_dota_hero_earthshaker"):AddNewModifier(nil,nil,"wudi",nil)
end

gm.item = function(args)
	local unit = GetPlayerHero()
	local item = CreateItem("item_bag_of_gold",unit,unit)
	
	local pos = unit:GetAbsOrigin()
	local physicalItem = CreateItemOnPositionSync(pos,item)
	pos = unit:GetAbsOrigin() + RandomVector(600)
	local droptime = 0.75
	item:LaunchLoot(false, 200, droptime, pos)
	--print(pos , unit:GetAbsOrigin())
	
	local dt = 0.1
	physicalItem.curtime = 0
	physicalItem:SetContextThink("pick",function()
		physicalItem.curtime = physicalItem.curtime + dt
		print('item.curtime ',physicalItem.curtime,physicalItem:GetAbsOrigin(),GetPlayerVector())
		if physicalItem.curtime < droptime +0.1 then
			return dt
		end

		local v = GetPlayerVector()
		local dis = (v - pos):Length2D()
		print ('dis ',dis)
		if dis < 200 then
			physicalItem:Kill()
			return 0;
		end
		return dt
	end,dt)
end

gm.wear = function(args)
	local hero = GetPlayerHero()
	print('hero ',hero)
	InitJuggWearAble(hero)
end

local tempHero = nil
gm.add = function(args)
	local pos = GetPlayerVector()
	tempHero = CreateUnitByName("npc_dota_hero_juggernaut",pos,true,nil,nil,DOTA_TEAM_NEUTRALS)
end

gm.del = function(args)
	tempHero:Destroy()
end

local fileWrite = {}

function fileWrite:write(...)
	self.file:write(string.format(...))
end

function fileWrite:close()
	self.file:close()
end

gm.kvheroes = function(args)
	local heroes = LoadKeyValues("scripts/npc/npc_heroes.txt")
	local file =io.open('D:\\Game_Install\\SteamBox\\Steam\\steamapps\\common\\dota 2 beta\\game\\dota_addons\\secretbooks\\scripts\\npc\\npc_heroes_custom1.txt','w+')
	fileWrite.file = file
	local begin_str = '"DOTAHeroes"\n{\n"Version"		"1"\n'
	fileWrite:write(begin_str)
	for heroName , heroData in pairs(heroes) do
		print(heroName,heroData)
		fileWrite:write('\t"%s"\n\t{\n',heroName)
		fileWrite:write('\t\t"override_hero" "%s"\n',heroName)
		
		if type(heroData) == 'table' then
			local abilities = {}
			for key , data in pairs(heroData) do
				if string.find(key,'Ability') then
					local strID = string.sub(key,#'Ability'+1,-1)
					local id = tonumber(strID)
					print('strID',strID , 'id',id)
					if id then
						abilities[#abilities+1] ={ key = key , id = id , name = data ,} 
					end
				end
			end

			table.sort(abilities,function(a,b) return a.id < b.id end)

			for id , ability in ipairs(abilities) do
				fileWrite:write('\t\t"%s"  "%s"\n',ability.key,ability.name)
			end
		end
		fileWrite:write('\n\t}\n')
	end
	fileWrite:write('\n}')
	fileWrite:close()
end

function gm.refresh(args)
	RefreshAbilitys(GetPlayerHero())
end

function gm.book()
	GameRules:InitGameData()
	CustomGameEventManager:Send_ServerToAllClients( "init_books_event", MBTable['round_list'] )
end

function gm.reg()
	GameRules:RegisterUIEventListeners()
end

function gm.weak()
	local weak = GetFirstHeroWeak()
	DeepPrintTable(weak)
end

function gm.ability()
	CustomGameEventManager:Send_ServerToAllClients( "ability_event", {name = "puck" , time=2} )
	Timers:CreateTimer(4,function()print('end!!') end)
end

function gm.addnpc()
	local unit = CreateUnitByName("npc_dota_hero_earthshaker",GetPlayerVector(),true,nil,nil,DOTA_TEAM_NEUTRALS)
end

function gm.sound(args)
	local hero = GetPlayerHero()
	if args[1] == '1' then
		GameRules:HeroFail(hero)
	elseif args[1] == '2' then
		GameRules:BaoFa(hero)
	elseif args[1] == '3' then
		GameRules:Test(hero,tonumber(args[2]))
	end
end

function gm.logic(args)
	Login(1)
end

function gm.getscore(args)
	local round_list = MBTable['round_list']
	local books = {}
	for id , line in pairs(round_list) do
		table.insert(books,id)
	end
	GetBookScoreData(1,books)
end

function gm.setscore(args)
	local round_list = MBTable['round_list']
	local books = {}
	for id , line in pairs(round_list) do
		SetBookScoreData(1,id,80)
	end
end

function gm.up(args)
	local hero = GetPlayerHero()
	local round_list_id = 1
	local score = 10
	local pre_score = 100
	
	if pre_score == nil or pre_score < score then
		SetBookScoreData(1,round_list_id,score)
	end
	if pre_score == nil then
		pre_score = 0
	end
	CustomGameEventManager:Send_ServerToAllClients( "update_round_score", {id=round_list_id,score = score , pre_score = pre_score})
end

function gm.mana(args)
	local hero = GetPlayerHero()
	hero:SetMana(0)
end

function gm.test(args)
	print(package.path);
	GameRules:MB2Lua()
	--local myfile = io.popen("test.bat", "r")
end

GameRules.gm = gm