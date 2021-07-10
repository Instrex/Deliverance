local this = {}
this.id = Isaac.GetItemIdByName("Good Old Friend")
this.variant = Isaac.GetEntityVariantByName("Good Old Friend")
this.description = "Revives you once, dealing damage to all enemies in the room"
this.rusdescription ={"Good Old Friend /Старый добрый друг", "Воскрешает один раз, нанося урон всем врагам в комнате"}

function this:update()

  for _, player in pairs(Utils.GetPlayers()) do
  if player:HasCollectible(this.id) then
    if player:GetHearts() == 0 and player:GetSoulHearts() == 0
    and player:GetBoneHearts() == 0 and player:GetBlackHearts() == 0 then
      sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 0.9, 0, false, 1)
      player:Revive()
      player:AddSoulHearts(3)
      
      local bear = Isaac.Spawn(1000, this.variant, 0, player.Position, vectorZero, nil)
      bear:GetSprite():Play("Idle")

      if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        player:AddBoneHearts(2)
        player:AddSoulHearts(-2)
      end

      if player:GetPlayerType() == PlayerType.PLAYER_XXX or player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS
      or player:GetPlayerType() == PlayerType.PLAYER_JUDAS_B or player:GetPlayerType() == PlayerType.PLAYER_XXX_B
      or player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B  then
        print("good")
        player:AddSoulHearts(2)
      end

      player:SetFullHearts()
      player:RemoveCollectible(this.id)

      for e, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() then
          entity:TakeDamage(60, 0, EntityRef(nil), 0)
          entity:AddConfusion(EntityRef(nil), 120, false)
        end
      end
    end
  end
end
end

function this:bearUpdate(npc)
  if npc.Variant == this.variant then
    local sprite = npc:GetSprite()

    npc.Velocity = vectorZero

    if sprite:IsEventTriggered("Blink") then
      sfx:Play(SoundEffect.SOUND_1UP, 0.8, 0, false, 0.8)
    end

    if sprite:IsEventTriggered("Teleport") then
      sfx:Play(SoundEffect.SOUND_HELL_PORTAL1 , 0.8, 0, false, 1)
    end

    if sprite:IsFinished("Idle") then
      npc:Remove()
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.bearUpdate)
end

return this
