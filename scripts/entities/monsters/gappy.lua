local this = {}
this.id = Isaac.GetEntityTypeByName("Gappy")
this.variant = Isaac.GetEntityVariantByName("Gappy")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
  if data.GridCountdown == nil then data.GridCountdown = 0 end
  if data.sped == nil then data.sped = Utils.choose(0.825, 0.85, 0.875) end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-60, -50, -40, -30, -20, -10, 0)
    if data.parent:Exists() and not data.parent:IsDead() then
       if data.target2 == nil then data.target2 = room:FindFreePickupSpawnPosition((data.parent.Position+Vector(math.random(-24, 24),math.random(-24, 24))), 32, true) end
    end

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
   npc:AnimWalkFrame("WalkHori", "WalkVertDo", 0.1)
   if not data.parent:Exists() or data.parent:IsDead() then
      sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 0.8, 0, false, 1.25)
      npc.State = NpcState.STATE_ATTACK2
   end

   if data.parent:Exists() and not data.parent:IsDead() then
       if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          npc.Pathfinder:FindGridPath(data.target2, data.sped, 1, false)
          if data.GridCountdown <= 0 then
              data.GridCountdown = 30
          else
              data.GridCountdown = data.GridCountdown - 1
          end
       else
          npc.Velocity = utils.vecToPos(data.target2, npc.Position) * 1.15 + npc.Velocity * data.sped
       end
   end

   npc.StateFrame = npc.StateFrame + 1

   if npc.StateFrame>=30 or npc.Position:Distance(data.target2) <= 16 then
      npc.State = NpcState.STATE_ATTACK
      npc.StateFrame = 0
   end

  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("StandingStill");

    npc.Velocity = npc.Velocity * 0.5

    if not data.parent:Exists() or data.parent:IsDead() then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 0.8, 0, false, 1.25)
       npc.State = NpcState.STATE_ATTACK2
       npc.StateFrame = Utils.choose(-60,-50,-40,-30,-20,-10, 0)
    end

    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=32 then
       npc.State = NpcState.STATE_MOVE
       npc:AnimWalkFrame("WalkHori", "WalkVertDo", 0.1)
       if data.parent:Exists() and not data.parent:IsDead() then
          data.target2 = room:FindFreePickupSpawnPosition((data.parent.Position+Vector(math.random(-24, 24),math.random(-24, 24))), 32, true)
       end
       npc.StateFrame = Utils.choose(-30, -20, -10, 0)
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then
    npc:AnimWalkFrame("WalkHoriRage", "WalkVertRage", 0.1)
    if not target:IsDead() then
        if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          npc.Pathfinder:FindGridPath(target.Position, data.sped, 1, false)
          if data.GridCountdown <= 0 then
              data.GridCountdown = 30
          else
              data.GridCountdown = data.GridCountdown - 1
          end
       else
          npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.15 + npc.Velocity * data.sped 
       end
    end
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=150 then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 0.8, 0, false, 1.25)
       npc.StateFrame = Utils.choose(-60,-50,-40,-30,-20,-10, 0)
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this