modifier_mordred_w = class({})

function modifier_mordred_w:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	
	return funcs
end

function modifier_mordred_w:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("ms_increase")
end