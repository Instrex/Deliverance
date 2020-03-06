local this = {}
this.id = Isaac.GetCardIdByName("FarewellStone")
this.description = "Turns your red hearts into souls hearts in a 1:2 ratio#Grants 1 soul heart if you have no red hearts"

function this:cardCallback(cardId)
    local player = Isaac.GetPlayer(0)
    local hearts = player:GetMaxHearts()
    player:AddSoulHearts(math.max(2, hearts * 2))
    player:AddMaxHearts(0 - hearts)
    sfx:Play(SoundEffect.SOUND_HOLY, 1, 0, false, 1.05)
end

if MinimapAPI then

	local minimapIcons = Sprite()
	minimapIcons:Load("gfx/ui/minimapapi/deliverance_icons.anm2", true)
	minimapIcons:Play("DeliveranceIconFarewellStoneCard", true)
	
	MinimapAPI:AddIcon(
		"DeliveranceFarewellStoneCardIcon",
		minimapIcons,
		"DeliveranceIconFarewellStoneCard",
		0
	)
	
	MinimapAPI:AddPickup(
		"DeliveranceFarewellStoneCard",
		"DeliveranceFarewellStoneCardIcon",
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_TAROTCARD,
		this.id,
		MinimapAPI.PickupNotCollected,
		"deliveranvecards",
		1040
	)
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
end

return this
