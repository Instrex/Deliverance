local this = {
	id		= Isaac.GetEntityTypeByName("Golden Keeper"),
	variant = Isaac.GetEntityVariantByName("Golden Keeper")
}

function this:behaviour(npc)
  if npc.Variant == this.variant then
	local sprite = npc:GetSprite()
	local data = npc:GetData()
	local target = npc:GetPlayerTarget()
	local room = game:GetRoom()
	
   -- Пиздец --
    if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
	 npc.StateFrame = Utils.choose(0, 10, 20)
    end
      if npc.State == NpcState.STATE_MOVE then
         sprite:Play("JumpDown")  
      if sprite:IsEventTriggered("Jump") then
         npc.Velocity = Vector.FromAngle(math.random(0,360)):Resized(5) 
      elseif sprite:IsEventTriggered("Land") then
	     npc.Velocity = vectorZero
         sfx:Play(139, 0.8, 1, false, 0.5)
	  elseif sprite:IsFinished("JumpDown") then
	     sprite:Play("Down")
	   end
      end	  	 
      if npc.Position:Distance(target.Position) <= 200 then
         npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
      end
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
	  if npc.StateFrame >= 100 then
		npc.State = NpcState.STATE_ATTACK
	  end
      if npc.State == NpcState.STATE_ATTACK then
         npc.Velocity = vectorZero
         sprite:Play("ShootDown")
        end
	  if sprite:IsEventTriggered("Shoot") then
         npc.Velocity = vectorZero
		 sfx:Play(319, 1, 0, false, 1)
         for i=1, 4 do
             Isaac.Spawn(9, 7, 0, Vector(npc.Position.X,npc.Position.Y + 2), (utils.vecToPos(target.Position, npc.Position) * 10):Rotated(-30+i*12), npc)
		     Game():SpawnParticles(npc.Position, 95, 1, 4, Color(1.1,1,1,1,0,0,0), -10)
		 
           end
	  end
	  if sprite:IsFinished("ShootDown") then
	     npc.State = NpcState.STATE_MOVE
		 npc.StateFrame = Utils.choose(0, 10, 20)
	   end
	   
	  if npc:IsDead() then
		npc:PlaySound(427, 1, 0, false, 2)
		Isaac.Spawn(1000, 357, 0, npc.Position, Vector(0,0), npc)
		for i=0, 6, 2 do
		  Isaac.Spawn(1000, 97, 0, npc.Position, vectorZero, player)
	      Game():SpawnParticles(npc.Position, 95, 10, i, Color(1.1,1,1,1,0,0,0), -50)
		end	
	  end
   end
end

--[[function this.trigger(id)
  local player = Isaac.GetPlayer(0)
     player:AddCoins(7)
   end
end--]]

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  --mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)--
end

return this