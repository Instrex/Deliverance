local this = {}
this.id = Isaac.GetEntityTypeByName("Beamo")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local level = game:GetLevel()
  local current_floor = level:GetStage()
  local brim_type=1;

  if (current_floor == LevelStage.STAGE5 or current_floor == LevelStage.STAGE5_GREED) then
    if level:GetStageType() == StageType.STAGETYPE_WOTL then
      sprite:ReplaceSpritesheet(0,"gfx/monsters/dreamo.png")
      sprite:LoadGraphics()
      brim_type=3
    else
      sprite:ReplaceSpritesheet(0,"gfx/monsters/brimo.png")
      sprite:LoadGraphics()
      brim_type=1
    end
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, -5, 0)

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
    npc.Pathfinder:MoveRandomly();
    sprite:Play("Move");
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame==10 then sfx:Play(SoundEffect.SOUND_RAGMAN_1, 1.2, 0, false, 1.) end

    if npc.StateFrame >= 20 then
      if target.Position.Y > npc.Position.Y-40 and target.Position.Y < npc.Position.Y+40  then
        if(target.Position.X > npc.Position.X) then
          npc.State = NpcState.STATE_ATTACK;
        else
          npc.State = NpcState.STATE_ATTACK2;
        end
        npc.StateFrame = 0;
        npc.Velocity = Vector(0,0);
      end
    end

  -- Charges --
  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("BrimstoneLeft");

    if sprite:IsEventTriggered("BrimLeft") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
       local brimstone_laser = EntityLaser.ShootAngle(brim_type, npc.Position, 180, 15, Vector(-25,-9), npc)
       brimstone_laser.DepthOffset = 200
       npc.Velocity = Vector(25,0)
    end

    if(sprite:IsFinished("BrimstoneLeft")) then
       npc.Velocity = Vector(-3,0);
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = 0;
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then
    sprite:Play("BrimstoneRight");

    if sprite:IsEventTriggered("BrimRight") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
       local brimstone_laser = EntityLaser.ShootAngle(brim_type, npc.Position, 0, 15, Vector(22,-9), npc)
       brimstone_laser.DepthOffset = 200
       npc.Velocity = Vector(-25,0)
    end

    if(sprite:IsFinished("BrimstoneRight")) then
       npc.Velocity = Vector(3,0);
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = 0;
    end
  end
end

--function this:transformation(npc)
--  if utils.chancep(16) then
--    npc:Morph(this.id, 0, 0, 0)
--  end
--end

function this:die(npc)
  blood = Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), target)
  if current_floor == LevelStage.STAGE5 and level:GetStageType() == StageType.STAGETYPE_WOTL then
     blood.Color = Color( 0, 0, 0,   1,   150, 150, 150)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 285)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this