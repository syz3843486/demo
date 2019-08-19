local BTreeCMN = require("behavior/BTreeCMN")
require "common/sound"
require "round/RoundTask"

local RoundModule = GameRules.Round

RoundModule.EnterRound = function (id,time)
	local hero = GetPlayerHero()
	hero:SetHealth(hero:GetMaxHealth())
	GameRules:BeginRound(hero)
	RoundModule.ExitRound()

	RoundModule.roundTask = GameRules.RoundTask.new(id,time)
	RoundModule.roundTask:Enter()
end

RoundModule.ExitRound = function()
	if RoundModule.roundTask then
		RoundModule.roundTask:Exit()
	end
end
