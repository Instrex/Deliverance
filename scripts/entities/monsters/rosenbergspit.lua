local this = {}
this.id = Isaac.GetEntityTypeByName("Rosenberg Spit")
this.variant = Isaac.GetEntityVariantByName("Rosenberg Spit")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  if sprite:IsEventTriggered("ChangeColToAll") then
     npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY 
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE 
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
 
    
  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_IDLE then
    
    if data.GridCountdown == nil then data.GridCountdown = 0 end
    sprite:Play("Start")

    if sprite:IsEventTriggered("Drop") then
        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1.2, 0, false, 1)
        Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, player).Color = Color(0, 0, 0, 0.9, 10/255, 10/255, 10/255)
    end
    if sprite:IsFinished("Start") then
       npc:Remove()
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
          local creep =  Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CREEP_BLACK,1,npc.Position, vectorZero, npc)
          creep:GetSprite().Scale = Vector(2.5,2.5)
          creep:ToEffect().Timeout = 150
       
       Game():ShakeScreen(5)
    end

    npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.7 + npc.Velocity
  end
 end
end

function this:onHitNPC(npc)
  if npc.Type == Isaac.GetEntityTypeByName("Rosenberg Spit") and npc.Variant == Isaac.GetEntityVariantByName("Rosenberg Spit") then
    return false
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
