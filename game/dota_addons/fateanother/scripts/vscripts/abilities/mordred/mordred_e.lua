mordred_e = class({})
LinkLuaModifier("modifier_mordred_e", "abilities/mordred/modifier_mordred_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mordred_overcharge", "abilities/mordred/modifier_mordred_overcharge", LUA_MODIFIER_MOTION_NONE)

function mordred_e:GetIntrinsicModifierName()
    return "modifier_mordred_e"
end

function mordred_e:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
    local fDrain = self:GetSpecialValueFor("drain")

    self.fDrain = fDrain
    self.fDrained = 0
    self.fDrainTime = 0

    local pcDrain = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
    ParticleManager:SetParticleControlEnt(pcDrain, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_righthand", hCaster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pcDrain, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
    self.pcDrain = pcDrain
end

function mordred_e:OnChannelThink(fInterval)
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
    local fDrain = self.fDrain * fInterval

    if hTarget:GetMana() <= fDrain or hCaster:GetMana() >= hCaster:GetMaxMana() then
        self:EndChannel(false)
        return
    end

    hTarget:SpendMana(fDrain, self)
    hCaster:GiveMana(fDrain)
    self.fDrained = self.fDrained + fDrain
    self.fDrainTime = self.fDrainTime + fInterval
end

function mordred_e:OnChannelFinish(bInterrupted)
    local hCaster = self:GetCaster()
    ParticleManager:DestroyParticle(self.pcDrain, false)
    ParticleManager:ReleaseParticleIndex(self.pcDrain)

    if self.fDrainTime >= 1 then
        hCaster:AddNewModifier(hCaster, self, "modifier_mordred_overcharge", { Duration = self:GetSpecialValueFor("duration"), fDrained = self.fDrained })
    end
end