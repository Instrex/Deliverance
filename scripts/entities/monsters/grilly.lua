local this = {}
this.id = Isaac.GetEntityTypeByName("Grilly")
this.variant = Isaac.GetEntityVariantByName("Grilly")

function this:behaviour(npc)
	if npc.Variant == this.variant then
		local target = npc:GetPlayerTarget()
		local data = npc:GetData()
		local sprite = npc:GetSprite()

		--Begin--
		if npc.State == NpcState.STATE_INIT then
			sprite:PlayOverlay("Head", true)
			npc.State = NpcState.STATE_MOVE
		elseif npc.State == NpcState.STATE_MOVE then
			npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.8
			npc:AnimWalkFrame("WalkHori", "WalkVert", 0,1)
		end
	end
end

function this.Init()
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this