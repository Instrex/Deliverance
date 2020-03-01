local this = {}
this.id = Isaac.GetEntityTypeByName("Stonelet")
this.variant = Isaac.GetEntityVariantByName("Stonelet")

function this:behaviour(npc)
	if npc.Variant == this.variant  then
		local playertarget = npc:GetPlayerTarget()
		local sprite = npc:GetSprite()
		local room = game:GetRoom()

		--Start--
		if npc.State == NpcState.STATE_INIT then
			npc.State = NpcState.STATE_MOVE
			npc.StateFrame = 0
		--Move and Attack--	
		elseif npc.State == NpcState.STATE_MOVE then
			npc.Velocity = (playertarget.Position - npc.Position):Normalized() + npc.Velocity * 0.8
			--npc.Pathfinder:FindGridPath(playertarget.Position, 0.7, 2, false)
			npc:AnimWalkFrame("WalkHori", "WalkVert", 0,1)
			npc.StateFrame = npc.StateFrame + 1
			if npc.Position:Distance (playertarget.Position) <=205 then
				if npc.StateFrame >= 30 then
					Isaac.Spawn(9, 0, 0, Vector(npc.Position.X, npc.Position.Y), (playertarget.Position - npc.Position):Normalized() + npc.Velocity *2, npc):ToProjectile()
					npc.StateFrame = 0
				end
			end
			if enemystatus == false then
				npc.State = STATE_UNIQUE_DEATH 
			end
		end
	end
end


function this:onstoneletdamage() --thx Tem ;*
    return false
end

function this:autodead(_, npc) --thx tem (again)
	local enemystatus=false
	for i,entity in ipairs(Isaac.GetRoomEntities()) do
    	if entity.Type~=600 and entity:IsEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)==false then
        	enemystatus=true
    	end
	end
end
end
	

function this.Init()
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
	mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, this.autodead,this.id)
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG,this.onstoneletdamage,this.id)
end

return this