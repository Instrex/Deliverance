local this = {}
this.id = Isaac.GetEntityTypeByName("Explosimaw")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
  
  if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * (npc.StateFrame/50) + npc.Velocity * 0.85 end
  
  npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS 
  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("Fly")

    if npc.Position:Distance(target.Position) <= 150 then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame>=60 then
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Attack")

    if sprite:IsEventTriggered("Dash") then
       sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_1 , 1.2, 0, false, 1.1)
       npc.StateFrame = 75
    end

    if sprite:IsEventTriggered("Fall") then
       npc.StateFrame = 32
       npc.Velocity = npc.Velocity * 0.66
    end

    if(sprite:IsFinished("Attack")) then
       Isaac.Explode(npc.Position, npc, 1.0)
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
       npc:Remove()
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
