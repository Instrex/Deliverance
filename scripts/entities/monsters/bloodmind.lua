local this = {}
this.id = Isaac.GetEntityTypeByName("Bloodmind")
this.variant = Isaac.GetEntityVariantByName("Bloodmind")

function this:behaviour(npc)
  if npc.Variant == this.variant then
    local target = npc:GetPlayerTarget()
    local sprite = npc:GetSprite()
    local data = npc:GetData()
	
	npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK |EntityFlag.FLAG_NO_STATUS_EFFECTS)

    --Begin--
    if npc.State == NpcState.STATE_INIT then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(0, 10, 20)
      -- Move and attack--

    elseif npc.State == NpcState.STATE_MOVE then
			if data.GridCountdown == nil then data.GridCountdown = 0 end
			if npc:CollidesWithGrid() or data.GridCountdown > 0 then
        npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
        if data.GridCountdown <= 0 then
          data.GridCountdown = 45
        else
          data.GridCountdown = data.GridCountdown - 1
        end
      else
        npc.Velocity = utils.vecToPos(npc.Position, target.Position,1.35) * 0.325 + npc.Velocity * 0.95
		end
			npc:AnimWalkFrame("WalkHori", "WalkVert", 0,1)
			if npc.Position:Distance(target.Position) <= 200 then
        npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
      end
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
			if npc.StateFrame >= 100 then
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
          sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
          Isaac.Spawn(1000, 2, 0, npc.Position, vectorZero, player)
          Game():Spawn(Isaac.GetEntityTypeByName("Bloodmind Spit"), Isaac.GetEntityVariantByName("Bloodmind Spit"), npc.Position, target.Position - npc.Position, npc, 0, 1)
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