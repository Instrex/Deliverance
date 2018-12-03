local this = {}
this.id = Isaac.GetEntityTypeByName("Gelatino")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  if npc.Variant == 4000 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino.png")
    sprite:ReplaceSpritesheet(1,"gfx/monsters/gelatino.png")
    sprite:LoadGraphics()
  elseif npc.Variant == 4001 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino2.png")
    sprite:ReplaceSpritesheet(1,"gfx/monsters/gelatino2.png")
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    if data.roll == nil then data.roll = npc:GetDropRNG():RandomInt(99) end
      if data.roll<10 then sprite:Play("WithSack");
        elseif data.roll<25 then sprite:Play("WithCoins");
        elseif data.roll<40 then sprite:Play("WithBombs");
        elseif data.roll<55 then sprite:Play("WithKeys");
        elseif data.roll<75 then sprite:Play("WithBoney");
        elseif data.roll<95 then sprite:Play("WithHeart");
        elseif data.roll==95 then sprite:Play("WithLibertyCap");
        elseif data.roll==96 then sprite:Play("WithCursedSkull");
        elseif data.roll==97 then sprite:Play("WithCallus");
        elseif data.roll>97 then sprite:Play("WithTick");
      end
    npc.State = NpcState.STATE_MOVE
  elseif npc.State == NpcState.STATE_MOVE then
--  npc.Pathfinder:FindGridPath(target.Position, 0.6, 1, false)
--  npc.Pathfinder:MoveRandomlyAxisAligned(0.6, false)
    if npc.Variant == 4000 then
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.8 end
    elseif npc.Variant == 4001 then
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.05 + npc.Velocity * 0.86 end
    end

      if utils.chancep(33) then
        local Creep = Isaac.Spawn(1000, 7, 0, npc.Position, Vector(0,0), nil)
        Creep.Color = Color(0, 0, 0, 0.75, 58, 140, 122)
--      Creep.SpriteScale = Vector(0.75,0.75) 
        Creep:Update()
      end
  end  

  if npc:IsDead() then
    if data.roll<10 then Isaac.Spawn(5, 69, 0, npc.Position, Vector(0, 0), player);
      elseif data.roll<25 then if npc.Variant == 4000 then Isaac.Spawn(5, 20, 4, npc.Position, Vector(0, 0), player) elseif npc.Variant == 4001 then Isaac.Spawn(5, 20, 1, npc.Position, Vector(0, 0), player) end
      elseif data.roll<40 then if npc.Variant == 4000 then Isaac.Spawn(5, 40, 2, npc.Position, Vector(0, 0), player) elseif npc.Variant == 4001 then Isaac.Spawn(5, 40, 1, npc.Position, Vector(0, 0), player) end
      elseif data.roll<55 then if npc.Variant == 4000 then Isaac.Spawn(5, 30, 3, npc.Position, Vector(0, 0), player) elseif npc.Variant == 4001 then Isaac.Spawn(5, 30, 1, npc.Position, Vector(0, 0), player) end
      elseif data.roll<75 then if npc.Variant == 4000 then Isaac.Spawn(227, 0, 0, npc.Position, Vector(0, 0), player) elseif npc.Variant == 4001 then Isaac.Spawn(215, 0, 0, npc.Position, Vector(0, 0), player) end
      elseif data.roll<95 then if npc.Variant == 4000 then Isaac.Spawn(92, 0, 0, npc.Position, Vector(0, 0), player) elseif npc.Variant == 4001 then Isaac.Spawn(26, 1, 0, npc.Position, Vector(0, 0), player) end
      elseif data.roll==95 then Isaac.Spawn(5, 350, 32, npc.Position, Vector(0, 0), npc);
      elseif data.roll==96 then Isaac.Spawn(5, 350, 43, npc.Position, Vector(0, 0), player);
      elseif data.roll==97 then Isaac.Spawn(5, 350, 14, npc.Position, Vector(0, 0), player) 
      elseif data.roll>97 then Isaac.Spawn(5, 350, 53, npc.Position, Vector(0, 0), player);
    end
  end
end

function this:die(npc)
  sfx:Play(SoundEffect.SOUND_MEATHEADSHOOT  , 1, 0, false, 1) 
  local Creep = Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), npc)
  Creep.Color = Color(0, 0, 0, 0.75, 58, 140, 122)
  Creep.SpriteScale = Vector(0.75,0.75) 

  for i=1, 8 do
       if npc.Variant == 4000 then Isaac.Spawn(9, 6, 0, npc.Position, Vector.FromAngle(i*45):Resized(10), npc).Color = Color(0, 0, 0, 0.75, 68, 150, 132) end
  end
  for i=1, 4 do
       if npc.Variant == 4001 then Isaac.Spawn(9, 6, 0, npc.Position, Vector.FromAngle(45+i*90):Resized(10), npc).Color = Color(0, 0, 0, 0.75, 68, 150, 132) end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this