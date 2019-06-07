local this = {}
this.id = Isaac.GetItemIdByName("Salty Soup")

function this:cache(player, flag)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_SPEED then player.MoveSpeed = player.MoveSpeed - 0.09
      elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = player.MaxFireDelay - 2 
      elseif flag == CacheFlag.CACHE_TEARCOLOR then
         player:AddNullCostume(deliveranceContent.costumes.saltySoup)
      end
  end
end

function this:update(player)
  if player:HasCollectible(this.id) then
     if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.saltySoup), "gfx/characters/costumes_forgotten/sheet_costume_saltySoup_forgotten.png", 0)
     end
      player:AddCacheFlags(CacheFlag.CACHE_SPEED)
      player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
      player:EvaluateItems()
  end
end

function this:saltyTearUpdate(tear)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    tear.Velocity = tear.Velocity:Rotated(math.random(-10,10))
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, this.saltyTearUpdate)
end

return this
