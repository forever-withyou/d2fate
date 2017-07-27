master2_attributes_list = class({})

function master2_attributes_list:OnSpellStart()
	local hCaster = self:GetCaster()
	UpdateAbilityLayout(hCaster, hCaster.tAttributes)
end