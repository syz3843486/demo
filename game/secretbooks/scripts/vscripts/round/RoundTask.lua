local BTreeCMN = require("behavior/BTreeCMN")
require("common/common")

local bDebug = true
local function dp(...)
	if bDebug then
		print(string.format(...))
	end
end


local RoundNodeType ={
	AI = 1,--AI
	BackTime = 2, -- 时间倒流
	Exit = 3, --结束
	Refresh = 4, -- 刷新
}

local AINodeType = {
	RandFromVar2 = 1,--从var2中随机AI
	RandFromVar2WithWeak = 2, -- 从var2中按弱点随机
	RandFromAllAIWithWeak = 3, -- 从AI表中弱点随机
	RandFromAllAIWithoutRunWeak = 4, -- 从AI表中非走位弱点随机
	RandFromAllAIWithRunWeak = 5, -- 从AI表中移动弱点随机
}

local RoundTask = BTreeCMN.Class('RoundTask')
GameRules.RoundTask = RoundTask

local timerEntity = nil

function RoundTask:ctor(id,curTime)
	dp('id %s' , id)
	self.round_list_id = id
	self.round_list_line = MBTable['round_list'][id]
	self.dt = self.round_list_line['DT']
	dp('self.dt %s',self.dt , 'id ',id)
	local round_name = self.round_list_line['RoundName']
	dp('round_name ',round_name)
	self.roundMB = MBTable[round_name]
	self.curTime = curTime == nil and 0 or curTime
	self.debugTime = self.curTime
	self.osTime = Time()
	self.nodeExeTimes = {} --结点执行次数
	self.delayFuncTiemrKeys = {}

	if not timerEntity then
		timerEntity = Entities:CreateByClassname("info_target")
	end
	self.timerEntity = timerEntity
end

function RoundTask:Enter()
	dp('self.curTime %s',self.curTime)
	self.timerEntity:SetContextThink("RoundTick",function(entity) 
		if self:Tick() == false then
			self:Exit()
			return -1
		end
		return self.dt
	end,self.dt)
end

function RoundTask:Exit()
	self.timerEntity:SetContextThink("RoundTick",function(entity) dp('Exit') end,-1)
	
	--清除延迟函数
	for key in pairs(self.delayFuncTiemrKeys) do
		self.timerEntity:SetContextThink(key,function(entity) end,-1)
		self.delayFuncTiemrKeys[key] = nil
	end
end

