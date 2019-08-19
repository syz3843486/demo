local mod1Name = "modifier_attack_faster"
local mod2Name = "modifier_add_atksp"
local mod3Name = "modifier_max_atksp"

function BaoFa(hero)
  local r = RandomInt(1,#baofa_sounds)
  print(baofa_sounds[r])
  EmitGlobalSound("test")
end

-- function OnDealDamage(keys)
-- 	if not IsServer() then return end
--   local ability = keys.ability
-- 	-- for k,v in pairs(keys) do
--  --     	print(k,v)
--  --   	end
--   local caster = keys.caster
--  	print ('add_modifier_passive_attack_caster1111')
--   local mod1 = caster:FindModifierByName(mod1Name)
--   local mod2 = caster:FindModifierByName(mod2Name)
--   local mod3 = caster:FindModifierByName(mod3Name)

--   if mod3 then return end

--  	print ('add_modifier_passive_attack_caster2222  ',mod1)
--  	local stackCnt = caster:GetModifierStackCount(mod2Name,caster)
--       print('stackCnt ',stackCnt)

--   	if stackCnt < 20 then
--   		print('cnt ',stackCnt)
--       if mod2 == nil then
--         mod2 = ability:ApplyDataDrivenModifier(caster,caster,mod2Name,nil)
--         local particle = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter_text_burst.vpcf"
--         mod2:AddParticle(1,false,true,10,true,false)
--       end
--   		caster:SetModifierStackCount(mod2Name, caster, stackCnt+1)
--       mod2:ForceRefresh()
--   	else
--       caster:EmitSound("jug_baofa")
--   		caster:SetModifierStackCount(mod1Name, caster, 0)
--       caster:RemoveModifierByName(mod2Name)
--   		ability:ApplyDataDrivenModifier(caster,caster,mod3Name,nil)
--   	end
-- end

function OnDestroy(keys)
  local caster = keys.caster
  caster:RemoveModifierByName(mod2Name)
end

local function AddMana(hero,precent)
  local maxMana = hero:GetMaxMana()
  local preMana = hero:GetMana()
  local addMana = maxMana * precent
  local curMana = preMana + addMana
  if curMana > maxMana then
    curMana = maxMana
  elseif curMana < 0 then
    curMana = 0
  end
  hero:SetMana(curMana)
end

function OnAttack(keys)
  if not IsServer() then return end
  print("OnAttack!!")
  -- local caster = keys.caster
  -- AddMana(caster)
end

local GenerateAttackMana = 20 --普弓
local AbilityAttackMana = 5 --技能

function OnDealDamage(keys)
  if not IsServer() then return end
  local caster = keys.caster
  local precent = GenerateAttackMana
  for i=0,5 do
    local ability = caster:GetAbilityByIndex(i)
    if ability:GetCooldownTimeRemaining() > 0 then
      precent = AbilityAttackMana
      break
    end
  end
  AddMana(caster,precent/100)
end

function OnIntervalThink(keys)
  if not IsServer() then return end
  local caster = keys.caster
  local maxMana = caster:GetMaxMana()
  local curMana = caster:GetMana()
  local percent = curMana / maxMana
  local mod3 = caster:FindModifierByName(mod3Name)

  if mod3 then return end
  AddMana(keys.caster , -0.01)

  local ability = keys.ability
  if percent < 0.95 then
    local stack = math.floor(percent * 10) 
    local mod2 = caster:FindModifierByName(mod2Name)
      if mod2 == nil then
        mod2 = ability:ApplyDataDrivenModifier(caster,caster,mod2Name,nil)
        local particle = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter_text_burst.vpcf"
        mod2:AddParticle(1,false,true,10,true,false)
      end

      caster:SetModifierStackCount(mod2Name, caster, stack)
  else
    caster:EmitSound("jug_baofa")
    caster:RemoveModifierByName(mod2Name)
    ability:ApplyDataDrivenModifier(caster,caster,mod3Name,nil)
  end
end

local dt = 0.33
function MaxAtkSpOnIntervalThink(keys)
  if not IsServer() then return end
  print('-->')
  for k , _ in pairs(keys) do
    print(k)
  end
  print('<--')
  AddMana(keys.caster , -0.06)
end