local this = {}
this.id = Isaac.GetItemIdByName("Beanborne")
this.variant = Isaac.GetEntityVariantByName("Beanborne")
this.projectile = Isaac.GetEntityVariantByName("Rotten Fart")
this.description = "Intensely farts, poisoning enemies#Creates a fly in every room you visit for the first time"
this.rusdescription ={"Beanborne /Боборождённый", "Интесивно пукает, отравляя врагов#Создает муху в каждой комнате которую вы посещаете в первый раз"}

function this:behaviour(fam)
    local sprite = fam:GetSprite()
    local player = Isaac.GetPlayer(0)
    local d = fam:GetData()
    if d.cooldown == nil then d.cooldown = 40 end
    if d.shoot == nil then d.shoot = false end

    fam:FollowParent()
	
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
	    d.cooldown = Utils.choose(30, 40, 50) d.shoot = false
    end

end


function this.shot(fam)   
   local player = Isaac.GetPlayer(0)
   local d = fam:GetData() 
      local fartSpeed = Utils.choose(11, 13, 15, 17)
      local dirs = { [Direction.LEFT] = Vector(-fartSpeed, 0), [Direction.UP] = Vector(0, -fartSpeed), [Direction.RIGHT] = Vector(fartSpeed, 0), [Direction.DOWN] = Vector(0, fartSpeed), [Direction.NO_DIRECTION] = vectorZero, }
      if not d.shoot then
        sfx:Play(SoundEffect.SOUND_FART , 0.4, 0, false, math.random(8, 14) / 10)
        local fart = Isaac.Spawn(1000, this.projectile, 0, fam.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()], fam)
        d.shoot = true
        fart:GetSprite():Play("Fart")
        local fartSize = Utils.choose(1.5, 1.75, 2)
        if player:HasCollectible(247) then fartSize = Utils.choose(2, 2.25, 2.5) else fartSize = Utils.choose(1.5, 1.75, 2) end
        fart:GetSprite().Scale = Vector(fartSize, fartSize)
        local data = fart:GetData()
        data.radius = 27*fartSize
        data.fartDamage = Utils.choose(0.15, 0.2, 0.25, 0.3, 0.33)
      end
end

function this.onNewRoom()
    for e, fam in pairs(Isaac.GetRoomEntities()) do 
        if fam.Type == 3 and fam.Variant == this.variant then 
           local room = game:GetRoom()
           if room:IsFirstVisit() then
               for i=1,Utils.choose(1,2) do Isaac.Spawn(3, 43, 0, fam.Position, vectorZero, fam) end
           end
        end
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
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.onNewRoom)
end

return this
