local this = {}
this.id = Isaac.GetEntityTypeByName("Coin Altar")
this.variant = Isaac.GetEntityVariantByName("Coin Altar")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local sprite = npc:GetSprite()

  -- В начале нужно инициализировать data.persistent --
  local data = npc:GetData()
  data.persistent = data.persistent or { coins = 0 }
  data.Position = data.Position or npc.Position

  -- Затем, если этот объект не имеет присвоенного индекса, задать его и загрузить данные(если имеются) --
  if not data._index then 
    data._index = npcPersistence.initEntity(npc)
  end

  npc.Velocity = data.Position - npc.Position
  --local room = game:GetRoom()

  local player = Isaac.GetPlayer(0)

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE
    npc:ClearEntityFlags(npc:GetEntityFlags()) 
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    
  elseif npc.State == NpcState.STATE_IDLE then
    
    sprite:Play("Idle")

      if (npc.Position - player.Position):Length() <= npc.Size + player.Size then
          if player:GetNumCoins() >= 1 then
              sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
              player:AddCoins(1)
              print(data._index..': '..data.persistent.coins)

              -- При обновлении переменных необходимо вызывать npcPersistence.update(npc) --
              data.persistent.coins = data.persistent.coins + 1
              npcPersistence.update(npc)

              sprite:LoadGraphics()
              npc.State = NpcState.STATE_ATTACK
              npc.StateFrame = -1
          end
      end

  elseif npc.State == NpcState.STATE_ATTACK then
    
    sprite:Play("StackUp")

    if sprite:IsFinished("StackUp") then
        if data.persistent.coins == 15 then
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
       -- При удалении нпс нужно вызывать npcPersistence.remove(npc) --
       npcPersistence.remove(npc)
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
