local this = {}
this.id = Isaac.GetItemIdByName("Good Old Friend")

function this:update()

  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if player:GetHearts() == 0 and player:GetSoulHearts() == 0
    and player:GetBoneHearts() == 0 and player:GetBlackHearts() == 0 then
      SFXManager():Play(SoundEffect.SOUND_SUPERHOLY, 0.45, 0, false, 1)
      SFXManager():Play(SoundEffect.SOUND_HAPPY_RAINBOW, 0.9, 0, false, 1)
      player:Revive()
      player:AddSoulHearts(2)

      if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        player:AddBoneHearts(2)
        player:AddSoulHearts(-2)
      end

      if player:GetPlayerType() == PlayerType.XXX then
        player:AddSoulHearts(6)
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

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.update)
end

return this
