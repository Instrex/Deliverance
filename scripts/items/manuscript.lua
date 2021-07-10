local this = {}
this.id = Isaac.GetItemIdByName("The Manuscript")
this.description = "Gives half of an soul heart each time you use a card/rune"
this.rusdescription ={"The Manuscript /Манускрипт", "Дает половину сердца души за каждую использованную карту/руну"}

function this:useCard(card)
  local player = Utils.GetPlayersItemUse()
  if player:HasCollectible(this.id) then
    if CommunityRemixRemixed then
		if card == p20Card.DONKEYS_JAWBONE or card == p20Card.APPLE_RED or card == p20Card.APPLE_WHITE or card == p20Card.APPLE_DOUBLE_RED or card == p20Card.APPLE_DOUBLE_WHITE or card == p20Card.APPLE_DOUBLE_REDWHITE or card == p20Card.APPLE_BLENDED or card == p20Card.APPLE_GOLDEN  then -- CRR compatibility
      return false
	  end
    end

     player:AddSoulHearts(1)
     local heart = Isaac.Spawn(1000, 49, 0, Vector(player.Position.X,player.Position.Y-64), vectorZero, nil)
     heart:GetSprite():ReplaceSpritesheet(0,"gfx/effects/hearteffect3.png")
     heart:GetSprite():LoadGraphics()
     sfx:Play(Isaac.GetSoundIdByName("Spawn"), 1.2, 0, false, 1.1)
  end
end

function this:dropCard(player)
  local data = player:GetData()
  data.cardPickup = data.cardPickup or player:GetCollectibleNum(this.id)

  if data.cardPickup < player:GetCollectibleNum(this.id) then
      Isaac.Spawn(5, 300, 0, Isaac.GetFreeNearPosition(player.Position, 1), Vector.FromAngle(math.random(360)):Resized(2.5), player)
      data.cardPickup = player:GetCollectibleNum(this.id)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_CARD, this.useCard)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.dropCard)
end

return this
 