local this = {}
this.id = Isaac.GetItemIdByName("Scaredy-shroom")
this.variant = Isaac.GetEntityVariantByName("Scaredy-shroom")

function this:behaviour(fam)
    local sprite = fam:GetSprite()
    local player = Isaac.GetPlayer(0)
    local d = fam:GetData()
    if d.cooldown == nil then d.cooldown = 4 end
    if d.shoot == nil then d.shoot = false end
    if d.scared == nil then d.scared = false end

    fam:FollowParent()
	
    local count = 0

    for _, e in pairs(Isaac.GetRoomEntities()) do
       if e:IsVulnerableEnemy() and fam.Position:Distance(e.Position) < 100 then count = count + 1 end
    end 

    d.scared = count > 0

    if not d.scared then
      if d.cooldown>0 then
        if not player:IsDead() then d.cooldown = d.cooldown - 1 end
		
        if player:GetFireDirection() == Direction.UP then
            sprite:Play("FloatUp", false)
        elseif player:GetFireDirection() == Direction.DOWN then
            sprite:Play("FloatDown", false)
        elseif player:GetFireDirection() == Direction.LEFT then
            sprite:Play("FloatLeft", false)
        elseif player:GetFireDirection() == Direction.RIGHT then
            sprite:Play("FloatRight", false)
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
            sprite:Play("FloatShootLeft", false)
            this.shot(fam)
        elseif player:GetFireDirection() == Direction.RIGHT then
            sprite:Play("FloatShootRight", false)
            this.shot(fam)
	    end
      end
    elseif d.scared then
      if player:GetFireDirection() == Direction.UP then
          sprite:Play("ScaredUp", false)
      elseif player:GetFireDirection() == Direction.DOWN then
          sprite:Play("ScaredDown", false)
      elseif player:GetFireDirection() == Direction.LEFT then
          sprite:Play("ScaredLeft", false)
      elseif player:GetFireDirection() == Direction.RIGHT then
          sprite:Play("ScaredRight", false)    
      else 
          sprite:Play("ScaredDown", false)
      end
      d.cooldown = 4 d.shoot = false
    end
	
    if sprite:IsFinished("FloatShootUp") or sprite:IsFinished("FloatShootDown") or sprite:IsFinished("FloatShootRight") or sprite:IsFinished("FloatShootLeft") then
	    d.cooldown = 4 d.shoot = false
    end
end

function this.shot(fam)   
   local player = Isaac.GetPlayer(0)
   local d = fam:GetData() 
      local dirs = { [Direction.LEFT] = Vector(-12.5, 0), [Direction.UP] = Vector(0, -12.5), [Direction.RIGHT] = Vector(12.5, 0), [Direction.DOWN] = Vector(0, 12.5), [Direction.NO_DIRECTION] = vectorZero, }
      if not d.shoot then
        local prj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()], nil):ToTear()
        prj:GetSprite().Color = Color(0.4,0.15,0.15,1,math.floor(0.28*255),0,math.floor(0.45*255))
        if player:HasCollectible(247) then prj.Scale = 0.95 prj.CollisionDamage = 2.25 else prj.Scale = 0.75 prj.CollisionDamage = 1.5 end
        if player:HasTrinket(127) then prj.TearFlags = TearFlags.TEAR_HOMING end
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
