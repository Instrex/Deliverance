local this = {
  variant = 20,
  subtype = 4000
}
-- MC_PRE_PICKUP_COLLISION 
function this:collision(pickup, collider, low)
  if collider.Type == 1 and pickup.SubType == this.subtype then
    local sprite = pickup:GetSprite()
    if sprite:IsPlaying("Idle") or sprite:IsFinished("Idle") or (sprite:IsPlaying("Appear") and sprite:WasEventTriggered("DropSound")) then
      sprite:Play("Collect")
      pickup.EntityCollisionClass = 0
      sfx:Play(SoundEffect.SOUND_PENNYPICKUP , 0.8, 0, false, 1.2)
      return true
    end
  end
end

function this:updateCoin(pickup)
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if pickup.Variant == this.variant and pickup.SubType == this.subtype then
    if pickup:GetSprite():IsFinished("Collect") then
      pickup:Remove()
    end
    if (pickup.Position - player.Position):Length() <= pickup.Size + player.Size and pickup.EntityCollisionClass ~= 0  then
      player:AddCoins(1)
      player:SetActiveCharge(player:GetActiveCharge() + 1)
    end

  if Game():GetLevel():GetCurrentRoom():IsFirstVisit() then
    if pickup.Variant == PickupVariant.PICKUP_COIN then
      local data = pickup:GetData()
      if data.change == nil then
        if pickup.SubType == CoinSubType.COIN_PENNY then
          if utils.chancep(1) and pickup.FrameCount == 1 then
            pickup:Morph(5, 20, 4000, false)
          end
        end
        data.change = true
      end
    end
  end
end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, this.collision, this.variant)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateCoin)
end

return this