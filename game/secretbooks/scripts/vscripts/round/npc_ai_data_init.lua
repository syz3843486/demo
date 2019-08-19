WeakType = 
{
	run=0, --走位
	blink=1, --跳刀
	bkb=2, --bkb
	stuff=3,  -- 推推
	blade =4, --大晕
	manta = 5, --分身
	sheepstick=6,--羊刀
	cyclone =7,--风杖
	qop_b=8,  --女王B
	jugg_f=9, --剑圣F
	jugg_r=10, --剑圣大招
}
GameRules.WeakType = WeakType

GameRules.item_weak = {
	item_manta = WeakType.manta,
	item_blink = WeakType.blink,
	item_abyssal_blade = WeakType.blade,
}

GameRules.ability_weak={
	juggernaut_blade_fury = WeakType.jugg_f,
	juggernaut_omni_slash = WeakType.jugg_r,
}

local function Init_Weak_AI_List(npc_ai_data)
	local MB_AI = npc_ai_data.MB_AI
	local Weak_AI_List = {}
	for _ , w in pairs(WeakType) do
		Weak_AI_List[w] = {}
	end

	for idx , line in ipairs(MB_AI) do
		local Weak = line.weak
		for i=1 , #Weak do
			if Weak[i] == WeakType.run then
				for _ , w in pairs(WeakType) do
					Weak_AI_List[w][line.btf] = line
				end
				break
			else
				Weak_AI_List[Weak[i]][line.btf] = line
			end
		end
	end

	npc_ai_data.Weak_AI_List = Weak_AI_List
end

local function Init_Btf_AI_List(npc_ai_data)
	local MB_AI = npc_ai_data.MB_AI
	local Btf_AI_List = {}

	for idx , line in ipairs(MB_AI) do
		Btf_AI_List[line.btf] = line
	end

	npc_ai_data.Btf_AI_List = Btf_AI_List
end

local function Init_Name_AI_List(npc_ai_data)
	local MB_AI = npc_ai_data.MB_AI
	local Name_AI_List = {}

	for idx , line in ipairs(MB_AI) do
		Name_AI_List[line.npc_name] = line
	end

	npc_ai_data.Name_AI_List = Name_AI_List
end

local function Init()
	local npc_ai_data = {}
	npc_ai_data.MB_AI = MBTable['AI']

	Init_Weak_AI_List(npc_ai_data)
	Init_Btf_AI_List(npc_ai_data)
	Init_Name_AI_List(npc_ai_data)

	return npc_ai_data
end

return Init()