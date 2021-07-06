local this = {}
this.id = Isaac.GetTrinketIdByName("Uncertainty")
this.description = "Changes your stats each time you take damage"
this.rusdescription ={"Uncertainty /Ќеопределенность", "»змен€ет характеристики персонажа каждый раз, когда он получает урон"}

function this.trigger(_,player)
  player = player:ToPlayer()
  if player:HasTrinket(this.id) then
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D8, false, false, false, false)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
end

return this
