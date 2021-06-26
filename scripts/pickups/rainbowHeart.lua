local this = {
    variant = 10,
    subtype = 4000
}

-- MC_PRE_PICKUP_COLLISION
function this:collision(pickup, collider, low)
    if collider.Type == 1 and pickup.SubType == this.subtype then
	  collider = collider:ToPlayer()
      local sprite = pickup:GetSprite()
      if (sprite:IsPlaying("Idle") or (sprite:IsPlaying("Appear") and sprite:WasEventTriggered("DropSound"))) and collider:CanPickRedHearts() then
		collider:UseActiveItem(58,false)
        collider:AddHearts(20)
        sprite:Play("Collect")
        pickup.EntityCollisionClass = 0
		sfx:Play(SoundEffect.SOUND_THUMBSUP , 0.8, 0, false, 1.2)
        local poof = Isaac.Spawn(1000, 14, 0, pickup.Position, vectorZero, nil)
        poof:GetSprite():ReplaceSpritesheet(0,"gfx/effects/effect_poof.png")
        poof:GetSprite():LoadGraphics()
		
        return true
      end
    end
end

function this:updateHeart(pickup)
  if pickup.Variant == this.variant and pickup.SubType == this.subtype then
    if pickup:GetSprite():IsFinished("Collect") then
      pickup:Remove()
     end
  end
end

function this:pickupinit(pickup)
  if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_SCARED then
    delivRNG:SetSeed(pickup.InitSeed, 0)
      if delivRNG:RandomInt(25) == 1 then
        pickup:Morph(5,this.variant,this.subtype,true,true,false)
      end
    end
	
  if pickup.SubType == this.subtype then
    if pickup:IsShopItem() then
      pickup.Price = 5
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
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, this.collision, this.variant)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateHeart)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, this.pickupinit,this.variant)
end

return this