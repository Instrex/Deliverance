local this = {}
this.id = Isaac.GetEntityTypeByName("Peabody")

function this:behaviour(npc)
 if npc.Variant == Isaac.GetEntityVariantByName("Peabody") or npc.Variant == Isaac.GetEntityVariantByName("Peabody X") or npc.Variant == Isaac.GetEntityVariantByName("Peamonger") then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local room = game:GetRoom()

  if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * (npc.StateFrame/72) + npc.Velocity * 0.95 end

  if npc.Variant == Isaac.GetEntityVariantByName("Peabody") then
    Utils.ReplaceChampSpritesheet(npc,0,"gfx/monsters/peabody")
    sprite:LoadGraphics()
  elseif npc.Variant == Isaac.GetEntityVariantByName("Peabody X") then
    Utils.ReplaceChampSpritesheet(npc,0,"gfx/monsters/peabody_x")
    sprite:LoadGraphics()
  elseif npc.Variant == Isaac.GetEntityVariantByName("Peamonger") then
    Utils.ReplaceChampSpritesheet(npc,0,"gfx/monsters/peamonger")
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    if sprite:IsFinished("Appear") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(-12, -8, -4)
    end

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("Fly")

    if room:CheckLine(npc.Position,target.Position,0,1,false,false) and utils.chancep(60) then
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
    end
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)

    if npc.StateFrame>=70 then
      sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0 , 1.2, 0, false, 1)
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Attack")

    npc.StateFrame = npc.StateFrame - 1
    npc.Velocity = npc.Velocity * 0.9
    if npc.StateFrame<66 then
      npc.StateFrame = npc.StateFrame - 1
    end

    if sprite:IsEventTriggered("Smack") then
      npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
      npc.StateFrame = npc.StateFrame - Utils.choose(20, 15, 10)
      if utils.chancep(80) and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
        local RCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, vectorZero, nil)
        if npc.Variant == Isaac.GetEntityVariantByName("Peamonger") then RCreep.SpriteScale = Vector(2,2) else RCreep.SpriteScale = Vector(1.25,1.25) end
          RCreep:Update()
      end

       for i=1, 4 do
          if npc.Variant == Isaac.GetEntityVariantByName("Peabody") then Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(i*90):Resized(10), npc) end
          if npc.Variant == Isaac.GetEntityVariantByName("Peabody X") then Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(45+i*90):Resized(10), npc) end
          if npc.Variant == Isaac.GetEntityVariantByName("Peamonger") then 
             for j=1, 3 do
               local params = ProjectileParams()
               params.FallingSpeedModifier = math.random(-28, -4)
               params.FallingAccelModifier = 1.2

               local velocity = Vector(Utils.choose(math.random(-6, -1), math.random(1, 6)), Utils.choose(math.random(-6, -1), math.random(1, 6))):Rotated(math.random(-30*i, 30*i))
               npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
             end
             Game():ShakeScreen(12)
          end
       end
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
    elseif sprite:IsEventTriggered("GetUp") then
      npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    end

    if sprite:IsFinished("Attack") then
      npc.State = NpcState.STATE_MOVE
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
