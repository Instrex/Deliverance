local this = {}
this.variant = Isaac.GetEntityVariantByName("Lil Bony Dies")
this.id = Isaac.GetEntityTypeByName("Lil Bony Dies")

function this:behaviour(npc)

  if npc.Variant == this.variant then
    local sprite = npc:GetSprite()

  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
 
    npc:SetSize(9, Vector(1,1), 12)
    npc.Scale = 0.75

  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("Start");
    npc:SetSize(9, Vector(1,1), 12)
    npc.Scale = 0.75

    if sprite:IsEventTriggered("Smirk") then
        sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 0.75)
    end

    if sprite:IsEventTriggered("Explosion") then
      if utils.chancep(40) then 
        sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
        Isaac.Spawn(1000, 97, 0, Vector(npc.Position.X, npc.Position.Y-4), vectorZero, nil)
        local rnd = math.random(-60, 60)
        for i=1, 3 do
           Isaac.Spawn(9, 1, 0, npc.Position, Vector.FromAngle(i*120+rnd):Resized(10), npc)
        end
        npc:Remove()
      end
    end

    if(sprite:IsFinished("Start")) then
        sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
        Isaac.Spawn(1000, 97, 0, Vector(npc.Position.X, npc.Position.Y-4), vectorZero, nil)
        local rnd = math.random(-60, 60)
        for i=1, 3 do
           Isaac.Spawn(9, 1, 0, npc.Position, Vector.FromAngle(i*120+rnd):Resized(10), npc)
        end
        npc:Remove()
    end
  end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
