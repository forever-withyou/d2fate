mordred_e = class({})
LinkLuaModifier("modifier_mordred_e", "abilities/mordred/modifier_mordred_e", LUA_MODIFIER_MOTION_NONE)

function mordred_e:GetIntrinsicModifierName()
    return "modifier_mordred_e"
end

function mordred_e:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()

    local pcDrain = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
    ParticleManager:SetParticleControlEnt(pcDrain, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_righthand", hCaster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pcDrain, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
    self.pcDrain = pcDrain
end

function mordred_e:OnChannelFinish(bInterrupted)
    ParticleManager:DestroyParticle(self.pcDrain, false)
    ParticleManager:ReleaseParticleIndex(self.pcDrain)
end