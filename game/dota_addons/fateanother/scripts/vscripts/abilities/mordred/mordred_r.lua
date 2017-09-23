mordred_r = class({})

function mordred_r:OnSpellStart()
    self.fRange = 0
    self.tHitTargets = {}
end

function mordred_r:OnChannelThink(fInterval)
    self.fRange = self.fRange + 400 * fInterval
end

function mordred_r:OnChannelFinish(bInterrupted)
    if self.fRange <= 400 then self:Slash() return end
    self:Dash()
end

function mordred_r:Dash()
    local hCaster = self:GetCaster()
    local fTick = 0.033
    local vForward = hCaster:GetForwardVector()
    local vTarget = hCaster:GetAbsOrigin() + vForward * self.fRange
    local fSpeed = 2400

    Timers:CreateTimer(function()
        local vNewPos = hCaster:GetAbsOrigin() + vForward * fSpeed * fTick
        self.fRange = self.fRange - fSpeed * fTick

        local vGroundPos = GetGroundPosition(vNewPos, hCaster)
        hCaster:SetAbsOrigin(vGroundPos)

        local tTargets = FindUnitsInLine(hCaster:GetTeam(), vNewPos, vNewPos + hCaster:GetRightVector() * 400, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
        for k, v in pairs(tTargets) do
            print(v:GetName())
        end

        if self.fRange <= 64 then
            return nil
        end
        
        return fTick
    end)
end

function mordred_r:Slash()
end