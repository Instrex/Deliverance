local this = {}
this.id = Isaac.GetEntityTypeByName("Rosenberg")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  npc.Velocity = Vector(0,0)
  if target.Position.X<npc.Position.X then sprite.FlipX=false else sprite.FlipX=true end

  local level = game:GetLevel()
  local stage = level:GetStage()
  if stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
    if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
        sprite:ReplaceSpritesheet(0, "gfx/monsters/rosenberg_flooded.png")
        sprite:LoadGraphics()
    end
  elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
    if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
        sprite:ReplaceSpritesheet(0, "gfx/monsters/rosenberg_scarred.png")
    else
        sprite:ReplaceSpritesheet(0, "gfx/monsters/rosenberg_womb.png")
    end
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then

    sprite:Play("Idle");
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=15 or npc.Position:Distance(target.Position) <= 100 then
      npc.State = NpcState.STATE_MOVE npc.StateFrame=0
    end

  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("DigInIdle")
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    if sprite:IsFinished("DigInIdle") then
      npc.State = NpcState.STATE_ATTACK
      npc.Position = room:FindFreePickupSpawnPosition(npc.Position, 100, true)
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("DigOut")

    if sprite:IsEventTriggered("Scream") then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.8)
    end

    if sprite:IsEventTriggered("ChangeCol") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    if sprite:IsEventTriggered("Shoot") then
       local params = ProjectileParams() 
       params.FallingSpeedModifier = math.random(-18, -14) 
       params.FallingAccelModifier = 1.2 
       params.Variant = 3
       if stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
         if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
         params.Variant = 4
         end
       elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
         params.Variant = 0
       end

       local velocity = (target.Position - npc.Position):Rotated(math.random(-15, 15)) * 0.05 * 12 * 0.1
       local length = velocity:Length() 
       if length > 12 then 
         velocity = (velocity / length) * 12
       end 
       npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y+8), velocity, 0, params)
       sfx:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
    end

    if sprite:IsFinished("DigOut") then
      npc.State = NpcState.STATE_ATTACK2
      npc.StateFrame = Utils.choose(-30, -15, 0)
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then
    sprite:Play("DigIn")

    if sprite:IsEventTriggered("ChangeCol") then
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end

    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame>=30 then
      npc.State = NpcState.STATE_ATTACK
      npc.Position = room:FindFreePickupSpawnPosition(npc.Position, 100, true)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this