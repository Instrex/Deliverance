local this = {}
this.id = Isaac.GetItemIdByName("Lil Tummy")
this.variant = Isaac.GetEntityVariantByName("Lil Tummy")
this.description = "Shoots six tears in different directions"
this.rusdescription ={"Lil Tummy /Животик-младший", "Стреляет шестью снарядами в разных направлениях"}

function this:behaviour(fam)
    local sprite = fam:GetSprite()
    local player = Isaac.GetPlayer(0)
    local d = fam:GetData()
    if d.cooldown == nil then d.cooldown = 21 end
    if d.shoot == nil then d.shoot = false end

    fam:FollowParent()
	
    if player:HasTrinket(127) then  
      sprite:ReplaceSpritesheet(0,"gfx/familiars/familiar_lilTummy2.png")
      sprite:LoadGraphics()
    else  
      sprite:ReplaceSpritesheet(0,"gfx/familiars/familiar_lilTummy.png")
      sprite:LoadGraphics()
    end
    if d.cooldown>0 then
        if not player:IsDead() then d.cooldown = d.cooldown - 1 end
		
        if player:GetFireDirection() == Direction.UP then
            sprite:Play("FloatUp", false)
        elseif player:GetFireDirection() == Direction.DOWN then
            sprite:Play("FloatDown", false)
        elseif player:GetFireDirection() == Direction.LEFT then
            sprite:Play("FloatSide", false)
            sprite.FlipX = true
        elseif player:GetFireDirection() == Direction.RIGHT then
            sprite:Play("FloatSide", false)
            sprite.FlipX = false
	else 
            sprite:Play("FloatDown", false)
        end
    elseif not d.shoot then
        if player:GetFireDirection() == Direction.UP then
            sprite:Play("FloatShootUp", false)
            this.shot(fam)
        elseif player:GetFireDirection() == Direction.DOWN then
            sprite:Play("FloatShootDown", false)
            this.shot(fam)
        elseif player:GetFireDirection() == Direction.LEFT then
            sprite:Play("FloatShootSide", false)
            this.shot(fam)
            sprite.FlipX = true
        elseif player:GetFireDirection() == Direction.RIGHT then
            sprite:Play("FloatShootSide", false)
            this.shot(fam)
            sprite.FlipX = false
	    end
    end
	
    if sprite:IsFinished("FloatShootUp") or sprite:IsFinished("FloatShootDown") or sprite:IsFinished("FloatShootSide") then
	    d.cooldown = 24 d.shoot = false
    end

end

function this.shot(fam)   
   local player = Isaac.GetPlayer(0)
   local d = fam:GetData() 
      local dirs = { [Direction.LEFT] = Vector(-12.5, 0), [Direction.UP] = Vector(0, -12.5), [Direction.RIGHT] = Vector(12.5, 0), [Direction.DOWN] = Vector(0, 12.5), [Direction.NO_DIRECTION] = vectorZero, }
      if not d.shoot then
      sfx:Play(108, 1, 0, false, 1.5)
        for i=1, 6 do
          local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()]:Rotated(i*60), nil):ToTear()
          if player:HasCollectible(247) then prj.Scale = 0.95 prj.CollisionDamage = 4 else prj.Scale = 0.75 prj.CollisionDamage = 2.5 end
          if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,0.28,0,0.45) end
        end
        d.shoot = true
      end
end

function this:awake(fam)
  fam:AddToFollowers()
end

function this:cache(player, flag)
  player:CheckFamiliar(this.variant, player:GetCollectibleNum(this.id) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1), RNG())
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, this.behaviour, this.variant)
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, this.awake, this.variant)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.cache)
end

return this
