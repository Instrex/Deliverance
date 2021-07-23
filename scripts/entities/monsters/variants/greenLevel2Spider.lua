local this = {}
this.variant = Isaac.GetEntityVariantByName("lvl2.5 Spider")

function this:behaviour(npc)
  if npc:IsDead() and npc.Variant == this.variant then
    Isaac.Spawn(1000, 34, 0, npc.Position, vectorZero, npc)
    for i=1, math.random(1, 2) do
--    npc:ThrowSpider(npc.Position, npc, vectorZero, false, 0)	
--    EntityNPC.ThrowSpider(npc.Position, npc, room:FindFreePickupSpawnPosition(npc.Position, 160, true), false, 1.0)
      local rfly = Game():Spawn(18, 0, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(8), npc, 0, 1):ToNPC()
      local fly = Game():Spawn(13, 0, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(6), npc, 0, 1):ToNPC()
	  
	  rfly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	  fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, 215)
end

return this
