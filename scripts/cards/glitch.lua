local this = {}
this.id = Isaac.GetCardIdByName("Glitch")
this.description = "Triggers random tarot card effect"

function this.getFrame() 
    if utils.chancep(35) then
        return utils.choose('gfx/items/pick ups/glitch/pickup_card_glitch2.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch3.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch4.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch5.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch6.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch7.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch8.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch9.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch10.png',
        'gfx/items/pick ups/glitch/pickup_card_glitch11.png')
    else 
        return 'gfx/items/pick ups/glitch/pickup_card_glitch1.png'
    end
end

function this.cardCallback(cardId)
    Isaac.GetPlayer(0):UseCard(math.random(1, 21))
end

if MinimapAPI then

	local minimapIcons = Sprite()
	minimapIcons:Load("gfx/ui/minimapapi/deliverance_icons.anm2", true)
	minimapIcons:Play("DeliveranceIconFarewellStoneCard", true)
	
	MinimapAPI:AddIcon(
		"DeliveranceGlitchCardIcon",
		minimapIcons,
		"DeliveranceIconGlitchCard",
		0
	)
	
	MinimapAPI:AddPickup(
		"DeliveranceGlitchCard",
		"DeliveranceGlitchCardIcon",
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