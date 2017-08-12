mordred_q_slash = class({})
LinkLuaModifier("modifier_mordred_q", "abilities/mordred/modifier_mordred_q", LUA_MODIFIER_MOTION_NONE)

function mordred_q_slash:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDamage = self:GetSpecialValueFor("damage")
	local fStartRad = self:GetSpecialValueFor("start_radius")
	local fEndRad = self:GetSpecialValueFor("end_radius")

	local tProjectileInfo = {
		Ability = self,
        EffectName = nil,
        vSpawnOrigin = hCaster:GetAbsOrigin(),
        fDistance = 300,
        fStartRadius = 80,
        fEndRadius = 210,
        Source = hCaster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = hCaster:GetForwardVector() * 1800,
		bProvidesVision = false,
	}
	
	local projHit = ProjectileManager:CreateLinearProjectile(tProjectileInfo)
    hCaster:EmitSound("DOTA_Item.Daedelus.Crit")
	
	local pcHit = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControlForward(pcHit, 0, hCaster:GetForwardVector())
    ParticleManager:ReleaseParticleIndex(pcHit)
	
	local pcDust = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_detail.vpcf", PATTACH_ABSORIGIN, hCaster)
    ParticleManager:ReleaseParticleIndex(pcDust)
	
	hCaster:SwapAbilities("mordred_q_charge", "mordred_q_slash", true, false)
	hCaster:AddNewModifier(hCaster, self, "modifier_mordred_q", { Duration = 3 })
end

function mordred_q_slash:OnProjectileHit(hTarget, vLocation)
	if not hTarget then return end
    
	local hCaster = self:GetCaster()
	local fDamage = self:GetSpecialValueFor("damage") + hCaster:GetBaseDamageMax() * self:GetSpecialValueFor("ad_scaling")
	DoDamage(hCaster, hTarget, fDamage, DAMAGE_TYPE_PHYSICAL, 0, self, false)

    local pcBlood = ParticleManager:CreateParticle("particles/generic_gameplay/generic_hit_blood.vpcf", PATTACH_ABSORIGIN, hTarget)
    ParticleManager:ReleaseParticleIndex(pcBlood)
end

function mordred_q_slash:OnUpgrade()
	local hCaster = self:GetCaster()
	local hAbility = nil
	local tAbilities = {
		"mordred_q_charge",
		"mordred_q_leap",
        "mordred_q_throw",
	}
	
	for k, v in pairs(tAbilities) do
		hAbility = hCaster:FindAbilityByName(v)
		hAbility:SetLevel(self:GetLevel())
	end
end