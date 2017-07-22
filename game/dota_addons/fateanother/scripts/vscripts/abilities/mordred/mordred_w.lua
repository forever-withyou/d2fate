mordred_w = class({})
LinkLuaModifier( "modifier_mordred_w", "abilities/mordred/modifier_mordred_w", LUA_MODIFIER_MOTION_NONE )

function mordred_w:OnSpellStart()
	local hCaster = self:GetCaster()
	local iDashes = self:GetSpecialValueFor("dashes")
	local fRange = self:GetSpecialValueFor("dash_range")
	local vPosition = hCaster:GetAbsOrigin()
	local vTarget = hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * fRange
	local fTick = 1/30
	local t = 0
	Timers:CreateTimer(function()
		t = t + 0.25
		local vNewPos = SplineVectors(vPosition, vTarget, t)
		local vGroundPos = GetGroundPosition(vNewPos, hCaster)
		
		if GridNav:IsBlocked(vGroundPos) or not GridNav:IsTraversable(vGroundPos) then
			FindClearSpaceForUnit(hCaster, vGroundPos, true)
			return
		end
		
		hCaster:SetAbsOrigin(vGroundPos)
		
		if t >= 1 then
			return
		end
		return fTick
	end)
end

function mordred_w:GetIntrinsicModifierName()
	return "modifier_mordred_w"
end