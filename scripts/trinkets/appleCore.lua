local this = {}
this.id = Isaac.GetTrinketIdByName("Apple Core")
this.description = "Chance to restore all health when taking damage (only once)"

function this.trigger(id)
  local player = Isaac.GetPlayer(0)
  if player:HasTrinket(this.id) then
    if utils.chance(8) then
      sfx:Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 0.8)
      player:AddHearts(20)
      player:TryRemoveTrinket(this.id)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
end

return this
