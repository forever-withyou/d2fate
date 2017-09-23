mordred_e = class({})
LinkLuaModifier("modifier_mordred_e", "abilities/mordred/modifier_mordred_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mordred_overcharge", "abilities/mordred/modifier_mordred_overcharge", LUA_MODIFIER_MOTION_NONE)

function mordred_e:GetIntrinsicModifierName()
    return "modifier_mordred_e"
end

function mordred_e:OnSpellStart()
    local hCaster = self:GetCaster()
    local fDrain = self:GetSpecialValueFor("drain")

    self.fDrain = fDrain
    self.fDrained = 0
    self.fDrainTime = 0

    local pcDrain = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning_trail_base_elec.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
    self.pcDrain = pcDrain
end

function mordred_e:OnChannelThink(fInterval)
    local hCaster = self:GetCaster()
    local fDrain = self.fDrain * fInterval

    if hCaster:GetMana() <= 10 then
        self:EndChannel(false)
        return
    end

    hCaster:SpendMana(fDrain, self)
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