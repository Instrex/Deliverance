local this = {}
this.id = Isaac.GetCardIdByName("Glitch")
this.effect = Isaac.GetEntityVariantByName("Urn of Want Effect")
this.description = "%D@#$FHFXZQ@@*@)"
this.rusdescription ={"Glitch /Ãëþê", "%D@#$FHFXZQ@@*@"}
--[[function this.getFrame() 
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
end--]]

function this:updateEffect(npc)
 if npc.Variant == this.effect then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    sprite:Play("Idle")
    
    if sprite:IsFinished("Idle") then 
      npc:Remove()
    end
  end
end

function this.cardCallback()
  local player = Isaac.GetPlayer(0)
   local effect = Isaac.Spawn(1000, this.effect, 0, player.Position, vectorZero, nil)
   sfx:Play(Isaac.GetSoundIdByName("Urn"), 1, 0, false, 1)
   player:UseActiveItem(97,false,false,false,false)
   if utils.chancep(50) then 
       player:UseActiveItem(97,false,false,false,false)
   end
   if utils.chancep(50) then
       player:UseCard(Utils.choose(Card.CARD_EMPRESS,Card.CARD_HANGED_MAN,Card.CARD_DEVIL,Card.CARD_TOWER,
                               Card.CARD_JUDGEMENT,Card.CARD_CLUBS_2,Card.CARD_SPADES_2,Card.CARD_HEARTS_2,
                               Card.CARD_ACE_OF_CLUBS,Card.CARD_ACE_OF_DIAMONDS,Card.CARD_ACE_OF_SPADES,Card.CARD_ACE_OF_HEARTS)
       )
   else
       player:UsePill(Utils.choose(PillEffect.PILLEFFECT_BOMBS_ARE_KEYS,PillEffect.PILLEFFECT_PUBERTY,PillEffect.PILLEFFECT_RANGE_DOWN,
                               PillEffect.PILLEFFECT_RANGE_UP,PillEffect.PILLEFFECT_SPEED_DOWN,PillEffect.PILLEFFECT_SPEED_UP,
                               PillEffect.PILLEFFECT_TEARS_DOWN,PillEffect.PILLEFFECT_TEARS_UP,PillEffect.PILLEFFECT_LUCK_DOWN,
                               PillEffect.PILLEFFECT_LUCK_UP,PillEffect.PILLEFFECT_BAD_GAS),0)
   end
   return true
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
		"deliverancecards",
		1040
	) 
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
    mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateEffect)
end

return this