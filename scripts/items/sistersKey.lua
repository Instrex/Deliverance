local this = {}
this.id = Isaac.GetItemIdByName("Sister's Key")

function this.use()
  for e, entity in pairs(Isaac.GetRoomEntities()) do
    if entity.Type == EntityType.ENTITY_PICKUP
    and entity.Variant == PickupVariant.PICKUP_LOCKEDCHEST or entity.Variant == PickupVariant.PICKUP_CHEST
    or entity.Variant == PickupVariant.PICKUP_SPIKEDCHEST or entity.Variant == PickupVariant.PICKUP_ETERNALCHEST
    or entity.Variant == PickupVariant.PICKUP_REDCHEST or entity.Variant == PickupVariant.PICKUP_BOMBCHEST
    and entity.SubType ~= ChestSubType.CHEST_CLOSED then
      SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 0.8, 0, false, 1)
      entity:ToPickup():TryOpenChest()
    end
  end

  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
