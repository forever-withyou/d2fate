mordred_q_leap = class({})

function QuadBezier(t, p1, p2, p3)
	return ((1 - t)^2 * p1) + (2 * (1 - t) * t * p2) + t^2 * p3 
end

function mordred_q_leap:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTarget = self:GetCursorPosition()
	local vLocation = hCaster:GetAbsOrigin()
	local vBetween = vTarget - vLocation
	local fDistance = vBetween:Length()
	local vMidpoint = hCaster:GetAbsOrigin() + vBetween:Normalized() * (fDistance / 2)
	vMidpoint.z = vMidpoint.z + 800
	local fTravelTime = 0.5
    local fTick = 0.033
    local fTickTravel = fTick / fTravelTime
	local t = 0
	
	local pcJump = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit.vpcf", PATTACH_ABSORIGIN, hCaster)
    ParticleManager:ReleaseParticleIndex(pcJump)
	giveUnitDataDrivenModifier(hCaster, hCaster, "jump_pause", fTravelTime)
	
	Timers:CreateTimer(function()
		t = t + fTickTravel
		if t >= 1 then
			FindClearSpaceForUnit(hCaster, hCaster:GetAbsOrigin(), true)
			self:OnLand(hCaster)
			return nil
		end
		local vPos = QuadBezier(t, vLocation, vMidpoint, vTarget)
		hCaster:SetAbsOrigin(vPos)
		return fTick
	end)

    hCaster:SwapAbilities("mordred_q_throw", "mordred_q_leap", true, false)
	hCaster:AddNewModifier(hCaster, self, "modifier_mordred_q", { Duration = 3 })
end

function mordred_q_leap:OnLand(hCaster)
	local fDamage = self:GetSpecialValueFor("damage")
	local fStun = self:GetSpecialValueFor("stun")
	local fRadius = self:GetSpecialValueFor("radius")
	
	local pcHit = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit.vpcf", PATTACH_ABSORIGIN, hCaster)
    ParticleManager:ReleaseParticleIndex(pcHit)
	
	local tTargets = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetAbsOrigin(), nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	
	for k, v in pairs(tTargets) do
		DoDamage(hCaster, v, fDamage, DAMAGE_TYPE_PHYSICAL, 0, self, false)
		v:AddNewModifier(hCaster, self, "modifier_stunned", { Duration = fStun })
	end
end

function mordred_q_leap:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function mordred_q_leap:GetCastRange()
	return self:GetSpecialValueFor("range")
end

function mordred_q_leap:CastFilterResultLocation(vLocation)
	if IsServer() then
		if GridNav:IsBlocked(vLocation) or not GridNav:IsTraversable(vLocation) then
			return UF_FAIL_CUSTOM
		end
	end
	
	return UF_SUCCESS
end

function mordred_q_leap:GetCustomCastErrorLocation(vLocation)
	return "Can't jump there"
end