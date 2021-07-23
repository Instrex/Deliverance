local this = {}
this.variant = Isaac.GetEntityVariantByName("lvl2.5 Fly")

function this:behaviour(npc)
  local room = game:GetRoom()
  if npc:IsDead() and npc.Variant == this.variant then
    Isaac.Spawn(1000, 34, 0, npc.Position, vectorZero, npc)
    for i=1, math.random(2, 3) do
--    npc:ThrowSpider(npc.Position, npc, vectorZero, false, 0)	
      EntityNPC.ThrowSpider(npc.Position, npc, room:FindFreePickupSpawnPosition(npc.Position, 160, true), false, 1.0)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, 214)
end

return this
