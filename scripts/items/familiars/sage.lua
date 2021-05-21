local this = {}
this.id = Isaac.GetItemIdByName("Sage")
this.variant = Isaac.GetEntityVariantByName("Sage")
this.description = "Shoots tears at enemies, increasing number of tears fired when damage taken"
this.rusdescription ={"Sage /Шалфей", "Стреляет во врагов пурпурными слезами, количество которых увеличивается каждый раз, когда вы получаете урон"}

function this:behaviour(fam)
    local sprite = fam:GetSprite()
    local player = Isaac.GetPlayer(0)
    local d = fam:GetData()
    if d.cooldown == nil then d.cooldown = 8 end
    if d.maxCooldown == nil then d.maxCooldown = 8 end
    if d.shoot == nil then d.shoot = false end
    if d.multiplier == nil then d.multiplier = 0 end
  
    fam:FollowParent()

    d.maxCooldown = 8 + d.multiplier*3

    if d.multiplier<1 then  
      sprite:ReplaceSpritesheet(0,"gfx/familiars/familiar_sage.png")
      sprite:ReplaceSpritesheet(1,"gfx/familiars/familiar_sage.png")
      sprite:ReplaceSpritesheet(2,"gfx/familiars/familiar_sage.png")
      sprite:LoadGraphics()
    else  
      sprite:ReplaceSpritesheet(0,"gfx/familiars/familiar_sage2.png")
      sprite:ReplaceSpritesheet(1,"gfx/familiars/familiar_sage.png")
      sprite:ReplaceSpritesheet(2,"gfx/familiars/familiar_sage.png")
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
   local dirs = { [Direction.LEFT] = Vector(-15+d.multiplier, 0), [Direction.UP] = Vector(0, -15+d.multiplier), [Direction.RIGHT] = Vector(15-d.multiplier, 0), [Direction.DOWN] = Vector(0, 15-d.multiplier), [Direction.NO_DIRECTION] = vectorZero, }
   if not d.shoot then
      if d.multiplier == 0 then
         local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()] + player:GetTearMovementInheritance(player.Velocity), nil):ToTear()
         prj:GetSprite().Color = Color(0.75,0.75,1.2,1,15/255,8/255,15/255) if player:HasCollectible(247) then prj.Scale = 1.4 prj.CollisionDamage = 7 else prj.Scale = 1.25 prj.CollisionDamage = 5.5 end
         if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,0.28,0,0.45) end
      elseif d.multiplier == 1 then
         for i=1, 2 do
            local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()]:Rotated(-12+i*8) + player:GetTearMovementInheritance(player.Velocity), nil):ToTear()
            prj:GetSprite().Color = Color(0.75,0.75,1.2,1,15/255,8/255,15/255) if player:HasCollectible(247) then prj.Scale = 1.35 prj.CollisionDamage = 6.5 else prj.Scale = 1.2 prj.CollisionDamage = 4.9 end
            if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,0.28,0,0.45) end
         end
      elseif d.multiplier == 2 then
         for i=1, 3 do
            local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()]:Rotated(-12+i*6) + player:GetTearMovementInheritance(player.Velocity), nil):ToTear()
            prj:GetSprite().Color = Color(0.75,0.75,1.2,1,15/255,8/255,15/255) if player:HasCollectible(247) then prj.Scale = 1.25 prj.CollisionDamage = 5.9 else prj.Scale = 1.1 prj.CollisionDamage = 4.3 end
            if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,0.28,0,0.45) end
         end
      elseif d.multiplier == 3 then
         for i=1, 4 do
            local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()]:Rotated(-10+i*4) + player:GetTearMovementInheritance(player.Velocity), nil):ToTear()
            prj:GetSprite().Color = Color(0.75,0.75,1.2,1,15/255,8/255,15/255) if player:HasCollectible(247) then prj.Scale = 1.13 prj.CollisionDamage = 5.2 else prj.Scale = 1 prj.CollisionDamage = 3.7 end
            if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,0.28,0,0.45) end
         end
      elseif d.multiplier >= 4 then
         for i=1, 5 do
            local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()]:Rotated(-9+i*3) + player:GetTearMovementInheritance(player.Velocity), nil):ToTear()
            prj:GetSprite().Color = Color(0.75,0.75,1.2,1,15/255,8/255,15/255) if player:HasCollectible(247) then prj.Scale = 1 prj.CollisionDamage = 4.5 else prj.Scale = 0.9 prj.CollisionDamage = 3 end
            if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING prj:GetSprite().Color = Color(0.4,0.15,0.15,1,0.28,0,0.45) end
         end
      end
     
      d.shoot = true
   end
end

function this:cache(player, flag)
  player:CheckFamiliar(this.variant, player:GetCollectibleNum(this.id) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1), RNG())
end

function this.trigger(id)
  local player = Isaac.GetPlayer(0)
  for e, fam in pairs(Isaac.GetRoomEntities()) do
    d = fam:GetData()
    if fam.Type == EntityType.ENTITY_FAMILIAR and fam.Variant == this.variant then
       sfx:Play(169, 0.9, 0, false, 0.6+d.multiplier/10)
       if d.multiplier < 4 then d.multiplier = d.multiplier + 1 end
       Isaac.Spawn(1000, 97, 0, Vector(fam.Position.X, fam.Position.Y-20), vectorZero, nil)
    end
  end
end

function this:update()
  for e, fam in pairs(Isaac.GetRoomEntities()) do
    d = fam:GetData()
    if fam.Type == EntityType.ENTITY_FAMILIAR and fam.Variant == this.variant then
      d.multiplier=0
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, this.behaviour, this.variant)
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, this.awake, this.variant)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.cache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.update)
end

return this
