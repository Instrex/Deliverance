local this = {}
this.id = Isaac.GetItemIdByName("Gasoline")

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      Isaac.Spawn(1000, 45, 0, npc.Position, Vector(0, 0), player)
      Isaac.Spawn(1000, 51, 0, npc.Position, Vector(0, 0), player)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH , this.onHitNPC)
end

return this
