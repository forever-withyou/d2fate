mordred_w = class({})
LinkLuaModifier( "modifier_mordred_w", "abilities/mordred/modifier_mordred_w", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mordred_w_active", "abilities/mordred/modifier_mordred_w_active", LUA_MODIFIER_MOTION_NONE )

function mordred_w:OnSpellStart()
    local hCaster = self:GetCaster()
    local iDashes = self:GetSpecialValueFor("dashes")
    local fRange = self:GetSpecialValueFor("dash_range")
    self:EndCooldown()

    local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_mordred_w_active", { Duration = 5 })
    local iStacks = hModifier:GetStackCount()
    if iStacks == iDashes then
        hModifier:Destroy()
    end

    self:Dash(fRange)
end

function mordred_w:Dash(fRange)
    local hCaster = self:GetCaster()
    local fRemainingRange = fRange
    local fTick = 1/30
    local fSpeed = 2000 * fTick

    hCaster:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 0.8)
    self.bIsDashing = true
    self.pcBlast = ParticleManager:CreateParticle("particles/econ/events/ti6/force_staff_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)

    Timers:CreateTimer(function()
        local vPosition = hCaster:GetAbsOrigin()
        local vForward = hCaster:GetForwardVector() 
        local vVector = vForward * fSpeed
        fRemainingRange = fRemainingRange - vVector:Length()
        
        if fRemainingRange <= 0 then
            self:EndDash()
            return
        end

        local vNextPos = vPosition + vVector
        local vGroundPos = GetGroundPosition(vNextPos, hCaster)

        if GridNav:IsBlocked(vGroundPos) or not GridNav:IsTraversable(vGroundPos) then
            FindClearSpaceForUnit(hCaster, vGroundPos, true)
            self:EndDash()
            return
        end


        hCaster:SetAbsOrigin(vGroundPos)
        return fTick
    end)
end

function mordred_w:EndDash()
    local hCaster = self:GetCaster()
    self.bIsDashing = false
    hCaster:RemoveGesture(ACT_DOTA_RUN)
    FindClearSpaceForUnit(hCaster, hCaster:GetAbsOrigin(), true)
    ParticleManager:DestroyParticle(self.pcBlast, false)
    ParticleManager:ReleaseParticleIndex(self.pcBlast)
end

function mordred_w:CastFilterResult()
    if self.bIsDashing then
        return UF_FAIL_CUSTOM
    end

    return UF_SUCCESS
end

function mordred_w:GetCustomCastError()
    return "Can't do that"
end

function mordred_w:GetIntrinsicModifierName()
    return "modifier_mordred_w"
end