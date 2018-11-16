local this = {}
this.id = Isaac.GetEntityTypeByName("Nutcracker")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
    npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=35 then
      if npc.Position:Distance(target.Position) <= 150 then
         sfx:Play(SoundEffect.SOUND_BOSS_LITE_ROAR, 1.2, 0, false, 1)
         npc.State = NpcState.STATE_ATTACK
      end
    end

    if utils.chancep(0.05) then
       sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_0, 1.2, 0, false, 1)
    end

  -- Chases the player and destroys objects on the way --
  elseif npc.State == NpcState.STATE_ATTACK then
    npc:AnimWalkFrame("WalkHoriRage", "WalkHoriRage", 0.1)
    npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 7

    if sprite:IsFinished("WalkHoriRage") then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = -25;
    end

    if sprite:IsEventTriggered("Shake") then
        Game():ShakeScreen(4) sfx:Play(SoundEffect.SOUND_POT_BREAK , 0.5, 0, false, 2)

        for e, food in pairs(Isaac.FindInRadius(npc.Position, 30, EntityPartition.ENEMY)) do 
           if food.Type == 13 or food.Type == 18 or food.Type == 222 or food.Type == 256 or food.Type == 281 or food.Type == 296 or food.Type == 80 or food.Type == 14 then 
               food:TakeDamage(10, 0, EntityRef(nil), 0) 
               npc.HitPoints = npc.MaxHitPoints
               sprite:ReplaceSpritesheet(1,"gfx/monsters/gluttyb.png")
               sprite:LoadGraphics()
           end 
        end 
    end

    local grindex = game:GetRoom():GetGridIndex(npc.Position + npc.Velocity)
    local grid = game:GetRoom():GetGridEntity(grindex)
    if grid and grid.Desc.Type~=GridEntityType.GRID_DECORATION and grid.Desc.Type~=GridEntityType.GRID_SPIKES and grid.Desc.Type~=GridEntityType.GRID_SPIKES_ONOFF and grid.Desc.Type~=GridEntityType.GRID_SPIKES_ONOFF and grid.Desc.Type~=GridEntityType.GRID_SPIDERWEB and grid.Desc.Type~=GridEntityType.GRID_PRESSURE_PLATE then
        game:GetRoom():DestroyGrid(grindex, true)
    end
  end
end

function this:transformation(npc)
  if utils.chancep(20) then
    npc:Morph(this.id, 0, 0, 0)
  end
end

function this:die(npc)
  local type=0
  if utils.chancep(50) then type = 0 else type = 1 end
  local ent = Game():Spawn(11, 0, npc.Position, Vector(0,0), npc, 0, 1):ToNPC()

 
  ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 16)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
