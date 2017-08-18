mordred_q_throw = class({})

function mordred_q_throw:OnSpellStart()
    local hCaster = self:GetCaster()
    local vPos = hCaster:GetAbsOrigin()
    local vTarget = self:GetCursorPosition()
    local vDifference = vTarget - vPos
    local vForward = vDifference:Normalized()
    local fDistance = vDifference:Length()


    local tProjectileInfo = {
        Ability = self,
        EffectName = "particles/custom/mordred/sword.vpcf",
        vSpawnOrigin = hCaster:GetAbsOrigin(),
        fDistance = fDistance,
        fStartRadius = 100,
        fEndRadius = 100,
        Source = hCaster,
        bReplaceExisting = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        vVelocity = vForward * 2500,
        bProvidesVision = false,
    }
    self.Projectile = ProjectileManager:CreateLinearProjectile(tProjectileInfo)
    ParticleManager:SetParticleControlForward(self.Projectile, 1, vForward)
    hCaster:SwapAbilities("mordred_q_slash", "mordred_q_throw" , true, false)
end

function mordred_q_throw:OnProjectileThink_ExtraData(vLocation, tInfo)
    if GridNav:IsBlocked(vLocation) or not GridNav:IsTraversable(vLocation) then
        local vTarget = vLocation - self:GetCaster():GetForwardVector() * 100
        self:Charge(vTarget)
        ProjectileManager:DestroyLinearProjectile(self.Projectile)
    end
end

function mordred_q_throw:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        self:Charge(vLocation)
    else
        local hCaster = self:GetCaster()
        DoDamage(hCaster, hTarget, self:GetSpecialValueFor("damage"), DAMAGE_TYPE_PHYSICAL, 0, self, false)
    end
end

function mordred_q_throw:Charge(vLocation)
    local hCaster = self:GetCaster()
    local vPos = hCaster:GetAbsOrigin()
    local vTarget = GetGroundPosition(vLocation, hCaster)
    local vDirection = (vTarget - vPos):Normalized()

    local vCasterForward = hCaster:GetForwardVector()
    local vForward = Vector(vDirection.x, vDirection.y, vCasterForward.z)

    hCaster:SetForwardVector(vForward)
    giveUnitDataDrivenModifier(hCaster, hCaster, "pause_sealdisabled", 0.5)

    local pcSword = ParticleManager:CreateParticle("particles/custom/mordred/sword_landed.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
    ParticleManager:SetParticleControl(pcSword, 0, vTarget)
    local pcHit = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
    ParticleManager:SetParticleControl(pcHit, 0, vTarget)
    ParticleManager:ReleaseParticleIndex(pcHit)


    local fTick = 1/30
    local fSpeed = 2000 * 1/30
    local bFirst = false
    local pcSmoke = nil
    local iCounter = 0

    Timers:CreateTimer(0.5, function()
        local vPos = hCaster:GetAbsOrigin()
        local vDifference = vTarget - vPos
        local fDistance = vDifference:Length()
        local vDirection = vDifference:Normalized()
        iCounter = iCounter + 1

        if not bFirst then
            hCaster:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 0.8)
            pcSmoke = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
            bFirst = true
        end

        if fDistance <= 100 or iCounter >= 75 then
            ParticleManager:DestroyParticle(pcSword, true)
            ParticleManager:ReleaseParticleIndex(pcSword)
            ParticleManager:DestroyParticle(pcSmoke, false)
            ParticleManager:ReleaseParticleIndex(pcSmoke)
            hCaster:RemoveModifierByNameAndCaster("pause_sealdisabled", hCaster)
            hCaster:RemoveGesture(ACT_DOTA_RUN)
            FindClearSpaceForUnit(hCaster, vPos, true)
            return
        end

        local vNewPos = vPos + vDirection * fSpeed
        local vGroundPos = GetGroundPosition(vNewPos, hCaster)
        hCaster:SetAbsOrigin(vGroundPos)
        giveUnitDataDrivenModifier(hCaster, hCaster, "pause_sealdisabled", 0.2)

        local vNextPos = vPos + vDirection * fSpeed * 2

        local tTargets = FindUnitsInRadius(hCaster:GetTeam(), vNextPos, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for k, v in pairs(tTargets) do
            v:AddNewModifier(hCaster, self, "modifier_stunned", { Duration = 1 })
            FindClearSpaceForUnit(v, vNextPos, false)
        end

        return fTick
    end)
end