local function AINodeFunc_RandFromVar2(aiIDs)
	if #aiIDs == 0 then
		return true
	end

	local AIMB = MBTable['AI']
	dp('#aiIDs %s',#aiIDs)
	local aiID = aiIDs[math.random(1,#aiIDs)]
	local AIMB_Line = AIMB[aiID]
	if AIMB_Line then
		dp('CreateAINpcByID %s',aiID)
		local unit = CreateAINpcByID(aiID)
		if unit then
			Defualt_AddItem(unit)
		end
	end

	return true
end

local function AINodeFunc_RandFromVar2WithWeak(aiIDs)
	if #aiIDs == 0 then
		return true
	end
	local weak = GetFirstHeroWeak()
	local visibleIDs = {}
	for _ , id in pairs(aiIDs) do

		if IsAIInWeak(id,weak) then
			table.insert(visibleIDs,id)
		end
	end

	if #visibleIDs == 0 then
		return true
	end

	id = visibleIDs[math.random(1,#visibleIDs)]
	local unit = CreateAINpcByID(id)
	if unit then
		Defualt_AddItem(unit)
	end

	return true
end

local function AINodeFunc_RandFromAllAIWithWeak()
	local weak = GetFirstHeroWeak()

	local Weak_AI_List = GameRules.Round.Npc_AI_Data.Weak_AI_List
	local ai_list = {}
	for _ ,w in pairs(weak) do
		local w_ai_list = Weak_AI_List[w]
		for _ , line in pairs(w_ai_list) do
			table.insert(ai_list,line)
		end
	end

	if #ai_list > 0 then
		local id = ai_list[math.random(1,#ai_list)]['id']
		local unit = CreateAINpcByID(id)
		if unit then
			Defualt_AddItem(unit)
		end
	end

	return true
end

local function AINodeFunc_RandFromAllAIWithoutRunWeak()
	local weak = GetFirstHeroWeak()
	local Weak_AI_List = GameRules.Round.Npc_AI_Data.Weak_AI_List
	local ai_list = {}
	for _ ,w in pairs(weak) do
		if w ~= GameRules.WeakType.run then
			local w_ai_list = Weak_AI_List[w]
			for _ , line in pairs(w_ai_list) do
				table.insert(ai_list,line)
			end
		end
	end
	if #ai_list > 0 then
		local id = ai_list[math.random(1,#ai_list)]['id']
		local unit = CreateAINpcByID(id)
		if unit then
			Defualt_AddItem(unit)
		end
	end
	return true
end

local function AINodeFunc_RandFromAllAIWithRunWeak()
	local weak = GetFirstHeroWeak()
	local Weak_AI_List = GameRules.Round.Npc_AI_Data.Weak_AI_List
	local ai_list = {}
	for _ ,w in pairs(weak) do
		if w == GameRules.WeakType.run then
			local w_ai_list = Weak_AI_List[w]
			for _ , line in pairs(w_ai_list) do
				table.insert(ai_list,line)
			end
		end
	end
	if #ai_list > 0 then
		local id = ai_list[math.random(1,#ai_list)]['id']
		dp('CreateAINpcByID %s',id)
		local unit = CreateAINpcByID(id)
		if unit then
			Defualt_AddItem(unit)
		end
	end
	return true
end

local AINodeFuncMap = {
	[AINodeType.RandFromVar2] = AINodeFunc_RandFromVar2,
	[AINodeType.RandFromVar2WithWeak] = AINodeFunc_RandFromVar2WithWeak,
	[AINodeType.RandFromAllAIWithWeak] = AINodeFunc_RandFromAllAIWithWeak,
	[AINodeType.RandFromAllAIWithoutRunWeak] = AINodeFunc_RandFromAllAIWithoutRunWeak,
	[AINodeType.RandFromAllAIWithRunWeak] = AINodeFunc_RandFromAllAIWithRunWeak,
}

local function AINodeFunc(task,id,var1,var2)
	local nodeExeTimes = task.nodeExeTimes
	if nodeExeTimes[id] == nil then
		nodeExeTimes[id] = 0
	end

	if nodeExeTimes[id] > 0 then
		return true
	end
	CustomGameEventManager:Send_ServerToAllClients( "ability_event", {name = task.line["name"] , time=5} )
	local type = var1[1]
	nodeExeTimes[id] = nodeExeTimes[id]+1
	local delayKey = DoUniqueString("delay")
	task.delayFuncTiemrKeys[delayKey] = true
	task.timerEntity:SetContextThink(delayKey, function()
		AINodeFuncMap[type](var2)
		task.delayFuncTiemrKeys[delayKey] = nil
    end, 5) 
	return true
end
--backCnt==0 表示无数次
local function BackTImeNodeFunc(task,id,var1, var2)
	local curTime = task.curTime
	local roundMB = task.roundMB
	local nodeExeTimes = task.nodeExeTimes
	if nodeExeTimes[id] == nil then
		nodeExeTimes[id] = 0
	end
	local backCnt = var2[1]
	dp('nodeExeTimes[id] %s backCnt %s',nodeExeTimes[id],backCnt)
	if backCnt ~= 0 and nodeExeTimes[id] >= backCnt then
		return true
	end
	local backtime = var1[1]
	nodeExeTimes[id] = nodeExeTimes[id] + 1

	for _id , node in pairs(nodeExeTimes) do
		local minTime = roundMB[_id]['minTime']
		--dp('maxTime %s backtime %s curTime %s',maxTime,backtime,curTime)
		if minTime >= backtime and minTime <= curTime and id ~= _id then
			nodeExeTimes[_id] = 0
		end
	end

	task.curTime = backtime
	dp('task.curTime %s',task.curTime)
	return true
end

local function ExitNodeFunc(task,id)
	return false
end

local function RefreshNodeFunc(task,id)
	local nodeExeTimes = task.nodeExeTimes
	if nodeExeTimes[id] == nil then
		nodeExeTimes[id] = 0
	end

	if nodeExeTimes[id] > 0 then
		return true
	end
	nodeExeTimes[id] = nodeExeTimes[id]+1
	local delayKey = DoUniqueString("delay")
	task.delayFuncTiemrKeys[delayKey] = true
	task.timerEntity:SetContextThink(delayKey, function()
		RefreshAbilitys(GetPlayerHero())
		task.delayFuncTiemrKeys[delayKey] = nil
    end, 5) 
	return true
end

local RoundNodeTypeFuncMap = {
	[RoundNodeType.AI] = AINodeFunc,
	[RoundNodeType.BackTime] = BackTImeNodeFunc,
	[RoundNodeType.Exit] = ExitNodeFunc,
	[RoundNodeType.Refresh] = RefreshNodeFunc,
}


function RoundTask:Tick()
	local curTime = self.curTime
	local debugTime = self.debugTime

	dp('curTime %s',curTime)
	local roundMB = self.roundMB
	local nodeExeTimes = self.nodeExeTimes
	
	local rst = true

	for id , line in ipairs(roundMB) do
		local minTime,maxTime = line['minTime'],line['maxTime']
		local flagTime = math.random(minTime,maxTime)
		if flagTime < curTime and debugTime < flagTime then
			self.line = line
			local type,var1,var2,var3 = line['type'],line['var1'],line['var2'],line['var3']
			dp('type %s,var1 %s,var2 %s,var3 %s',type,var1[1],var2[1],var3)
			rst = RoundNodeTypeFuncMap[type](self,id,var1,var2,var3) and rst
		end
	end
	--dp('rst %s Time() %s self.osTime %s ',rst,Time(),self.osTime)
	local dt = Time()-self.osTime
	self.curTime = self.curTime + dt
	self.osTime = Time()
	return rst and self.dt
end

