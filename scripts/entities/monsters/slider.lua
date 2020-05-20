local this = {}
this.id = Isaac.GetEntityTypeByName("Slider")
this.variant = Isaac.GetEntityVariantByName("Slider")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
  local path = npc.Pathfinder

  npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
  npc.Velocity = vectorZero

  -- Begin --
   if npc.State == NpcState.STATE_INIT then
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    npc.State = NpcState.STATE_IDLE
    npc.StateFrame = Utils.choose(-24, -6, 12)
  
  -- Seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then
    sprite:Play("Idle");
	if npc.Position:Distance(target.Position) <= 150 then
	 npc.State = utils.choose(NpcState.STATE_ATTACK)
    end
	
 elseif npc.State == NpcState.STATE_ATTACK then
 
      sprite:Play("Attack") 
      if sprite:IsEventTriggered("Shoot") then
          npc.Velocity = vectorZero
		  path:FindGridPath(target.Position, 0.1, 0, true)
		  local params = ProjectileParams() 
		      params.BulletFlags = ProjectileFlags.CREEP_BROWN 			
	        params.FallingSpeedModifier = 0
           params.FallingAccelModifier = 0
	     velocity = (target.Position - npc.Position), Vector.FromAngle(0)
        velocity = (target.Position - npc.Position), Vector.FromAngle(40)
       velocity = (target.Position - npc.Position), Vector.FromAngle(80)
	  npc:FireProjectiles(npc.Position + utils.vecToPos(target.Position, npc.Position, 0), velocity, 0, params)
         end
	    if sprite:IsFinished("Attack") then 
	    npc.State = 400 end
		elseif npc.State == 400 then
        npc.StateFrame = npc.StateFrame + 1
        sprite:Play("JumpUp")
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        if sprite:IsEventTriggered("CantBeDamaged") then
            sfx:Play(215, 1,0, false, 1)
        end
        if sprite:IsPlaying("JumpUp") then
        end
        if sprite:IsFinished("JumpUp") then
            npc.Position = room:FindFreePickupSpawnPosition((target.Position+Vector(Utils.choose(-150, 150),Utils.choose(-150, 150))), 75, true)
            npc.State = 401
        end
    elseif npc.State == 401 then
        sprite:Play("JumpDown")
        if sprite:IsEventTriggered("CanBeDamaged") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            sfx:Play(214, 1,0, false, 1)
        end
        if sprite:IsFinished("JumpDown") then
            npc.State = NpcState.STATE_IDLE
			npc.StateFrame = Utils.choose(-24, -6, 12)
         end
      end
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this