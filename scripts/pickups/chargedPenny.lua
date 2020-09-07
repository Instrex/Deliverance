local this = {
  variant = 20,
  subtype = 4000
}

function this:updateCoin(pickup)
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if pickup.Variant == this.variant and pickup.SubType == this.subtype then
    if (pickup.Position - player.Position):Length() <= pickup.Size + player.Size and not pickup:GetSprite():IsPlaying("Collect") then
      sfx:Play(SoundEffect.SOUND_PENNYPICKUP , 0.8, 0, false, 1.2)
      player:AddCoins(1)
      player:SetActiveCharge(player:GetActiveCharge() + 1)
      pickup:Remove()
    end
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

function this.Init() 
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateCoin)
end

return this