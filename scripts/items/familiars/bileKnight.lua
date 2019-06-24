local this = {}
this.id = Isaac.GetItemIdByName("Bile Knight")
this.variant = Isaac.GetEntityVariantByName("Bile Knight")
this.description = "Rapidly shoots tears at enemies, hides till the end of the floor when taking damage"

function this:behaviour(fam)
    local sprite = fam:GetSprite()
    local player = Isaac.GetPlayer(0)
    local d = fam:GetData()
    if d.cooldown == nil then d.cooldown = 5 end
    if d.maxCooldown == nil then d.maxCooldown = 5 end
    if d.shoot == nil then d.shoot = false end
  
    fam:FollowParent()

    d.maxCooldown = 5
	
    if deliveranceData.temporary.knightStunned then
        sprite:Play("StunnedLoop", false)
    else
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
    else
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
    end
	
    if sprite:IsFinished("FloatShootUp") or sprite:IsFinished("FloatShootDown") or sprite:IsFinished("FloatShootSide") then
	d.cooldown = d.maxCooldown d.shoot = false
    end

   for i,proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, true)) do
     if (fam.Position:Distance(proj.Position) < proj.Size*2 + fam.Size) and not deliveranceData.temporary.knightStunned then
	proj:Die()
        Isaac.Spawn(1000, 97, 0, Vector(fam.Position.X, fam.Position.Y), vectorZero, nil)
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1)
        deliveranceData.temporary.knightStunned=true
        deliveranceDataHandler.directSave()
     end
   end
end

function this:awake(fam)
  fam:AddToFollowers()
end

function this.shot(fam)   
   local player = Isaac.GetPlayer(0)
   local d = fam:GetData() 
   local dirs = { [Direction.LEFT] = Vector(-15, 0), [Direction.UP] = Vector(0, -15), [Direction.RIGHT] = Vector(15, 0), [Direction.DOWN] = Vector(0, 15), [Direction.NO_DIRECTION] = vectorZero, }
   if not d.shoot then
      local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()] + player:GetTearMovementInheritance(player.Velocity), nil):ToTear()
      prj:GetSprite().Color = Color(0.75,0.75,1.2,1,15,8,15) if player:HasCollectible(247) then prj.Scale = 1.4 prj.CollisionDamage = 6.66 else prj.Scale = 1.2 prj.CollisionDamage = 5.5 end
      if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,math.floor(0.28*255),0,math.floor(0.45*255)) end
      d.shoot = true
   end
end

function this:restoreKnight()   
   if deliveranceData.temporary.knightStunned==true then
      deliveranceData.temporary.knightStunned=false
      for e, fam in pairs(Isaac.GetRoomEntities()) do 
        if fam.Type == 3 and fam.Variant == this.variant then 
           local sprite = fam:GetSprite()
           sprite:Play("FloatDown", false)
        end 
      end
      deliveranceDataHandler.directSave()
   end
end

function this:cache(player, flag)
  player:CheckFamiliar(this.variant, player:GetCollectibleNum(this.id) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1), RNG())
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, this.behaviour, this.variant)
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, this.awake, this.variant)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.restoreKnight)
end

return this
