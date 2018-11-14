local this = {}
this.id = Isaac.GetTrinketIdByName("Krampus' Horn")

function this.trigger(id)
  local player = Isaac.GetPlayer(0)
  if player:HasTrinket(this.id) then
    if utils.chance(8) then
      player:UseActiveItem(CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS, false, false, false, false)
      player:TryRemoveTrinket(this.id)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
end

return this
