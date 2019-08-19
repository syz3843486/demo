bDebug = true
local function dp( ... )
	if bDebug then
		print(string.format(...))
	end
end

modifier_fish_angry = class({})
--------------------------------------------------------------------------------
function modifier_fish_angry:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.5)
		self:SetDuration(1000,true)
	end
end

function modifier_fish_angry:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local hp = caster:GetHealth()
		local maxhp = caster:GetMaxHealth()
		
		local k = -2/(maxhp-1)
		local a = 3 - k
		if k == 0 then
			dp('modifier_fish_angry:OnIntervalThink k==0')
			return
		end

		if hp >= 1 then
			caster:SetModelScale(k*hp+a)
		end
	end
end
