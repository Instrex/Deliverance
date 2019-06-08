local this = {}
this.id = Isaac.GetTrinketIdByName("Uncertainty")
this.description = "Changes your stats each time you take damage"

function this.trigger()
  local player = Isaac.GetPlayer(0)
  if player:HasTrinket(this.id) then
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D8, false, false, false, false)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
end

return this
