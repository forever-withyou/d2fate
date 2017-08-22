Wrappers = {}

function Wrappers.WrapUnit(hUnit)
	-- Heals
	function hUnit:ApplyHeal(fAmount, hSource, ...)
		local fHeal = fAmount
		local fMaxHealth = hUnit:GetMaxHealth()
		local fCurrentHealth = hUnit:GetHealth()
			
		if fCurrentHealth == fMaxHealth then
			fHeal = 0
		elseif fCurrentHealth + fAmount > fMaxHealth then
			fHeal = fMaxHealth - fCurrentHealth
		end
		
		local tModifiers = hUnit:FindAllModifiers()
		
		for k, v in pairs(tModifiers) do
			if v.OnHeal then
				v:OnHeal(fAmount, fHeal, hSource)
			end
			
			if v.DisableHeal then
				if v:DisableHeal() then return end
			end
		end
		
		hUnit:Heal(fAmount, hSource)
	end
	
	-- Execution
	function hUnit:Execute(hAbility, hKiller, tParams)
		local tParams = tParams or {}
		local bExecution = tParams.bExecution or false
		local tModifiers = hUnit:FindAllModifiers()
	
		for k, v in pairs(tModifiers) do
			if v.OnKill then
				v:OnKill(hAbility, hKiller)
			end
			
			if bExecution then
				if v.BlockExecute then
					if v:BlockExecute() then return end
				end
			end
		end
		
		hUnit:Kill(hAbility, hKiller)
	end
end

-- Wrapper for modifier stuff
function Wrappers.Modifier(hModifier, bIsDebuff, tParams)
    --[[ tParams values:
                eAttributes
                bIsHidden
                bBlockExecute
                bDisableHeal
                tProperties
                tStates
                sEffectName
                eEffectAttachType
                sStatusEffectName
                sTexture
                bIsAura
                sModifierAura   <-- required if bIsAura is true
                bIsAuraActiveOnDeath
                fAuraRadius
                tAuraEntityReject
                eAuraSearchType
                eAuraSearchFlags
                eAuraSearchTeam
    ]]
    
    if tParams.eAttributes then
        function hModifier:GetAttributes()
            return tParams.eAttributes
        end
    end
    
    function hModifier:IsDebuff()
        return bIsDebuff
    end
    
    if tParams.bBlockExecute ~= nil then
        function hModifier:BlockExecute()
            return tParams.bBlockExecute
        end
    end
    
    if tParams.bDisableHeal ~= nil then
        function hModifier:DisableHeal()
            return tParams.bDisableHeal
        end
    end

    if tParams.bIsHidden ~= nil then
        function hModifier:IsHidden()
            return tParams.bIsHidden
        end
    end
    
    if tParams.tProperties then
        function hModifier:DeclareFunctions()
            return tParams.tProperties
        end
    end
    
    if tParams.tStates then
        function hModifier:CheckState()
            return tParams.tStates
        end
    end
    
    if tParams.sEffectName then
        function hModifier:GetEffectName()
            return tParams.sEffectName
        end

        function hModifier:GetEffectAttachType()
            return tParams.eEffectAttachType or PATTACH_ABSORIGIN_FOLLOW
        end
    end
    
    if tParams.sTexture then
        function hModifier:GetTexture()
            return tParams.sTexture
        end
    end

    if tParams.sStatusEffectName then
        function hModifier:GetStatusEffectName()
            return tParams.sStatusEffectName
        end
    end

    if tParams.bIsAura == true then
        function hModifier:IsAura()
            return tParams.bIsAura
        end

        function hModifier:GetModifierAura()
            return tParams.sModifierAura
        end

        function hModifier:IsAuraActiveOnDeath()
            return tParams.bIsAuraActiveOnDeath or false
        end

        function hModifier:GetAuraRadius()
            return tParams.fAuraRadius or 1000
        end

        if tParams.tAuraEntityReject then
            function hModifier:GetAuraEntityReject(hEntity)
                for k, v in pairs(tParams.tAuraEntityReject) do
                    if hEntity:GetUnitName() == v then
                        return true
                    else
                        return false
                    end
                end
            end
        end

        function hModifier:GetAuraSearchType()
            return tParams.eAuraSearchType or DOTA_UNIT_TARGET_ALL
        end

        function hModifier:GetAuraSearchFlags()
            return tParams.eAuraSearchFlags or DOTA_UNIT_TARGET_FLAG_NONE
        end

        function hModifier:GetAuraSearchTeam()
            return tParams.eAuraSearchTeam or DOTA_UNIT_TARGET_TEAM_FRIENDLY
        end
    end
end