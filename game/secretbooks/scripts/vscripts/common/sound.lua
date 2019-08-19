function GameRules:BeginRound(hero)
	hero:EmitSound("announcer_dlc_juggernaut_announcer_battle_begin_01")
end

local jugg_fail_sounds = {
	"juggernaut_jug_arc_abil_omnifail_01",
	"juggernaut_jug_arc_abil_omnifail_02",
	"juggernaut_jug_arc_abil_omnifail_03",
}

function GameRules:HeroFail(hero)
	local r = RandomInt(1,#jugg_fail_sounds)
	hero:EmitSound(jugg_fail_sounds[r])
end

function GameRules:BaoFa(hero)
	print('-baofa')
	hero:EmitSound("jug_baofa")
end

function GameRules:Test(hero)
	hero:EmitSound("jug_new_attack")
end

local winSounds = 
{
	"juggernaut_jug_win_01",
	"juggernaut_jug_win_02",
	"juggernaut_jug_win_03",
	"juggernaut_jug_win_04",
}

function GameRules:PlayWinSound(hero)
	local r = math.random(1,#winSounds)
	hero:EmitSound(winSounds[r])
end