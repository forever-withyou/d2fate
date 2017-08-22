function MordredOverchargeDamage(hCaster, hTarget, fDamage, hAbility)
    local hEAbility = hCaster:FindAbilityByName("mordred_e")
    local fMagicDamagePercent = hEAbility:GetSpecialValueFor("passive_damage") / 100
    local fMagicDamage = fDamage * fMagicDamagePercent

    if hCaster:HasModifier("modifier_mordred_overcharge") then
        local hModifier = hCaster:FindModifierByName("modifier_mordred_overcharge")
        local fModDamagePercent = 1 + (hModifier.fMana / 50) / 100
        fMagicDamage = fMagicDamage * fModDamagePercent * (1 + (hEAbility:GetSpecialValueFor("aug_damage_bonus") / 100))
    end

    DoDamage(hCaster, hTarget, fMagicDamage, DAMAGE_TYPE_MAGICAL, 0, hAbility, false)
end