master2_attributes_list = class({})

function master2_attributes_list:OnSpellStart()
	local hCaster = self:GetCaster()
	local tAttributes = hCaster.tAttributes
	if not tAttributes then return end
	
	tAttributes[#tAttributes] = nil
	table.insert(tAttributes, 4, "fate_empty1")
	table.insert(tAttributes, 5, "master2_close_list")
	
	
	UpdateAbilityLayout(hCaster, tAttributes)
end