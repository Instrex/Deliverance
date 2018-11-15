local this = {}
this.id = Isaac.GetItemIdByName("The Apple")

function this.use()
  local player = Isaac.GetPlayer(0)
  player:UsePill(PillEffect.PILLEFFECT_FULL_HEALTH, -1)
  SFXManager():Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 0.8)
  Isaac.Spawn(5, 350, Isaac.GetTrinketIdByName("Apple Core"), Isaac.GetFreeNearPosition(player.Position, 1), Vector(0, 0), Isaac.GetPlayer(0));
  player:RemoveCollectible(this.id)
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
