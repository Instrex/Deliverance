local this = {}
this.id = Isaac.GetEntityTypeByName("Stonelet")
this.variant = Isaac.GetEntityVariantByName("Stonelet")

function this:behaviour(npc)
	if npc.Variant == this.variant then
		local target = npc:GetPlayerTarget()
		local data = npc:GetData()
		local sprite = npc:GetSprite()
		local room = game:GetRoom()

		--Start--
		if room:IsClear() and Isaac.CountEnemies() <= 0 and npc.Variant == this.variant then
				npc.State = NpcState.STATE_UNIQUE_DEATH
			end
		if npc.State == NpcState.STATE_INIT then
			npc.State = NpcState.STATE_MOVE
			npc.StateFrame = Utils.choose(0, 10, 20)
		--Move and Attack--	
		elseif npc.State == NpcState.STATE_MOVE then
			if data.GridCountdown == nil then data.GridCountdown = 0 end
			if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          		npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
          		if data.GridCountdown <= 0 then
              		data.GridCountdown = 30
          		else
              		data.GridCountdown = data.GridCountdown - 1
          		end
       		else
			npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.8
		end
			npc:AnimWalkFrame("WalkHori", "WalkVert", 0,1)
			npc.StateFrame = npc.StateFrame + 1
			if npc.Position:Distance (target.Position) <=205 and npc.StateFrame >= 45 then
				npc.State = NpcState.STATE_ATTACK
			end
		elseif npc.State == NpcState.STATE_ATTACK then
			npc.Velocity = vectorZero
			sprite:Play("Shoot")
			if sprite:IsEventTriggered("Roar") then
				sfx:Play(310, 1.2, 0, false, 1)
			end
			if sprite:IsEventTriggered("Shoot") then
				sfx:Play(262, 1.2, 0, false, 1)
				Isaac.Spawn(9, 0, 0, Vector(npc.Position.X, npc.Position.Y), (utils.vecToPos(target.Position, npc.Position)*10), npc):ToProjectile()
			end
			if sprite:IsFinished("Shoot") then
				npc.State = NpcState.STATE_MOVE
				npc.StateFrame = 0
			end
		elseif npc.State == NpcState.STATE_UNIQUE_DEATH then
			npc.Velocity = vectorZero
			sprite:Play("Death")
			if sprite:IsFinished("Death") then
				npc:Kill()
			end
		end
	end
end
	

function this.Init()
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this