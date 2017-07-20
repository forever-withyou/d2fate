modifier_mordred_charge_slow = class({})

function modifier_mordred_charge_slow:OnCreated()
	self.fSlow = 0 - self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_mordred_charge_slow:IsDebuff()
	return true
end

function modifier_mordred_charge_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	
	return funcs
end

function modifier_mordred_charge_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.fSlow
end