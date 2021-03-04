local this = {
	id		= Isaac.GetEntityTypeByName("Fat Hopper"),
	variant = Isaac.GetEntityVariantByName("Fat Hopper")
}

function this:behaviour(npc)
	if npc.Variant == this.variant then
	local sprite = npc:GetSprite()
		--[[if npc.State == 6 and (not sprite:IsFinished("BigJumpUp") or sprite:IsPlaying("BigJumpUp")) then
			sprite:Play("BigJumpUp")
			npc.StateFrame = 0
		elseif npc.State == 7 and sprite:IsPlaying("BigJumpDown") then
			npc.StateFrame = 40
		elseif npc.State == 4 then
			if sfx:IsPlaying(69) then
				sfx:Stop(69)
			end
			if sprite:GetFrame() < 7 and not sprite:IsEventTriggered("Jump") then
				npc.Velocity = vectorZero
				npc.StateFrame = 0
			elseif sprite:GetFrame() > 19 then
				npc.StateFrame = npc.StateFrame - Utils.choose(0,1)
			end
		end--]]
		
		if npc.State == NpcState.STATE_INIT then
      npc.State = NpcState.STATE_MOVE
    
    elseif npc.State == NpcState.STATE_MOVE then
      npc.StateFrame = npc.StateFrame + 1
      sprite:Play("Hop");
      if sprite:IsEventTriggered("Jump") then
        npc.Velocity = Vector.FromAngle(math.random(0,360)):Resized(5)
      elseif sprite:IsEventTriggered("Land") or npc.StateFrame > 18 then
        npc.Velocity = vectorZero
      end
      if npc.StateFrame == 38 then
        npc.StateFrame = 0
        npc.State = NpcState.STATE_IDLE
      end
    
  elseif npc.State == NpcState.STATE_IDLE then
      sprite:Play("Idle")
      npc.State = Utils.chance(10,NpcState.STATE_JUMP,NpcState.STATE_MOVE)
  elseif npc.State == NpcState.STATE_JUMP then
    sprite:Play("BigJumpUp")
    if sprite:IsFinished("BigJumpUp") then
      npc.State = NpcState.STATE_STOMP
      npc.StateFrame = 0
    end
  elseif npc.State == NpcState.STATE_STOMP then
    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame > 1 and npc.StateFrame < 15 then
      npc.Velocity = utils.vecToPos(npc:GetPlayerTarget().Position, npc.Position,3) + npc.Velocity
    elseif npc.StateFrame == 20 then
      sprite:Play("BigJumpDown")
    else 
      npc.Velocity = vectorZero
    end
    if sprite:IsFinished("BigJumpDown") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = 0
    end
  end
  
		
		if sprite:IsEventTriggered("Land") then
			game:ShakeScreen(5)
			sfx:Play(139, 0.8, 1, false, 0.5)
		end
		if sprite:IsEventTriggered("BigLand") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
      npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
			game:ShakeScreen(15)
			sfx:Play(52, 1, 1, false, 1)
			local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, vectorZero, npc):ToEffect()
			wave.Parent = npc
			wave.MaxRadius = 75
		end
		
    if sprite:IsEventTriggered("BigJump") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
      npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
    end
    
		if sprite:IsEventTriggered("Shoot") then
			for i=1,3 do
				local params = ProjectileParams()
				params.FallingSpeedModifier = math.random(-28, -4) 
				params.FallingAccelModifier = 1.2 

				local velocity = Vector(Utils.choose(math.random(-6, -1), math.random(1, 6)), Utils.choose(math.random(-6, -1), math.random(1, 6))):Rotated(math.random(-30, 30))
				npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
			end
		end
	end
end

function this:testrender()
	 for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if ent.Type == this.id and ent.Variant == this.variant then
			
			Isaac.RenderText("STATE FRAME ".. ent:ToNPC().StateFrame, 125, 200, 1, 1, 1, 1)
			Isaac.RenderText("STATE ".. ent:ToNPC().State, 125, 215, 1, 1, 1, 1)
		end
	end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  --mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.testrender)
end

return this
