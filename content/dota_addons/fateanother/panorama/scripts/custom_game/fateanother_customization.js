// Set up global variables
var g_GameConfig = FindCustomUIRoot($.GetContextPanel());
//g_GameConfig.curBGMentindex = 0;
g_GameConfig.curBGMIndex = 1;
g_GameConfig.nextBGMIndex = 1;
g_GameConfig.BGMSchedule = 0;
g_GameConfig.duration = [186,327,138,149,183,143,184,181];
//g_GameConfig.duration = [5,5,5,5,5,5,5,5];
g_GameConfig.bRepeat = false;
g_GameConfig.bIsBGMOn = true;
g_GameConfig.bIsAutoChange = false;

g_GameConfig.bIsConfig1On = false;
g_GameConfig.bIsConfig2On = false;
g_GameConfig.bIsConfig3On = false;
g_GameConfig.bIsConfig4On = false;

function GetTalentButton()
{
	var root = GetHUDRootUI();
	var talentButton = root.FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block").FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch");
	return talentButton;
}

function OnCustomizeButtonPressed()
{
    var customizePanel = $("#CustomizationBoard");
	var customizePanelLabel = $("#CustomizationBoardLabel");
    if (!customizePanel)
        return;

    customizePanel.visible = !customizePanel.visible;
	customizePanelLabel.visible = customizePanel.visible;
}

function CreateFateTalentButton(){
	var fateButton = GetTalentButton()
	
	fateButton.SetPanelEvent("onmouseover", OnCustomizeButtonShowTooltip);
	fateButton.SetPanelEvent("onmouseout", OnCustomizeButtonHideTooltip);
	fateButton.SetPanelEvent("onactivate", OnCustomizeButtonPressed);
	
	var statBranchGraphics = fateButton.FindChildTraverse("StatBranchGraphics")
	statBranchGraphics.style.visibility = "collapse";
	
	var statBranchBG = fateButton.FindChildTraverse("StatBranchBG")
	statBranchBG.style.visibility = "collapse";
	
	fateButton.style.backgroundImage = "url(\"file://{images}/misc/customize.png\")";
}

function RemoveChilds(panel)
{
	for (i=0;i<panel.GetChildCount(); i++)
	{
		panel.GetChild(i).RemoveAndDeleteChildren();
	}
}

function UpdateAttributeList(data)
{
	$.Msg("updating attribute list")
	var attributePanel = $("#CustomizationAttributeLayout");
	var statPanel = $("#CustomizationStatLayout");
	var cooldownPanel = $("#CustomizationCooldownLayout");
	var shardPanel = $("#CustomizationShardLayout");
	if (!attributePanel || !statPanel || !shardPanel)
		return;

	//$.Msg("panels present. linking abilities...")
	var queryUnit = data.masterUnit; //Players.GetLocalPlayerPortraitUnit();
	var queryUnit2 = data.shardUnit
	var tAttributes = data.tAttributes;
	var iAttributes = data.iAttributes + 1;
	
	var tStats = [
		"master_strength",
		"master_agility",
		"master_intelligence",
		"master_damage",
		"master_armor",
		"master_health_regen",
		"master_mana_regen",
		"master_movement_speed"
	];
	
	var tShards = [
		"master_shard_of_avarice",
		"master_shard_of_anti_magic",
		"master_shard_of_replenishment",
		"master_shard_of_prosperity"
	];
	
	for(var i = 1; i < iAttributes; i++){
		CreateAbilityPanelByName(attributePanel, queryUnit, tAttributes[i], true)
	}
	
	CreateAbilityPanelByName(cooldownPanel, queryUnit, tAttributes[iAttributes], true);
	
	for(var i = 0; i < tStats.length; i++){
		CreateAbilityPanelByName(statPanel, queryUnit, tStats[i], true)
	}
	
	for(var i = 0; i < tShards.length; i++){
		CreateAbilityPanelByName(shardPanel, queryUnit2, tShards[i], true)
	}
}


// create an ability context button, which does not reference existing ability of unit
function CreateContextAbilityPanel(panel)
{
	var abilityPanel = $.CreatePanel("Panel", panel, "");
	abilityPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_context_ability.xml", false, false );
}

function UpdateStatPanel(data)
{
	$("#STRAmount").text = data.STR + " / 50";
	$("#AGIAmount").text = data.AGI +  " / 50";
	$("#INTAmount").text = data.INT +  " / 50";
	$("#DMGAmount").text = data.DMG +  " / 50";
	$("#ARMORAmount").text = data.ARMOR +  " / 50";
	$("#HPREGAmount").text = data.HPREG +  " / 50";
	$("#MPREGAmount").text = data.MPREG +  " / 50";
	$("#MSAmount").text = data.MS +  " / 50";
	$("#CustomizationShardNumber").text = data.ShardAmount;
}

function OnCustomizeButtonShowTooltip()
{
	var panel = GetTalentButton()
	panel.style.backgroundImage = "url(\"file://{images}/misc/customize_active.png\")";
	$.DispatchEvent('DOTAShowTextTooltip', panel, "#Fateanother_Customize_Button");
}

function OnCustomizeButtonHideTooltip(panel)
{
	var panel = GetTalentButton()
	panel.style.backgroundImage = "url(\"file://{images}/misc/customize.png\")";
	$.DispatchEvent( 'DOTAHideTextTooltip', panel );
}


function AttributeShowTooltip()
{
	var attrText = $("#CustomizationAttributeText");
	$.DispatchEvent('DOTAShowTextTooltip', attrText, "#Fateanother_Customize_Attributes_Tooltip");
}

function AttributeHideTooltip()
{
	var attrText = $("#CustomizationAttributeText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', attrText );
}

function StatShowTooltip()
{
	var statText = $("#CustomizationStatText"); 
	$.DispatchEvent( 'DOTAShowTextTooltip', statText, "#Fateanother_Customize_Stats_Tooltip");
}

function StatHideTooltip()
{
	var statText = $("#CustomizationStatText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', statText );
}

function ComboShowTooltip()
{
	var comboText = $("#CustomizationComboText"); 
	$.DispatchEvent( 'DOTAShowTextTooltip', comboText, "#Fateanother_Customize_Special_Cooldowns_Tooltip");
}

function ComboHideTooltip()
{
	var comboText = $("#CustomizationComboText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', comboText );
}

function ShardShowTooltip()
{
	var shardText = $("#CustomizationShardText"); 
	$.DispatchEvent( 'DOTAShowTextTooltip', shardText, "#Fateanother_Customize_Special_Shards_Tooltip");
}
function ShardHideTooltip()
{
	var shardText = $("#CustomizationShardText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', shardText );
}
function PrintToClient(data)
{
	$.Msg(data.text);
}

function CreateErrorMessage(msg){
    var reason = msg.reason || 80;
    if (msg.message){
        GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":reason ,"message":msg.message} );
    }
    else{
        GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":reason} );
    }
}

(function()
{
    //$.RegisterForUnhandledEvent( "DOTAAbility_LearnModeToggled", OnAbilityLearnModeToggled);

	//GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_ability_changed", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateAbilityList );
	GameUI.SetCameraDistance(1600);
	GameEvents.Subscribe( "player_selected_hero", UpdateAttributeList);
	GameEvents.Subscribe( "servant_stats_updated", UpdateStatPanel );
	GameEvents.Subscribe( "error_message_fired", CreateErrorMessage)
	GameEvents.Subscribe( "player_chat_lua", PrintToClient );
	OnCustomizeButtonPressed();
	CreateFateTalentButton();
})();