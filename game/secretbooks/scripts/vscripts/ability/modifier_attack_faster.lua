-- function OnAttack(keys)
-- 	if ~IsServer() then return end

--  	  print ('add_modifier_passive_attack_caster1111')
--  	  local mod1Name = "mod_add_attackspeed"
--  	  local mod2Name = "mod_max_attackspeed"
--   	local mod1 = ent:FindModifierByName(mod1Name)
--   	local mod2 = ent:FindModifierByName(mod2Name)

--   	if mod2 then
--   		return
--   	end

--   	local caster = keys.caster
  	
--  	  print ('add_modifier_passive_attack_caster2222')
--  	  local stackCnt = mod1:GetModifierStackCount()
--   	if stackCnt < 20 then
--   		print('cnt ',stackCnt)
--   		caster:SetModifierStackCount(mod1Name, caster, stackCnt+1)

--   	else
--   		caster:SetModifierStackCount(mod1Name, caster, 0)
--   		ApplyDataDrivenModifier(caster,caster,mod2Name,nil)
--   	end
-- end

local function AddMana(hero)
  local maxMana = caster:GetMaxMana()
  local preMana = caster:GetMana()
  local curMana = maxMana * 0.1
  local giveMana = curMana - preMana
  if curMana > maxMana then
    giveMana = maxMana - preMana
  end
  hero:GiveMana(giveMana)
end

function OnAttack(keys)
  if ~IsServer() then return end
  print("OnAttack!!")
  local caster = keys.caster
  AddMana(caster)
end
function OnIntervalThink(keys)
  if ~IsServer() then return end

  DeepPrintTable(keys)
end