local this = {}
this.id = Isaac.GetEntityTypeByName("Bloodmind")
this.variant = Isaac.GetEntityVariantByName("Bloodmind")

function this:behaviour(npc)
	if npc.Variant == this.variant then
		local target = npc:GetPlayerTarget()
		local data = npc:GetData()
		local sprite = npc:GetSprite()
		local data = npc:GetData()
        local room = game:GetRoom() 

		--Begin--
		if npc.State == NpcState.STATE_INIT then
			npc.State = NpcState.STATE_MOVE
		    npc.StateFrame = Utils.choose(0, 10, 20)
	-- Move and attack--
    elseif npc.State == NpcState.STATE_MOVE then  
       if not target:IsDead() then 
          if data.GridCountdown == nil then data.GridCountdown = 0 end
          if npc:CollidesWithGrid() or data.GridCountdown > 0 then
             npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
              data.GridCountdown = 30
			  if data.GridCountdown <= 0 then
              		data.GridCountdown = 30
             else
                 data.GridCountdown = data.GridCountdown - 1
             end
          else
             if npc.StateFrame>=0 then
                npc.Velocity = utils.vecToPos(npc.Position, target.Position) * 1 + npc.Velocity * 0.8
          end
       end
    end
    
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    if npc.Position:Distance(target.Position) <= 275 then
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
    end
    npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)

    if npc.StateFrame>=50 then
         sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.7)
         npc.State = NpcState.STATE_ATTACK
    end

    elseif npc.State == NpcState.STATE_ATTACK then
    
    npc.Velocity = npc.Velocity * 0.85

    sprite:Play("Shoot");

    if sprite:IsEventTriggered("Roar") then
        sfx:Play(Isaac.GetSoundIdByName("Fistulauncher"), 0.7, 0, false, 1)
    end

    if sprite:IsEventTriggered("Shoot") then
        npc.Velocity = vectorZero
        sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 0.7, 0, false, 1)
        Game():Spawn(Isaac.GetEntityTypeByName("Bloodmind Spit"), Isaac.GetEntityVariantByName("Bloodmind Spit"), npc.Position, vectorZero, npc, 0, 1)
    end

    if(sprite:IsFinished("Shoot")) then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = Utils.choose(0, 10, 20)
      end
    end
  end
end

function this.Init()
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this