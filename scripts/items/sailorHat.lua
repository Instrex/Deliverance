local this = {}
this.id = Isaac.GetItemIdByName("Sailor Hat")

function this:cache(player, flag)
  if player:HasCollectible(this.id) then
    player:AddNullCostume(content.costumes.sailorHat)
    if flag == CacheFlag.CACHE_SPEED then
     player.MoveSpeed = player.MoveSpeed + 0.2
    end
  end
end

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and player:HasCollectible(this.id) then
    if math.random(1, 6-(math.min(player.Luck, 4))) == 2 then
      Isaac.Spawn(1000, 54, 0, npc.Position, Vector(0, 0), player)
    end
  end
end

function this:onHit()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      Isaac.Spawn(1000, 54, 0, player.Position, Vector(0, 0), player)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHit, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
