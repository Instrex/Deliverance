local this = {}
this.id = Isaac.GetItemIdByName("Golden Apple")

function this.use()
  local player = Isaac.GetPlayer(0)
  player:AddHearts(20)
  player:RemoveCollectible(this.id)

  SFXManager():Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 0.8)
  Isaac.Spawn(5, 350, deliveranceContent.trinkets.appleCore.id, Isaac.GetFreeNearPosition(player.Position, 1), Vector(0, 0), player);

  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
