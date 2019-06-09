local this = {}
this.id = Isaac.GetEntityTypeByName("Coin Altar")
this.variant = Isaac.GetEntityVariantByName("Coin Altar")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local sprite = npc:GetSprite()

  local data = npc:GetData()
  if deliveranceData.temporary.DonatedCoins == nil then deliveranceData.temporary.DonatedCoins = 0 end

  if data.Position == nil then data.Position = npc.Position end
  npc.Velocity = data.Position - npc.Position
  local room = game:GetRoom()

  local player = Isaac.GetPlayer(0)

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE
    
  elseif npc.State == NpcState.STATE_IDLE then
    
    sprite:Play("Idle")

      if (npc.Position - player.Position):Length() <= npc.Size + player.Size then
          if player:GetNumCoins() >= 1 then
              sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
              player:AddCoins(-1)
              deliveranceData.temporary.DonatedCoins = deliveranceData.temporary.DonatedCoins+1
              deliveranceDataHandler.directSave()
              sprite:LoadGraphics()
              npc.State = NpcState.STATE_ATTACK
              npc.StateFrame = -1
          end
      end

  elseif npc.State == NpcState.STATE_ATTACK then
    
    sprite:Play("StackUp")

    if sprite:IsFinished("StackUp") then
        if deliveranceData.temporary.DonatedCoins == 15 then
           Game():ShakeScreen(5)
           npc.State = NpcState.STATE_ATTACK2
        else
           npc.State = NpcState.STATE_IDLE
        end
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then
    
    sprite:Play("AltarGone")

    if sprite:IsEventTriggered("Prize") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
    end

    if sprite:IsEventTriggered("Teleport") then
      sfx:Play(SoundEffect.SOUND_HELL_PORTAL1 , 0.8, 0, false, 1)
    end

    if sprite:IsFinished("AltarGone") then
       deliveranceData.temporary.DonatedCoins={}
       npc:Remove()
    end
  end
 end
end

function this:onHitNPC(npc)
 if npc.Type == this.id  then
  if npc.Variant == this.variant then
    return false
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
