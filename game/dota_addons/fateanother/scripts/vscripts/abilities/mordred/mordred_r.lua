mordred_r = class({})

function mordred_r:OnSpellStart()
    self.fRange = 0
    self.fDamage = 0
    self.fDrained = 0
    self.tHitTargets = {}
end

function mordred_r:OnChannelThink(fInterval)
    local hCaster = self:GetCaster()
    local fDrain = self:GetSpecialValueFor("mana_cost") * fInterval
    hCaster:SpendMana(fDrain, self)
    self.fDrained = self.fDrained + fDrain
end

function mordred_r:OnChannelFinish(bInterrupted)
    local hCaster = self:GetCaster()
    local fChanneled = GameRules:GetGameTime() - self:GetChannelStartTime()
    if fChanneled < 1 then
        self:EndCooldown()
        hCaster:GiveMana(self.fDrained + self:GetManaCost(-1))
        return
    end

    local fDistance = self:GetSpecialValueFor("max_distance")
    local fChannelTime = self:GetChannelTime()
    local fDelay = self:GetSpecialValueFor("delay")
    local fMinDamage = self:GetSpecialValueFor("min_damage")
    local fMaxDamage = self:GetSpecialValueFor("max_damage")
    local fDamageDiff = fMaxDamage - fMinDamage

    self.fRange = fDistance * (fChanneled / fChannelTime)
    self.fDamage = fMinDamage + (fDamageDiff * ((fChanneled - fDelay) / (fChannelTime - fDelay)))
    self:Dash()
end

function mordred_r:Dash()
    local hCaster = self:GetCaster()
    local fTick = 0.033
    local vForward = hCaster:GetForwardVector()
    local vTarget = hCaster:GetAbsOrigin() + vForward * self.fRange
    local fSpeed = 2400
    local fPause = self.fRange / fSpeed
    local fAttackRange = self:GetSpecialValueFor("range")

    giveUnitDataDrivenModifier(hCaster, hCaster, "pause_sealdisabled", fPause)

    Timers:CreateTimer(function()
        local vNewPos = hCaster:GetAbsOrigin() + vForward * fSpeed * fTick
        local vAttack = vNewPos + hCaster:GetRightVector() * fAttackRange
        self.fRange = self.fRange - fSpeed * fTick
        local vGroundPos = GetGroundPosition(vNewPos, hCaster)

        if self.fRange <= 64 then
            FindClearSpaceForUnit(hCaster, hCaster:GetAbsOrigin(), true)
            self:Slash()
            return nil
        end

        hCaster:SetAbsOrigin(vGroundPos)
        self:Damage(vNewPos, vAttack)

        -- Debug line, remember to remove this.
        DebugDrawLine(vNewPos, vAttack, 255, 0,0,false, 1)
        
        return fTick
    end)
end

function mordred_r:Slash()
    local hCaster = self:GetCaster()
    local fTick = 0.033
    local fTurnRate = 180 * fTick * 3
    local fTurn = 0
    local vRight = hCaster:GetRightVector()
    local oAngles = hCaster:GetAngles()
    Timers:CreateTimer(function()
        fTurn = fTurn + fTurnRate
        local vAttack = hCaster:GetAbsOrigin() + RotatePosition(Vector(0,0,1), QAngle(oAngles.x, fTurn, oAngles.z), vRight) * 400
        -- Debug line, remember to remove this.
        DebugDrawLine(hCaster:GetAbsOrigin(), vAttack, 255,0,0,false,1)

        if fTurn >= 180 then return nil end

        self:Damage(hCaster:GetAbsOrigin(), vAttack)

        return fTick
    end)
end

function mordred_r:Damage(vPos, vPos2)
    local hCaster = self:GetCaster()
    local tTargets = FindUnitsInLine(hCaster:GetTeam(), vPos, vPos2, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
    for k, v in pairs(tTargets) do
        if self.tHitTargets[k] ~= v then
            self.tHitTargets[k] = v
            DoDamage(hCaster, v, self.fDamage, DAMAGE_TYPE_PHYSICAL, 0, self, false)
        end
    end
end