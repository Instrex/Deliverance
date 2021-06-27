local this = {}
this.id = Isaac.GetItemIdByName("Dermoid Cyst")
this.description = ""
this.rusdescription ={""}

function this:update(player)
  if player:HasCollectible(this.id) then
	  player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
      player:EvaluateItems()
  end
end


function this:cache(player, flag)
  if player:HasCollectible(this.id) then
	 if flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage -1.50
	 elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = Utils.tearsUp(player.MaxFireDelay, 3)
     end
  end
end

function this:TearUpdate(tear)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
     tear.Velocity = tear.Velocity:Rotated(math.random(-50, 50))
	 tear:ChangeVariant(TearVariant.BLOOD)
	 tear.Scale = tear.Scale + 0.25
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, this.TearUpdate)
end

return this
