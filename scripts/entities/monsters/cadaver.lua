local this = {}
this.id = Isaac.GetEntityTypeByName("Cadaver")

function this:behaviour(npc)
 if npc.Variant == Isaac.GetEntityVariantByName("Cadaver") or npc.Variant == Isaac.GetEntityVariantByName("Wicked Cadaver") or npc.Variant == Isaac.GetEntityVariantByName("Sluggish Cadaver") then
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  local level = game:GetLevel()
  local stage = level:GetStage()

  if (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2) and level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/cadaver_flooded.png")
    sprite:ReplaceSpritesheet(2,"gfx/monsters/cadaver_flooded.png")
    sprite:ReplaceSpritesheet(3,"gfx/monsters/cadaver_flooded.png")
    sprite:ReplaceSpritesheet(5,"gfx/monsters/cadaver_flooded.png")
    if npc.Variant == 4000 then
        sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver_flooded.png")
        sprite:LoadGraphics()
    elseif npc.Variant == 4001 then
        sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver2_flooded.png")
        sprite:LoadGraphics()
    elseif npc.Variant == 4002 then
        sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver3_flooded.png")
        sprite:LoadGraphics()
    end
  elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/cadaver_womb.png")
    if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
        sprite:ReplaceSpritesheet(2,"gfx/monsters/cadaver_scarred.png")
        sprite:ReplaceSpritesheet(3,"gfx/monsters/cadaver_scarred.png")
        if npc.Variant == 4000 then
           sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver_scarred.png")
           sprite:LoadGraphics()
        elseif npc.Variant == 4001 then
           sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver2_scarred.png")
           sprite:LoadGraphics()
        elseif npc.Variant == 4002 then
           sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver3_scarred.png")
           sprite:LoadGraphics()
        end
    else
        sprite:ReplaceSpritesheet(2,"gfx/monsters/cadaver_womb.png")
        sprite:ReplaceSpritesheet(3,"gfx/monsters/cadaver_womb.png")
        if npc.Variant == 4000 then
           sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver_womb.png")
           sprite:LoadGraphics()
        elseif npc.Variant == 4001 then
           sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver2_womb.png")
           sprite:LoadGraphics()
        elseif npc.Variant == 4002 then
           sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver3_womb.png")
           sprite:LoadGraphics()
        end
    end
  else
    if npc.Variant == 4000 then
      sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver.png")
      sprite:LoadGraphics()
    elseif npc.Variant == 4001 then
      sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver2.png")
      sprite:LoadGraphics()
    elseif npc.Variant == 4002 then
      sprite:ReplaceSpritesheet(1,"gfx/monsters/cadaver3.png")
      sprite:LoadGraphics()
    end
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
 
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    npc.StateFrame = Utils.choose(100, 125, 150)
    if data.sped == nil then data.sped = Utils.choose(0.85, 0.8, 0.75) end
    if data.GridCountdown == nil then data.GridCountdown = 0 end
    
  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_IDLE then
    
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    npc.Velocity = vectorZero
    sprite:Play("Stasis");	

    npc.StateFrame = npc.StateFrame + 1

    if npc.Position:Distance(target.Position) <= npc.StateFrame then
       sfx:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT , 1, 0, false, data.sped)
       if stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
          if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
             sfx:Play(212, 1.25, 0, false, math.random(8, 12) / 10)
          end
       end
       npc.State = NpcState.STATE_ATTACK
       Game():ShakeScreen(6)
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("Pop");

    if sprite:IsEventTriggered("Roar") then
       if npc.Variant == 4000 then
         sfx:Play(SoundEffect.SOUND_RAGMAN_1 , 1.25, 0, false, 0.8)
         sprite:LoadGraphics()
       elseif npc.Variant == 4001 then
         sfx:Play(SoundEffect.SOUND_RAGMAN_2 , 1.25, 0, false, 0.8)
         sprite:LoadGraphics()
       elseif npc.Variant == 4002 then
         sfx:Play(SoundEffect.SOUND_RAGMAN_3 , 1.25, 0, false, 0.8)
         sprite:LoadGraphics()
       end
    end
    if sprite:IsFinished("Pop") then npc.State = NpcState.STATE_ATTACK2 end

  elseif npc.State == NpcState.STATE_ATTACK2 then
    
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
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
  end
 end
end

function this:die(npc)
 if npc.Variant == Isaac.GetEntityVariantByName("Cadaver") or npc.Variant == Isaac.GetEntityVariantByName("Wicked Cadaver") or npc.Variant == Isaac.GetEntityVariantByName("Sluggish Cadaver") then
   sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 0.75)
   for i=1, 4 do
       if npc.Variant == 4001 then Isaac.Spawn(9, 1, 0, npc.Position, Vector.FromAngle(45+i*90):Resized(12), npc) end
       if npc.Variant == 4002 then Isaac.Spawn(9, 1, 0, npc.Position, Vector.FromAngle(i*90):Resized(12), npc) end
   end
 end
end
         
function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this