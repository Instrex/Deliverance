local this = {}
this.id = Isaac.GetEntityTypeByName("Eddie")
this.variant = Isaac.GetEntityVariantByName("Eddie")

function this:behaviour(npc)
  if npc.Variant == this.variant then
    local target = npc:GetPlayerTarget()
    local sprite = npc:GetSprite()
    local room = game:GetRoom()

    npc.Velocity = Vector.Zero

    -- Begin --
    if npc.State == NpcState.STATE_INIT then
      --npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
      if sprite:IsFinished("Appear") then
        sprite:Play("DigIn")
      end
        if sprite:IsFinished("DigIn") then
          npc.State = NpcState.STATE_MOVE
        end

      -- Move and seek for a moment to attack --
    elseif npc.State == NpcState.STATE_IDLE then

      if not sprite:IsPlaying("Idle") then
        sprite:Play("Idle")
      end
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
      npc.StateFrame = npc.StateFrame + 1

      --[[if npc.StateFrame>=15 or npc.Position:Distance(target.Position) <= 100 then
        npc.State = NpcState.STATE_MOVE npc.StateFrame=0
      end--]]
      if npc.StateFrame>=15 then
        if room:CheckLine(npc.Position,target.Position,3,1,false,false) and npc.Position:Distance(target.Position) <= 275 then
          npc.State = NpcState.STATE_ATTACK
        else
          sprite:Play("DigIn")
            npc.State = NpcState.STATE_MOVE
            npc.StateFrame = Utils.choose(-30, -15, 0)
        end
      end

    elseif npc.State == NpcState.STATE_MOVE then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

      if sprite:IsFinished("DigIn") then
        local validPositions = {}
        for i = 0, room:GetGridSize() do
          local grid = room:GetGridEntity(i)
          local pos = room:GetGridPosition(i)
          if room:IsPositionInRoom(pos, 0) and ( (not grid) or (room:GetGridCollision(i) == GridCollisionClass.COLLISION_NONE and (grid:GetType() ~= GridEntityType.GRID_SPIKES and grid:GetType() ~= GridEntityType.GRID_SPIKES_ONOFF) or grid:GetType() == GridEntityType.GRID_SPIDERWEB)) then
              local nearAvoidPos = npc.Position:DistanceSquared(pos) < 100 * 100
              if not nearAvoidPos then
                if target.Position:DistanceSquared(pos) < 100 * 100 then
                  nearAvoidPos = true
                end
              end

            if not nearAvoidPos then
              validPositions[#validPositions + 1] = pos
            end
          end
        end
        npc.Position = validPositions[math.random(1, #validPositions)]
        sprite:Play("Appear",true)
      end

      if sprite:IsFinished("Appear") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc.State = NpcState.STATE_IDLE
      end

    elseif npc.State == NpcState.STATE_ATTACK then

      sprite:Play("DigOut")

      if sprite:IsEventTriggered("Scream") then
        sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.8)
      end

      if sprite:IsEventTriggered("Shoot") then
        Isaac.Spawn(9, 0, 0, Vector(npc.Position.X,npc.Position.Y + 7.5), (utils.vecToPos(target.Position, npc.Position) * 11):Rotated(math.random(-5, 5)), npc)
        sfx:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1.5)
      end

      if sprite:IsFinished("DigOut") then
        sprite:Play("DigIn")
        npc.State = NpcState.STATE_MOVE
        npc.StateFrame = Utils.choose(-30, -15, 0)
      end
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
