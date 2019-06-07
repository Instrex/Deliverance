local this = {}
this.id = Isaac.GetItemIdByName("Sister's Heart")
this.variant = Isaac.GetEntityVariantByName("Sister's Heart")

function this.checkEnemies()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e:IsVulnerableEnemy() then count = count + 1 end
  end

  return count
end

function this:behaviour(fam)
  local sprite = fam:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = fam:GetData()

  if player:GetPlayerType() == PlayerType.PLAYER_XXX then  
    sprite:ReplaceSpritesheet(1,"gfx/familiars/familiar_itlives2.png")
    sprite:LoadGraphics()
  elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then  
    sprite:ReplaceSpritesheet(1,"gfx/familiars/familiar_itlives3.png")
    sprite:LoadGraphics()
  else  
    sprite:ReplaceSpritesheet(1,"gfx/familiars/familiar_itlives.png")
    sprite:LoadGraphics()
  end

  if player:GetFireDirection() == Direction.NO_DIRECTION then
    if this.checkEnemies() >= 1 then
       sprite:Play("Shoot")
    else
       sprite:Play("Idle")
    end
  else
    sprite:Play("Intense")
  end

  if sprite:IsEventTriggered("Shoot") then
    sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTER, 1, 0, false, 1)
       if utils.chancep(50) then
          local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 1, fam.Position + Vector(0, 15), Vector(-3,0):Rotated(math.random(0, 360)), nil):ToTear()
          if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,math.floor(0.28*255),0,math.floor(0.45*255)) end
          if player:HasCollectible(247) then prj.Scale = 0.9 prj.CollisionDamage = 4.5 else prj.Scale = 0.7 prj.CollisionDamage = 3 end
       end
  end

  if sprite:IsEventTriggered("IntenseShoot") then
    data.offset = (data.offset or -1) + 1

    if player:GetHearts() <= 1 or data.offset % 2 == 0 then
      sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTEST, 1, 0, false, 1)
      for i=1, 4 do
        local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, fam.Position + Vector(0, 15), Vector(7, 0):Rotated(10 * data.offset + i*90), nil):ToTear()
        if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,math.floor(0.28*255),0,math.floor(0.45*255)) end
        if player:HasCollectible(247) then prj.Scale = 0.9 prj.CollisionDamage = 4.5 else prj.Scale = 0.7 prj.CollisionDamage = 3 end
      end
    end
  end

  if fam.Variant == this.variant then
  if player:GetFireDirection() == Direction.NO_DIRECTION then
    fam:FollowParent()
  else fam.Velocity = fam.Velocity * 0.9 end
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
