local this = {
	variant = Isaac.GetEntityVariantByName("Fat Hopper")
}

function this:behaviour(npc)
	if npc.Variant == this.variant then
	local sprite = npc:GetSprite()
		if npc.State == 6 and (not sprite:IsFinished("BigJumpUp") or sprite:IsPlaying("BigJumpUp")) then
			sprite:Play("BigJumpUp")
		end
		
		if sprite:IsEventTriggered("Land")  then
			game:ShakeScreen(5)
			sfx:Play(139, 0.8, 1, false, 0.5)
		end
		if sprite:IsEventTriggered("BigLand") then
			game:ShakeScreen(15)
			sfx:Play(52, 1, 1, false, 1)
			local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, vectorZero, npc):ToEffect()
			wave.Parent = npc
			wave.MaxRadius = 75
		end
		
		for _, prj in ipairs(Isaac.GetRoomEntities()) do
				if prj.SpawnerType == 34 and prj.SpawnerVariant == npc.Variant then
					if prj.Type == 9 and npc.State == 7 and npc.StateFrame == 20 then
						prj:Remove()
					end
				end
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

--[[function this:testrender()
	 for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if ent.Type == 34 and ent.Variant == this.variant then
			
			Isaac.RenderText("STATE FRAME ".. ent:ToNPC().StateFrame, 125, 200, 1, 1, 1, 1)
			Isaac.RenderText("STATE ".. ent:ToNPC().State, 125, 225, 1, 1, 1, 1)
		end
	end
end--]]

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, 34)
  --mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.testrender)
end

return this