local this = {}
this.id = Isaac.GetItemIdByName("Glass Crown")
this.description = "Don't drop it"

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_SPEED then player.MoveSpeed = player.MoveSpeed + 0.5
      elseif flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage + 5
	  elseif flag == CacheFlag.CACHE_LUCK then player.Luck = player.Luck + 3
	  elseif flag == CacheFlag.CACHE_RANGE then player.TearHeight = player.TearHeight - 10.00
	  elseif flag == CacheFlag.CACHE_SHOTSPEED then player.ShotSpeed = player.ShotSpeed + 2
	  elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = player.MaxFireDelay -5
	  end
  end
end

function this.trigger(id)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      player:RemoveCollectible(this.id)
      end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  end
  
return this