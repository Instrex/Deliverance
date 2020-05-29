local this = {}
this.id = Isaac.GetEntityTypeByName("Eddie")
this.variant = Isaac.GetEntityVariantByName("Eddie")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  npc.Velocity = vectorZero

  local level = game:GetLevel()
  local stage = level:GetStage()
  if stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
    if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
        sprite:ReplaceSpritesheet(0, "gfx/monsters/eddie_flooded.png")
        sprite:LoadGraphics()
    end
  elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
    if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
        sprite:ReplaceSpritesheet(0, "gfx/monsters/eddie_scarred.png")
    else
        sprite:ReplaceSpritesheet(0, "gfx/monsters/eddie_womb.png")
    end
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
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
      npc.Position = room:FindFreePickupSpawnPosition((target.Position+Vector(Utils.choose(Utils.choose(-150, -15),Utils.choose(15,150),Utils.choose(-125,-40),Utils.choose(40,125)),(Utils.choose(Utils.choose(-150, -15),Utils.choose(15,150),Utils.choose(-125,-40),Utils.choose(40,125))))), 75, true)
      if room:CheckLine(npc.Position,target.Position,3,1,false,true) then
         npc.State = NpcState.STATE_ATTACK
      else
         npc.State = NpcState.STATE_ATTACK2
      end
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
       Isaac.Spawn(9, 0, 0, Vector(npc.Position.X,npc.Position.Y + 7.5), (utils.vecToPos(target.Position, npc.Position) * 11):Rotated(math.random(-5, 5)), npc)
       sfx:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1.5)
    end

    if sprite:IsFinished("DigOut") then
      npc.State = NpcState.STATE_ATTACK3
      npc.StateFrame = Utils.choose(-30, -15, 0)
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then

    sprite:Play("DigOut2")
    if sprite:IsEventTriggered("ChangeCol") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end
    if sprite:IsFinished("DigOut2") then
      npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
      npc.State = NpcState.STATE_ATTACK3
      npc.StateFrame = Utils.choose(0, 5, 10)
    end

  elseif npc.State == NpcState.STATE_ATTACK3 then
    sprite:Play("DigIn")

    if sprite:IsEventTriggered("ChangeCol") then
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end

    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame>=30 then
      npc.Position = room:FindFreePickupSpawnPosition((target.Position+Vector(Utils.choose(Utils.choose(-150, -15),Utils.choose(15,150),Utils.choose(-125,-40),Utils.choose(40,125)),(Utils.choose(Utils.choose(-150, -15),Utils.choose(15,150),Utils.choose(-125,-40),Utils.choose(40,125))))), 75, true)
      if room:CheckLine(npc.Position,target.Position,3,1,false,true) then
         npc.State = NpcState.STATE_ATTACK
      else
         npc.State = NpcState.STATE_ATTACK2
      end
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
