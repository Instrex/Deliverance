local this = {}
this.id = Isaac.GetItemIdByName("Sailor Hat")
this.description = "Creates large damaging puddles when tear hits the enemy"

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    --if not deliveranceData.temporary.hasSailorHat then
    --  deliveranceData.temporary.hasSailorHat = true
    --  deliveranceDataHandler.directSave()
      if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.2
      elseif flag == CacheFlag.CACHE_TEARCOLOR then
         player:AddNullCostume(deliveranceContent.costumes.sailorHat)
      end
    --end
  end
end

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and player:HasCollectible(this.id) then
    if math.random(1, 4-(math.min(player.Luck, 2))) == 2 then
      local creep = Isaac.Spawn(1000, 54, 0, npc.Position, vectorZero, player)
      if npc:IsBoss() then
         creep.SpriteScale = Vector(2.6,2.6)
      else
         creep.SpriteScale = Vector(0.5+npc.MaxHitPoints / 60,0.5+npc.MaxHitPoints / 60)
      end
      creep:Update()
    end
  end
end

function this:onHit()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      Isaac.Spawn(1000, 54, 0, player.Position, vectorZero, player)
  end
end

function this:update(player)
  if player:HasCollectible(this.id) then
      player:AddCacheFlags(CacheFlag.CACHE_SPEED)
      player:EvaluateItems()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHit, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
end

return this
