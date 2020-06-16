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
  local room = game:GetRoom()
  if pickup.Variant == this.variant and pickup.SubType == this.subtype then 
     if player:GetHearts() < player:GetEffectiveMaxHearts() then
        if (pickup.Position - player.Position):Length() <= pickup.Size + player.Size and not pickup:GetSprite():IsPlaying("Collect") then
           sfx:Play(SoundEffect.SOUND_THUMBSUP , 0.8, 0, false, 1.2)
           local poof = Isaac.Spawn(1000, 14, 0, pickup.Position, vectorZero, nil)
           poof:GetSprite():ReplaceSpritesheet(0,"gfx/effects/effect_poof.png")
           poof:GetSprite():LoadGraphics()
           player:UseActiveItem(58,false,false,false,false)
           player:AddHearts(20)
           pickup:Remove()
        end
     end
  end
  if Game():GetLevel():GetCurrentRoom():IsFirstVisit() then
  if pickup.Variant == PickupVariant.PICKUP_HEART then
      local data = pickup:GetData()
      if data.change == nil then
       if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_SCARED then
         if utils.chancep(2.15) then
            
             if pickup:IsShopItem() then
                local pick = Isaac.Spawn(5, 10, 4000, pickup.Position, vectorZero, nil)
                pick:ToPickup().Price = 5
              else
                Isaac.Spawn(5, 10, 4000, pickup.Position, vectorZero, nil)
             end
             
             pickup:Remove()
         end
       end
       data.change = true
      end
    end
  end
end

if MinimapAPI then

	local minimapIcons = Sprite()
	minimapIcons:Load("gfx/ui/minimapapi/deliverance_icons.anm2", true)
	minimapIcons:Play("DeliveranceIconFarewellStoneCard", true)
	
	MinimapAPI:AddIcon(
		"DeliveranceRainbowHeartIcon",
		minimapIcons,
		"DeliveranceIconRainbowHeart",
		0
	)
	
	MinimapAPI:AddPickup(
		"DeliveranceRainbowHeart",
		"DeliveranceRainbowHeartIcon",
		EntityType.ENTITY_PICKUP,
		this.variant,
		this.subtype,
		MinimapAPI.PickupNotCollected,
		"deliverancepickups",
		14000
	)
end

function this.Init() 
    --mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, this.collision, this.variant)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateHeart)
end

return this