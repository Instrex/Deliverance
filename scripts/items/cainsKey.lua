local this = {}
this.id = Isaac.GetItemIdByName("Cain's Lost Key")
this.description = "Opens all chests in the room"
this.rusdescription ={"Cain's Lost Key /Потерянный ключ Каина", "Открывает все сундуки в комнате"}
this.isActive = true

function this.use()
  sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 0.8, 0, false, 1)
  for _, entity in pairs(Isaac.GetRoomEntities()) do
    if entity.Type == EntityType.ENTITY_PICKUP then
      if entity.Variant == PickupVariant.PICKUP_LOCKEDCHEST or entity.Variant == PickupVariant.PICKUP_CHEST or entity.Variant == PickupVariant.PICKUP_SPIKEDCHEST 
      or entity.Variant == PickupVariant.PICKUP_ETERNALCHEST or entity.Variant == PickupVariant.PICKUP_REDCHEST or entity.Variant == PickupVariant.PICKUP_BOMBCHEST 
      or entity.Variant == PickupVariant.PICKUP_MIMICCHEST or entity.Variant == PickupVariant.PICKUP_OLDCHEST or entity.Variant == PickupVariant.PICKUP_WOODENCHEST
      or entity.Variant == PickupVariant.PICKUP_MEGACHEST or entity.Variant == PickupVariant.PICKUP_HAUNTEDCHEST then
        --if entity.SubType ~= ChestSubType.CHEST_CLOSED then
           entity:ToPickup():TryOpenChest()
        --end
      end
    end
  end

--  local room = game:GetRoom()

--  for i = 1, Game():GetRoom():GetGridSize() do
--    local grid = room:GetGridEntity(i)
--    if grid and grid.Desc.Type==14 then room:DestroyGrid(i, false) end
--  end

  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
