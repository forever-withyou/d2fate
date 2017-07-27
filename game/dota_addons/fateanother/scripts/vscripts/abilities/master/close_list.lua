master2_close_list = class({})

function master2_close_list:OnSpellStart()
    local hCaster = self:GetCaster()
    local tAbilities = {
        "master2_attributes_list",
        "master2_stats1_list",
        "master2_stats2_list",
    }

    UpdateAbilityLayout(hCaster, tAbilities)
end