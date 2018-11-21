local this = {}
this.id = Isaac.GetEntityTypeByName("Peabody")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  npc.Velocity = utils.vecToPos(target.Position, npc.Position) * (npc.StateFrame/6)

  if npc.Variant == 4000 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/peabody.png")
    sprite:LoadGraphics()
  elseif npc.Variant == 4001 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/peabody_x.png")
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-12, -8, -4)

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("Fly")

    if room:CheckLine(npc.Position,target.Position,0,1,false,false) and utils.chancep(60) then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame>=40 then
      sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0 , 1.2, 0, false, 1)
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Attack")
    npc.StateFrame = npc.StateFrame - 1

    if utils.chancep(50) and npc.StateFrame<30 then
      local RCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), nil)
      RCreep.SpriteScale = Vector(0.75,0.75)
      RCreep:Update()
    end

    if sprite:IsEventTriggered("Smack") then
    npc.StateFrame = npc.StateFrame - 10
       for i=1, 4 do
          if npc.Variant == 4000 then Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(i*90):Resized(8), npc) end
          if npc.Variant == 4001 then Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(45+i*90):Resized(8), npc) end
       end
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
    end

    if sprite:IsFinished("Attack") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(12, 8, 4)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
