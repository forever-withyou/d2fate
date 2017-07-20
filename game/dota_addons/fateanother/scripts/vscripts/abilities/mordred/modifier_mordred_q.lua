modifier_mordred_q = class({})

function modifier_mordred_q:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_mordred_q:IsHidden()
	return false
end

function modifier_mordred_q:OnDestroy()
	if not IsServer() then return end
	local hParent = self:GetParent()
	local hCurrentAbility = hParent:GetAbilityByIndex(0)
	local sAbility = hCurrentAbility:GetAbilityName()
	if sAbility == "mordred_q_slash" then return end
	
	hParent:SwapAbilities("mordred_q_slash", sAbility, true, false)
end