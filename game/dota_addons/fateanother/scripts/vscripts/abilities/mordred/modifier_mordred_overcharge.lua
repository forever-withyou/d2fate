modifier_mordred_overcharge = class({})

local tParams = {
    sEffectName = "particles/generic_gameplay/rune_doubledamage.vpcf",
    eEffectAttachType = PATTACH_ABSORIGIN_FOLLOW,
    tProperties = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    },
}

if IsClient() then require('wrappers') end
Wrappers.Modifier(modifier_mordred_overcharge, false, tParams)

function modifier_mordred_overcharge:OnCreated(args)
    self:Update(args.fDrained)
end

function modifier_mordred_overcharge:OnRefresh(args)
    self:Update(args.fDrained)
end

function modifier_mordred_overcharge:Update(float)
    if self.fMana == nil then self.fMana = 0 end

    if IsServer() then
        CustomNetTables:SetTableValue("sync", "mordred_overcharge", {fMana = self.fMana + float})
    end

    self.fMana = CustomNetTables:GetTableValue("sync", "mordred_overcharge").fMana
    self:SetStackCount(self.fMana)
end

function modifier_mordred_overcharge:GetModifierMagicalResistanceBonus()
    return self.fMana
end