local this = {}
this.id = Isaac.GetCardIdByName("Mannaz")

function this:cardCallback(cardId)
  local player = Isaac.GetPlayer(0)
  if cardId == this.id then
    hearts = player:GetMaxHearts()
    player:AddSoulHearts(hearts * 2)
    player:AddMaxHearts(0 - hearts)
    SFXManager():Play(SoundEffect.SOUND_HOLY , 1, 0, false, 1.1)
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

function this:mannazOnRoomStart()
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
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.mannazOnRoomStart)
end

return this
