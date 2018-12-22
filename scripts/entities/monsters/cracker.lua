local this = {}
this.id = Isaac.GetEntityTypeByName("Cracker")
this.variant = Isaac.GetEntityVariantByName("Cracker")

local sfx = SFXManager()
function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local current_floor = game:GetLevel():GetStage()
  local brim_type=1;
  local room = game:GetRoom()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, -5, 0)

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
    npc.Pathfinder:FindGridPath(target.Position, 0.7, 2, false)
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
    if room:CheckLine(npc.Position,target.Position,0,1,false,false) then
       npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame>=30 then
      if npc.Position:Distance(target.Position) <= 275 then
         sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1.2, 0, false, 1)
         npc.State = NpcState.STATE_ATTACK;
         npc.StateFrame = math.random(-30,-15);
      end
    end

  -- Jumps --
  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Jump");

    if sprite:IsEventTriggered("Jumped") then
         npc.Velocity = (target.Position - npc.Position):Normalized()*15
         npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end

    for i = 1, Game():GetRoom():GetGridSize() do
        local grid = room:GetGridEntity(i)
        if grid and (grid.Desc.Type==2 or grid.Desc.Type==3 or grid.Desc.Type==4 or grid.Desc.Type==5 or grid.Desc.Type==6 or grid.Desc.Type==14 or grid.Desc.Type==22) then 
           if npc.Position:Distance(grid.Position) <= 42 then
              room:DestroyGrid(i, true) 
           end
        end
    end

    if(sprite:IsFinished("Jump")) then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc.State = NpcState.STATE_ATTACK2;
        npc.Velocity=Vector(0,0)
        sfx:Play(SoundEffect.SOUND_POT_BREAK , 1, 0, false, 1)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(0, 12), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(12, 0), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(0, -12), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(-12, 0), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(9, 9), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(-9, 9), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(9, -9), target)
        Isaac.Spawn(9, 0, 0, npc.Position, Vector(-9, -9), target)
        Game():ShakeScreen(6)
    end

  -- Falls --
  elseif npc.State == NpcState.STATE_ATTACK2 then
     sprite:Play("Land");

     if(sprite:IsFinished("Land")) then
        npc.State = NpcState.STATE_MOVE;
     end
  end
 end
end

function this:die(npc)
 if npc.Variant == this.variant then
  blood = Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), player)
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this