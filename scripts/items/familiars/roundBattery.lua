local this = {}
this.id = Isaac.GetItemIdByName("Edgeless Cube Battery")
this.variant = Isaac.GetEntityVariantByName("Round Battery")
this.description = "Shoots lasers every time enemy projectile hit it"

function this:behaviour(fam)
  local sprite = fam:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = fam:GetData()
  
  if data.shooting == nil then data.shooting = 0 end

  if data.shooting == 1 then
    sprite:Play("Charge")

    if sprite:IsEventTriggered("Shoot") then
       local laser = EntityLaser.ShootAngle(2, fam.Position, math.random(0, 360), 15, Vector(0,-15), fam)
       laser:GetSprite().Color = Color(0,0.5,0,1,200,180,0) laser.TearFlags = TearFlags.TEAR_HOMING
       laser.CollisionDamage = player.Damage*0.8
    end

    if sprite:IsFinished("Charge") then
       data.shooting = 0
    end
  elseif data.shooting == 2 then
    sprite:Play("Charge2")

    if sprite:IsEventTriggered("Shoot") then
       local laser = EntityLaser.ShootAngle(2, fam.Position, math.random(0, 360), 15, Vector(0,-15), fam)
       laser:GetSprite().Color = Color(0,0.5,0,1,200,180,0) laser.TearFlags = TearFlags.TEAR_HOMING
       laser.CollisionDamage = player.Damage*0.8
    end

    if sprite:IsFinished("Charge2") then
       data.shooting = 0
    end
  else
    sprite:Play("Idle") 
  end

  for i,proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, true)) do
     if (fam.Position:Distance(proj.Position) < proj.Size*2 + fam.Size) and data.shooting == 0 then
	proj:Die()
	if player:HasCollectible(247) then data.shooting = 1 else data.shooting = 2 end
     end
  end

  fam:FollowParent()
end

function this:awake(fam)
  fam:AddToFollowers()
end

function this:cache(player, flag)
  player:CheckFamiliar(this.variant, player:GetCollectibleNum(this.id) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1), RNG())
end

function this.use()
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     local data = entity:GetData()
     if entity.Variant == this.variant then 
        if data.shooting == 0 then
           data.shooting = 1
        end
     end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, this.behaviour, this.variant)
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, this.awake, this.variant)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.cache)
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use)
end

return this