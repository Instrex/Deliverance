local this = {}
this.id = Isaac.GetItemIdByName("Golden Apple")
this.description = "Fully restores health, then turns into Apple core"
this.rusdescription ={"Golden Apple /Золотое яблоко", "Полностью восстанавливает здоровье, затем превращается в огрызок"}

function this.use()
  local player = Utils.GetPlayersItemUse()
  player:AddHearts(20)
  player:RemoveCollectible(this.id)

  sfx:Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 0.8)
  Isaac.Spawn(5, 350, deliveranceContent.trinkets.appleCore.id, Isaac.GetFreeNearPosition(player.Position, 1), vectorZero, player);

  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
