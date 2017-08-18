modifier_mordred_e = class({})

function modifier_mordred_e:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
    }

    return funcs
end

function modifier_mordred_e:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor("passive_mana")
end