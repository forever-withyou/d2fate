modifier_mordred_w_active = class({})

if IsServer() then
    function modifier_mordred_w_active:OnCreated(args)
        if self:GetStackCount() == 0 then
            self:SetStackCount(1)
        end
    end

    function modifier_mordred_w_active:OnRefresh(args)
        self:IncrementStackCount()
    end

    function modifier_mordred_w_active:OnDestroy(args)
        local hParent = self:GetParent()
        local hAbility = hParent:FindAbilityByName("mordred_w")
        hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel()))
    end
end