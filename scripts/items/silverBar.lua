local this = {}
this.id = Isaac.GetItemIdByName("Silver Bar")
this.description = "Gives a laser shot that wraps around character and deals damage"
this.rusdescription ={"Silver Bar /—еребр€ный слиток", "ƒарует лазерный выстрел, который оборачиваетс€ вокруг персонажа и наносит урон"}
this.bTimer = 0

function this:cache(player, flag)
    if flag == CacheFlag.CACHE_TEARCOLOR and player:HasCollectible(this.id) then
        player.Color = Color(0.6,0.6,1,1,10/255,10/255,10/255)
    end
end

function this:laserUpdate(player)
  if player:HasCollectible(this.id) then
    if this.bTimer<21 then this.bTimer=this.bTimer+1 end
    if player:GetFireDirection() ~= Direction.NO_DIRECTION then
      if this.bTimer>=21 then
       this.bTimer=0 
       local angle = 0
	   local offset = 0
       local gD = player:GetFireDirection()
       if gD == Direction.RIGHT then angle = 180 offset = Vector(12,-15) end
       if gD == Direction.DOWN then angle = 270 offset = Vector(0,-10) end
       if gD == Direction.LEFT then angle = 0 offset = Vector(-12,-15) end
       if gD == Direction.UP then angle = 90 offset = Vector(0,-35) end
       local laser = EntityLaser.ShootAngle(2, player.Position, angle, 7, offset, player)
       laser:GetSprite().Color = Color(0,0.5,0,1,225/255,225/255,225/255) laser.TearFlags = TearFlags.TEAR_ORBIT 
       laser.CollisionDamage = 0.33*player.Damage
       laser:SetMaxDistance(20)
      end
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.laserUpdate)
end

return this
