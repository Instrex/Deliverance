local this = {}
this.id = Isaac.GetItemIdByName("Glass Crown")
this.description = "Gives a bonus to stats that will decrease if the character takes damage#Bonus will be restored on the next floor"
this.rusdescription ={"Glass Crown /—текл€нна€ корона", "ƒаЄт бонус к характеристикам котора€ будет уменьшатьс€ если персонаж получит урон#Ѕонус будет восстановлен на следующем этаже"}

this.bonusMulti = 3
 local bonus = {
  speed = 0.25,
  damage = 1.5,
  luck = 1,
  range = 0.75,
  shotspeed = 0.35,
  tears = 1
}

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if flag == CacheFlag.CACHE_SPEED then player.MoveSpeed = player.MoveSpeed + (bonus.speed * this.bonusMulti)
    elseif flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage + (bonus.damage * this.bonusMulti)
	  elseif flag == CacheFlag.CACHE_LUCK then player.Luck = player.Luck + (bonus.luck * this.bonusMulti)
	  elseif flag == CacheFlag.CACHE_RANGE then player.TearHeight = player.TearHeight - (bonus.range * this.bonusMulti)
	  elseif flag == CacheFlag.CACHE_SHOTSPEED then player.ShotSpeed = player.ShotSpeed + (bonus.shotspeed * this.bonusMulti)
    elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = player.MaxFireDelay - (bonus.tears * this.bonusMulti)
	  end
  end
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) and not deliveranceData.temporary.pickedup then
      this.bonusMulti = 3
      deliveranceData.temporary.pickedup = true
  end
  deliveranceDataHandler.directSave()
end


function this:trigger(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    --if deliveranceData.temporary.glasscrowngood then
    if this.bonusMulti > -1 then
      this.bonusMulti = this.bonusMulti - 1
    end
    deliveranceDataHandler.directSave()
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
  end
end

function this:updateFloor()
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if player:HasCollectible(this.id) then
    if this.bonusMulti < 3 then
      this.bonusMulti = 3
      player:AddCacheFlags(CacheFlag.CACHE_ALL)
      player:EvaluateItems()
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.updateFloor)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
end
  
return this