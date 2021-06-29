local this = {
  id = Isaac.GetItemIdByName("Smelly Pot"),
  description = "Spawns friendly dips",
  rusdescription ={""},
  isActive = true
}

function this.use()
  local player = Utils.GetPlayersItemUse() --change player get method later for proper coop support
  for i=1, math.random(1, 3) do
    player:ThrowFriendlyDip(math.random(0,6), player.Position, Vector.Zero)
  end
  Isaac.Spawn(1000, 34, 0, player.Position, vectorZero, player)
  Isaac.Spawn(1000, 43, 0, player.Position, vectorZero, player)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
