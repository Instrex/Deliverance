local this = {}
this.id = Isaac.GetEntityTypeByName("Nutcracker")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, -5, 0)

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
--  if npc.StateFrame>=0 then
      if room:CheckLine(npc.Position,target.Position,0,1,false,false) then
        npc.Pathfinder:FindGridPath(target.Position, 0.6, 2, false)
      else
        npc.Pathfinder:MoveRandomly(false)
      end
      npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
--  else
--    sprite:Play("StandingStill")
--    npc.Velocity=Vector(0,0) 
--  end

    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=35 then
      if npc.Position:Distance(target.Position) <= 275 then
         sfx:Play(SoundEffect.SOUND_BOSS_LITE_ROAR, 1.2, 0, false, 1)
         npc.State = NpcState.STATE_ATTACK
      end
    end

  -- Chases the player and destroys objects on the way --
  elseif npc.State == NpcState.STATE_ATTACK then
    npc:AnimWalkFrame("WalkHoriRage", "WalkHoriRage", 0.1)
    npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 6.5

    if sprite:IsFinished("WalkHoriRage") then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = Utils.choose(-32, -24, -16)
    end

    if sprite:IsEventTriggered("Shake") then
        Game():ShakeScreen(4)
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.4, 0, false, 2)

        for e, food in pairs(Isaac.FindInRadius(npc.Position, 30, EntityPartition.ENEMY)) do
           if food.Type == 13 or food.Type == 18 or food.Type == 222 or food.Type == 256 or food.Type == 281 or food.Type == 296 or food.Type == 80 or food.Type == 14 or food.Type == 85 or food.Type == 94 then
               food:TakeDamage(10, 0, EntityRef(nil), 0)
               npc.HitPoints = npc.MaxHitPoints
               sprite:ReplaceSpritesheet(1,"gfx/monsters/gluttyb.png")
               sprite:LoadGraphics()
           end
        end
    end

    for i = 1, Game():GetRoom():GetGridSize() do
        local grid = room:GetGridEntity(i)
        if grid and (grid.Desc.Type==2 or grid.Desc.Type==3 or grid.Desc.Type==4 or grid.Desc.Type==5 or grid.Desc.Type==6 or grid.Desc.Type==14 or grid.Desc.Type==22) then 
           if npc.Position:Distance(grid.Position) <= 42 then
              room:DestroyGrid(i, true) 
           end
        end
    end

  end
end

function this:transformation(npc)
  if utils.chancep(20) then
    npc:Morph(this.id, 0, 0, 0)
  end
end

function this:die(npc)
  Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), player)
  game:Spawn(11, utils.choose(0, 1), npc.Position, Vector(0,0), npc, 0, 1)
    :ToNPC():ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 16)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this