require ('common/common')

local function AddScoreCB(var1)
	local hero = GetPlayerHero()
	AddScore(hero,var1,hero)
end

local CallBackTable =
{
	addscore = AddScoreCB,
}

local function CreateGoldBag(type,range,var1,var2)
	local player = GetPlayerHero()
	local item = CreateItem("item_bag_of_gold",nil,nil)
	local pos = player:GetAbsOrigin()
	local physicalItem = CreateItemOnPositionSync(pos,item)
	pos = player:GetAbsOrigin() + RandomVector(range)
	local droptime = 0.75
	item:LaunchLoot(true, 200, droptime, pos)
	
	local dt = 0.1
	physicalItem.curtime = 0
	local destroyTime = 7
	physicalItem:SetContextThink("pick",function()
		physicalItem.curtime = physicalItem.curtime + dt
		if physicalItem.curtime < droptime +0.1 then
			return dt
		end

		local v = GetPlayerVector()
		local dis = (v - pos):Length2D()
		if dis < 200 then
			CallBackTable[type](var1,var2)
			EmitSoundOn("General.Coins",GetPlayerHero())
			physicalItem:Kill()
			return 0;
		end
		local factor = physicalItem.curtime/destroyTime
		local lerp = 256*factor
		physicalItem:SetRenderColor(lerp,0,lerp)
		physicalItem:SetModelScale((1-factor) * 3)
		if physicalItem.curtime > destroyTime then
			physicalItem:Kill()
			return 0;
		end

		return dt
	end,dt)
end

local function RepeatCreateGoldBag(cnt,range,type,var1,var2)
	EmitSoundOn("General.Coins",GetPlayerHero())
	for i=1 , cnt do
		CreateGoldBag(type,range,var1,var2)
	end
end

GameRules.CreateGoldBag = CreateGoldBag
GameRules.RepeatCreateGoldBag = RepeatCreateGoldBag