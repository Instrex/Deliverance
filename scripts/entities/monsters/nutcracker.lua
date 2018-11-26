local this = {}
this.id = Isaac.GetEntityTypeByName("Nutcracker")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  if npc.State ~= NpcState.STATE_INIT then
    if data.timer<4 then data.timer = data.timer + 1 else data.timer=0 data.playertarget=target.Position end
  end
  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, -5, 0)
    data.timer = 0 data.playertarget=target.Position

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
    if room:CheckLine(npc.Position,data.playertarget,0,1,false,false) then
      npc.Pathfinder:FindGridPath(data.playertarget, 0.6, 2, false)
    else
      npc.Pathfinder:MoveRandomly(false)
    end
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=35 then
      if npc.Position:Distance(data.playertarget) <= 275 then
         sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.8)
         npc.State = NpcState.STATE_ATTACK
      end
    end

  -- Chases the player and destroys objects on the way --
  elseif npc.State == NpcState.STATE_ATTACK then
    npc:AnimWalkFrame("WalkHoriRage", "WalkHoriRage", 0.1)
    if not target:IsDead() then npc.Velocity = utils.vecToPos(data.playertarget, npc.Position) * 7 end

    if sprite:IsFinished("WalkHoriRage") then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = Utils.choose(-32, -24, -16)
    end

    if sprite:IsEventTriggered("Shake") then
        Game():ShakeScreen(4)
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.6, 0, false, 2)

        for e, food in pairs(Isaac.FindInRadius(npc.Position, 30, EntityPartition.ENEMY)) do
           if food.Type == 13 or food.Type == 18 or food.Type == 222 or food.Type == 256 or food.Type == 281 or food.Type == 296 or food.Type == 80 or food.Type == 14 or food.Type == 85 or food.Type == 94 then
               food:TakeDamage(10, 0, EntityRef(nil), 0)
               Isaac.Spawn(1000, 49, 0, Vector(npc.Position.X,npc.Position.Y-16), Vector(0,0), nil)
               sfx:Play(SoundEffect.SOUND_VAMP_GULP , 1.25, 0, false, 0.8)
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

--function this:transformation(npc)
--  if utils.chancep(20) then
--    npc:Morph(this.id, 0, 0, 0)
--  end
--end

function this:die(npc)
  game:Spawn(11, utils.choose(0, 1), npc.Position, Vector(0,0), npc, 0, 1)
    :ToNPC():ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 16)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this