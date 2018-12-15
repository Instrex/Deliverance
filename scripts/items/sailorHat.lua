local this = {}
this.id = Isaac.GetItemIdByName("Sailor Hat")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if not deliveranceData.temporary.hasSailorHat then
      deliveranceData.temporary.hasSailorHat = true
      deliveranceDataHandler.directSave()
      player:AddNullCostume(deliveranceContent.costumes.sailorHat)
      if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.2
      end
    end
  end
end

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and player:HasCollectible(this.id) then
    if math.random(1, 4-(math.min(player.Luck, 2))) == 2 then
      local creep = Isaac.Spawn(1000, 54, 0, npc.Position, Vector(0, 0), player)
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
      Isaac.Spawn(1000, 54, 0, player.Position, Vector(0, 0), player)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHit, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
