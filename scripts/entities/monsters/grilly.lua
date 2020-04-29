local this = {}
this.id = Isaac.GetEntityTypeByName("Grilly")
this.variant = Isaac.GetEntityVariantByName("Grilly")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
   
  if data.RealHp == nil then data.RealHp = npc.HitPoints end

  npc:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)
  end
  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, -5, 0)
    if data.GridCountdown == nil then data.GridCountdown = 0 end
	
  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_ATTACK then
    
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
    if not target:IsDead() then 
       if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          npc.Pathfinder:FindGridPath(target.Position, 1, false)
          if data.GridCountdown <= 0 then
              data.GridCountdown = 30
          else
              data.GridCountdown = data.GridCountdown - 1
          end
       else
          npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.15 + npc.Velocity * 1
       end
    end
end
end

return this