mordred_q_charge = class({})
LinkLuaModifier("modifier_mordred_charge_slow", "abilities/mordred/modifier_mordred_charge_slow", LUA_MODIFIER_MOTION_NONE)

function mordred_q_charge:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local fTick = 1/30
	local fSpeed = 1500 * fTick
	local fSearchRadius = 100
	local tHitTargets = {}
	
	hCaster:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 0.8)
	local pcCharge = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	
	Timers:CreateTimer(function()
		local vCurrentPos = hCaster:GetAbsOrigin()
		local vTargetPos = hTarget:GetAbsOrigin()
		local vDirection = (vTargetPos - vCurrentPos):Normalized()
		local fDistance = (vTargetPos - vCurrentPos):Length()
		
		if fDistance < 80 then
			self:EndCharge(hCaster, vCurrentPos, pcCharge)
			self:Knockback(hCaster, hTarget)
			return
		end
		
		vNewPos = vCurrentPos + vDirection * fSpeed
		vGroundPos = GetGroundPosition(vNewPos, hCaster)
		
		if GridNav:IsBlocked(vGroundPos) or not GridNav:IsTraversable(vGroundPos) then
			self:EndCharge(hCaster, vCurrentPos, pcCharge)
			return
		end
		
		hCaster:SetAbsOrigin(vGroundPos)
		local tTargets = FindUnitsInRadius(hCaster:GetTeam(), vGroundPos, nil, fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		
		for k, v in pairs(tTargets) do
			for key, val in pairs(tHitTargets) do
				if v == val then tTargets[k] = nil end
			end
		end
		
		for k, v in pairs(tTargets) do
			if v ~= hTarget then
				self:SoftKnockback(hCaster, v)
				table.insert(tHitTargets, v)
			end
		end
		
		return fTick
	end)
	
	hCaster:SwapAbilities("mordred_q_leap", "mordred_q_charge", true, false)
	hCaster:AddNewModifier(hCaster, self, "modifier_mordred_q", { Duration = 3 })
end

function mordred_q_charge:EndCharge(hCaster, vLoc, pc)
	hCaster:RemoveGesture(ACT_DOTA_RUN)
	FindClearSpaceForUnit(hCaster, vLoc, false)
	ParticleManager:DestroyParticle(pc, false)
	ParticleManager:ReleaseParticleIndex(pc)
end

function mordred_q_charge:SoftKnockback(hCaster, hTarget)
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	local fDamage = self:GetSpecialValueFor("damage") / 2
	local fTick = 1/30
	local fSpeed = 600 * fTick
	local iCounter = 0
	
	Timers:CreateTimer(function()
		iCounter = iCounter + 1
		local vCurrentPos = hTarget:GetAbsOrigin()
		
		if iCounter >= 5 then
			FindClearSpaceForUnit(hTarget, vCurrentPos, false)
			return
		end
		
		local vNewPos = vCurrentPos + vDirection * fSpeed
		local vGroundPos = GetGroundPosition(vNewPos, hTarget)
		
		if GridNav:IsBlocked(vGroundPos) or not GridNav:IsTraversable(vGroundPos) then
			FindClearSpaceForUnit(hTarget, vCurrentPos, false)
			return
		end
		
		hTarget:SetAbsOrigin(vGroundPos)
		
		return fTick
	end)
	
	DoDamage(hCaster, hTarget, fDamage, DAMAGE_TYPE_PHYSICAL, 0, self, false)
end

function mordred_q_charge:Knockback(hCaster, hTarget)
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	local fDamage = self:GetSpecialValueFor("damage")
	local fTick = 1/30
	local fSpeed = 600 * fTick
	local iCounter = 0
	
	local pcHit = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit.vpcf", PATTACH_ABSORIGIN, hCaster)
	
	Timers:CreateTimer(function()
		iCounter = iCounter + 1
		local vCurrentPos = hTarget:GetAbsOrigin()
		
		if iCounter >= 10 then
			FindClearSpaceForUnit(hTarget, vCurrentPos, false)
			return
		end
		
		local vNewPos = vCurrentPos + vDirection * fSpeed
		local vGroundPos = GetGroundPosition(vNewPos, hTarget)
		
		if GridNav:IsBlocked(vGroundPos) or not GridNav:IsTraversable(vGroundPos) then
			FindClearSpaceForUnit(hTarget, vCurrentPos, false)
			return
		end
		
		hTarget:SetAbsOrigin(vGroundPos)
		
		return fTick
	end)
	
	hTarget:AddNewModifier(hCaster, self, "modifier_mordred_charge_slow", { Duration = self:GetSpecialValueFor("slow_duration") })
	DoDamage(hCaster, hTarget, fDamage, DAMAGE_TYPE_PHYSICAL, 0, self, false)
end