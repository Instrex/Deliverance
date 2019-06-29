local this = {
    variant = 10,
    subtype = 4000
}

-- MC_PRE_PICKUP_COLLISION 
--function this:collision(pickup, collider, low)
--    if pickup.Variant == this.variant and pickup.SubType == this.subtype then 
--        pickup:GetSprite():Play('Collect')
--    end
--end

function this:updateHeart(pickup)
  local player = Isaac.GetPlayer(0)
  if pickup.Variant == this.variant and pickup.SubType == this.subtype then 
     if player:GetHearts() < player:GetMaxHearts() then
        if (pickup.Position - player.Position):Length() <= pickup.Size + player.Size and not pickup:GetSprite():IsPlaying("Collect") then
           sfx:Play(SoundEffect.SOUND_THUMBSUP , 0.8, 0, false, 1.2)
           local poof = Isaac.Spawn(1000, 14, 0, pickup.Position, vectorZero, nil)
           poof:GetSprite():ReplaceSpritesheet(0,"gfx/effects/effect_poof.png")
           poof:GetSprite():LoadGraphics()
           player:AddHearts(20)
           pickup:Remove()
        end
     end
  end
  if pickup.Variant == PickupVariant.PICKUP_HEART then
      local data = pickup:GetData()
      if data.change == nil then
       if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_SCARED then
         if utils.chancep(1) and deliveranceData.persistent.awanAchievements[2] then
             Isaac.Spawn(5, 10, 4000, pickup.Position, vectorZero, nil)
             pickup:Remove()
         end
       end
       data.change = true
      end
  end
end

function this.Init() 
    --mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, this.collision, this.variant)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateHeart)
end

return this