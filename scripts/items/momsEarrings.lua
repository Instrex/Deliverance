local this = {}
this.id = Isaac.GetItemIdByName("Mom's Earrings")
this.description = "Increases your damage in proportion to number of enemies in the room"

this.damageBonus = 0

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_DAMAGE then
	 player.Damage = player.Damage * this.damageBonus end
  end
end

function this.checkForEnemies()
  local count = 0
  for _, entity in pairs(Isaac.GetRoomEntities()) do
    if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and entity:IsVulnerableEnemy() then count = count + 1 end
  end
  return count
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    this.damageBonus = 1+this.checkForEnemies()*0.033
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
end

return this
