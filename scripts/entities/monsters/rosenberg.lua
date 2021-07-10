local this = {}
this.id = Isaac.GetEntityTypeByName("Rosenberg")
this.variant = Isaac.GetEntityVariantByName("Rosenberg")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local room = game:GetRoom()

  npc.Velocity = Vector.Zero
  if target.Position.X<npc.Position.X then sprite.FlipX=false else sprite.FlipX=true end

  local level = game:GetLevel()
  local stage = level:GetStage()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    --npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then

    sprite:Play("Idle");
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=15 or npc.Position:Distance(target.Position) <= 100 then
      sprite:Play("DigInIdle")
      npc.State = NpcState.STATE_MOVE npc.StateFrame=0
    end

  elseif npc.State == NpcState.STATE_MOVE then

    if sprite:IsFinished("DigInIdle") or sprite:IsFinished("DigIn") or sprite:IsFinished("DigIn2") then
      if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
      end
      npc.StateFrame = npc.StateFrame + 1
      if npc.StateFrame >=30 then
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
        npc.State = utils.choose(NpcState.STATE_ATTACK, NpcState.STATE_ATTACK, NpcState.STATE_ATTACK3)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
      end
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("DigOut")

    if sprite:IsEventTriggered("Scream") then
--     sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.8)
       sfx:Play(Isaac.GetSoundIdByName("Yuck"), 0.7, 0, false, 1.2)
    end

    --[[if sprite:IsEventTriggered("ChangeCol") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end--]]

    if sprite:IsEventTriggered("Shoot") then
       local params = ProjectileParams()
       params.FallingSpeedModifier = math.random(-14, -10)
       params.FallingAccelModifier = 1.2
       params.Variant = 3
       if stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
         if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
         params.Variant = 4
         end
       elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
         params.Variant = 0
       end

       local velocity = (target.Position - npc.Position):Rotated(math.random(-15, 15)) * 0.06 * 12 * 0.1
       local length = velocity:Length()
       if length > 12 then
         velocity = (velocity / length) * 12
       end
       npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y+8), velocity, 0, params)
       sfx:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
    end

    if sprite:IsFinished("DigOut") then
      sprite:Play("DigIn")
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(-30, -15, 0)
    end

  elseif npc.State == NpcState.STATE_ATTACK3 then

    sprite:Play("DigOut2")

    --[[if sprite:IsEventTriggered("ChangeCol") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end--]]

    if sprite:IsEventTriggered("Shoot2") then
       sfx:Play(Isaac.GetSoundIdByName("Yuck"), 1, 0, false, 0.9)
       local params = ProjectileParams()
       params.Variant = 0
       params.FallingSpeedModifier = -15
       params.FallingAccelModifier = 1
       params.HeightModifier = -65
       params.Scale = 3

       local color = Color(1,1,1,1,0,0,0)
       color:SetColorize(1,1,1,1)
       color:SetTint(0.5,0.5,0.5,1)
       params.Color = color

       local velocity = (target.Position - npc.Position):Rotated(math.random(-15, 15)) * 0.06 * 12 * 0.1
       local length = velocity:Length()
       if length > 12 then
        velocity = (velocity / length) * 12
       end
       params.VelocityMulti = 1.45

      local proj = npc:FireBossProjectiles(1,target.Position,1, params)
      local projdata = proj:GetData()
      projdata.RosenbergSpit = true
    end

    if sprite:IsFinished("DigOut2") then
      sprite:Play("DigIn2")
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(-30, -15, 0)
    end
  end
 end
end

function this:spit(proj)
  if proj.SpawnerType == this.id and proj.SpawnerVariant == this.variant then
    local projdata = proj:GetData()
      if projdata.RosenbergSpit == true then
        if proj:IsDead() then
          sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
          Isaac.Spawn(1000, 77, 0, proj.Position, vectorZero, proj).Color = Color(0, 0, 0, 0.9, 10/255, 10/255, 10/255)
          local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CREEP_BLACK,1,proj.Position, vectorZero, proj)
          creep:GetSprite().Scale = Vector(2.5,2.5)
          creep:ToEffect().Timeout = 150
        end
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, this.spit)
end

return this
