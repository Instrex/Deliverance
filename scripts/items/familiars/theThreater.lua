local this = {}
this.id = Isaac.GetItemIdByName("The Threater")
this.variant = Isaac.GetEntityVariantByName("The Threater")
this.description = "Strikes groups of enemies with lightning#Lightning shifts between enemies"
this.rusdescription ={"The Threater /Угрожающий", "Поражает группы врагов молнией#Молния проходит сквозь врагов"}

function this:behaviour(fam)
    local sprite = fam:GetSprite()
    local player = Isaac.GetPlayer(0)
    local d = fam:GetData()
    if d.cooldown == nil then d.cooldown = 12 end
    if d.maxCooldown == nil then d.maxCooldown = 12 end
    if d.shoot == nil then d.shoot = false end
  
    fam:FollowParent()

    d.maxCooldown = 10
	
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
	
	if sprite:IsFinished("FloatShootUp") or sprite:IsFinished("FloatShootDown") or sprite:IsFinished("FloatShootSide") then
	    d.cooldown = d.maxCooldown d.shoot = false
	end
end

function this:awake(fam)
  fam:AddToFollowers()
end

function this.shot(fam)   
   local player = Isaac.GetPlayer(0)
   local d = fam:GetData() 
   if not d.shoot then
       local angle = 0
       local gD = player:GetFireDirection()
       if gD == Direction.RIGHT then angle = 0 end
       if gD == Direction.DOWN then angle = 90 end
       if gD == Direction.LEFT then angle = 180 end
       if gD == Direction.UP then angle = 270 end
       for e, entity in pairs(Isaac.GetRoomEntities()) do 
          if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and entity:IsVulnerableEnemy() then 
             if (gD == Direction.RIGHT and entity.Position.X>fam.Position.X and entity.Position.Y<fam.Position.Y+64 and entity.Position.Y>fam.Position.Y-64) or
                (gD == Direction.DOWN and entity.Position.Y>fam.Position.Y and entity.Position.X<fam.Position.X+64 and entity.Position.X>fam.Position.X-64) or
                (gD == Direction.LEFT and entity.Position.X<fam.Position.X and entity.Position.Y<fam.Position.Y+64 and entity.Position.Y>fam.Position.Y-64) or
                (gD == Direction.UP and entity.Position.Y<fam.Position.Y and entity.Position.X<fam.Position.X+64 and entity.Position.X>fam.Position.X-64) then 
                   dist = fam.Position:Distance(entity.Position)+16
                   local laser2 = EntityLaser.ShootAngle(2, fam.Position, (fam.Position - entity.Position):GetAngleDegrees()+180, 5, Vector(0,-20), fam)
                   laser2:GetSprite().Color = Color(0,0.5,0,1,225/255,225/255,225/255) if player:HasTrinket(127) then laser2.TearFlags = TearFlags.TEAR_HOMING end
                   if player:HasCollectible(247) then laser2.CollisionDamage = 0.45 else laser2.CollisionDamage = 0.3 end
                   laser2:SetMaxDistance(dist)
                   local laser3 = EntityLaser.ShootAngle(2, entity.Position, math.random(0, 360), 5, vectorZero, fam)
                   laser3:GetSprite().Color = Color(0,0.5,0,1,225/255,225/255,225/255) if player:HasTrinket(127) then laser3.TearFlags = TearFlags.TEAR_HOMING end
                   if player:HasCollectible(247) then laser3.CollisionDamage = 0.225 else laser3.CollisionDamage = 0.15 end
                   laser3:SetMaxDistance(dist/2)
             end
          end 
       end
       local laser = EntityLaser.ShootAngle(2, fam.Position, angle, 5, Vector(0,-20), fam)
       laser:GetSprite().Color = Color(0,0.5,0,1,225/255,225/255,225/255) if player:HasTrinket(127) then laser.TearFlags = TearFlags.TEAR_HOMING end
       if player:HasCollectible(247) then laser.CollisionDamage = 0.9 else laser.CollisionDamage = 0.6 end
       
       d.shoot = true
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
end

return this
