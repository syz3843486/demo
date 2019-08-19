fast_move_w = class({})
fast_move_a = class({})
fast_move_s = class({})
fast_move_d = class({})

LinkLuaModifier( "fast_move_w_modifier", "ability/motion_controller.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "fast_move_a_modifier", "ability/motion_controller.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "fast_move_s_modifier", "ability/motion_controller.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "fast_move_d_modifier", "ability/motion_controller.lua", LUA_MODIFIER_MOTION_BOTH )


function fast_move_w:OnSpellStart()
	EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster() )
	
	local caster = self:GetCaster()
	local kv =
	{
		duration = 0.2,
		source_ent_index = self:GetCaster():entindex(),
		targetpos = self:GetCursorPosition()
	}
	caster:AddNewModifier(caster,self,"fast_move_w_modifier",kv)
end

function fast_move_a:OnSpellStart()
	EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster() )
	
	local caster = self:GetCaster()
	local kv =
	{
		duration = 0.2,
		source_ent_index = self:GetCaster():entindex()
	}
	caster:AddNewModifier(caster,self,"fast_move_a_modifier",kv)
end

function fast_move_s:OnSpellStart()
	EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster() )
	
	local caster = self:GetCaster()
	local kv =
	{
		duration = 0.2,
		source_ent_index = self:GetCaster():entindex()
	}
	caster:AddNewModifier(caster,self,"fast_move_s_modifier",kv)
end

function fast_move_d:OnSpellStart()
	EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster() )
	
	local caster = self:GetCaster()
	local kv =
	{
		duration = 0.2,
		source_ent_index = self:GetCaster():entindex()
	}
	caster:AddNewModifier(caster,self,"fast_move_d_modifier",kv)
end
