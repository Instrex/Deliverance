local this = {}
this.id = Isaac.GetCardIdByName("Mannaz")
this.description = "Replaces all of your red hearts with twice amount of soul hearts"

function this:cardCallback(cardId)
  local player = Isaac.GetPlayer(0)
  if cardId == this.id then
    hearts = player:GetMaxHearts()
    player:AddSoulHearts(hearts * 2)
    player:AddMaxHearts(0 - hearts)
    sfx:Play(SoundEffect.SOUND_HOLY , 1, 0, false, 1.05)
  end
end

function this:mannazSprite()
  for i,card in pairs(Isaac.GetRoomEntities()) do
    if card.Type == EntityType.ENTITY_PICKUP and card.Variant == PickupVariant.PICKUP_TAROTCARD and card.SubType == this.id then
      local spr = card:GetSprite()
      spr:ReplaceSpritesheet(0,"gfx/items/pick ups/pickup_card.png")
      spr:LoadGraphics()
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.mannazSprite)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.mannazSprite)
end

return this
