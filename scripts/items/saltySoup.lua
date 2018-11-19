local this = {}
this.id = Isaac.GetItemIdByName("Salty Soup")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    player:AddNullCostume(content.costumes.saltySoup)
    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then  
      player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(content.costumes.saltySoup), "gfx/costumes/sheet_costume_saltySoup_forgotten.png", 0)
    end
    if flag == CacheFlag.CACHE_SPEED then player.MoveSpeed = player.MoveSpeed - 0.08 end
    if flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = player.MaxFireDelay - 2 end
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
  
    
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR  , this.saltyTearUpdate)
end

return this
