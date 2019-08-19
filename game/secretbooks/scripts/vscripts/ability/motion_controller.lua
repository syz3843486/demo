fast_move_w_modifier = class({})
fast_move_a_modifier = class({})
fast_move_s_modifier = class({})
fast_move_d_modifier = class({})

local MAX_MOVE_DIS = 400
local MOVE_SPEED = 1200
-- W
function fast_move_w_modifier:GetBehavior()
	if not IsServer() then return end

end

function fast_move_w_modifier:OnCreated(kv)
	if not IsServer() then return end
	print('IsServer() ',IsServer())
	self.bHorizontalMotionInterrupted = false
	if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
		print('---destory')
		self:Destroy()
		return
	end
	print(kv.targetpos) 
	local curPos = self:GetParent():GetAbsOrigin()
	self.targetpos = self:GetAbility():GetCursorPosition()
	print('self.targetpos',self.targetpos)
	self.dir = (self.targetpos - curPos )
	self.distance = #self.dir
	self.dir = self.dir:Normalized()
	if self.distance > MAX_MOVE_DIS then
		self.distance = MAX_MOVE_DIS
		self.targetpos = curPos + self.dir*MAX_MOVE_DIS
	end

	print('curPos ',curPos , 'targetPos', self.targetpos)


	--self:GetParent():SetForwardVector(self.dir)
	print('----')
end

function fast_move_w_modifier:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		print('----')
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end
		local vOldPos = me:GetOrigin()
		local moveDis = MOVE_SPEED * dt
		self.distance = self.distance - moveDis
		if self.distance <= 0 then
			me:SetOrigin(self.targetpos)
			self:Destroy()
			return 
		end

		print('----vOldPos',vOldPos)
		local pos = vOldPos + self.dir * MOVE_SPEED * dt
		me:SetOrigin(pos)
	end
end

function fast_move_w_modifier:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
		self:GetParent():SetForwardVector(self.dir)
	end
end

function fast_move_w_modifier:GetModifierDisableTurning()
	return true
end

function fast_move_a_modifier:OnCreated()
	if not IsServer() then return end
	print('IsServer() ',IsServer())
	self.bHorizontalMotionInterrupted = false
	if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
		print('---destory')
		self:Destroy()
		return
	end
	self.dir = -self:GetParent():GetRightVector():Normalized()
	--self:GetParent():SetForwardVector(self.dir)
	print('----')
end

function fast_move_a_modifier:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		print('----')
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end
		local vOldPos = me:GetOrigin()
		print('----vOldPos',vOldPos)
		local pos = vOldPos + self.dir * 1200 * dt
		me:SetOrigin(pos)
	end
end

function fast_move_a_modifier:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
		self:GetParent():SetForwardVector(self.dir)
	end
end

function fast_move_a_modifier:GetModifierDisableTurning()
	return true
end

-- S

function fast_move_s_modifier:OnCreated()
	if not IsServer() then return end
	print('IsServer() ',IsServer())
	self.bHorizontalMotionInterrupted = false
	if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
		print('---destory')
		self:Destroy()
		return
	end
	self.dir = -self:GetParent():GetForwardVector():Normalized()
	--self:GetParent():SetForwardVector(self.dir)
	print('----')
end

function fast_move_s_modifier:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		print('----')
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end
		local vOldPos = me:GetOrigin()
		print('----vOldPos',vOldPos)
		local pos = vOldPos + self.dir * 1200 * dt
		me:SetOrigin(pos)
	end
end

function fast_move_s_modifier:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
		self:GetParent():SetForwardVector(self.dir)
	end
end

function fast_move_s_modifier:GetModifierDisableTurning()
	return true
end

-- D

function fast_move_d_modifier:OnCreated()
	if not IsServer() then return end
	print('IsServer() ',IsServer())
	self.bHorizontalMotionInterrupted = false
	if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
		print('---destory')
		self:Destroy()
		return
	end
	self.dir = self:GetParent():GetRightVector():Normalized()
	--self:GetParent():SetForwardVector(self.dir)
	print('----')
end

function fast_move_d_modifier:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		print('----')
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end
		local vOldPos = me:GetOrigin()
		print('----vOldPos',vOldPos)
		local pos = vOldPos + self.dir * 1200 * dt
		me:SetOrigin(pos)
	end
end

function fast_move_d_modifier:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
		self:GetParent():SetForwardVector(self.dir)
	end
end

function fast_move_d_modifier:GetModifierDisableTurning()
	return true
end