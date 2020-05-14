local this = {}
this.id = Isaac.GetItemIdByName("Glass Crown")
this.description = "Don't drop it"
this.rusdescription ={"Glass Crown /Стеклянная корона", "-"}

 local bonus = {
  speed = 0.5,
  damage = 5,
  luck = 3,
  range = 10,
  shotspeed = 2,
  tears = 5
}

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if deliveranceData.temporary.glasscrowngood==nil then
       deliveranceData.temporary.glasscrowngood=true
       deliveranceDataHandler.directSave()
    end
    if flag == CacheFlag.CACHE_SPEED then player.MoveSpeed = player.MoveSpeed + bonus.speed
    elseif flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage + bonus.damage
	  elseif flag == CacheFlag.CACHE_LUCK then player.Luck = player.Luck + bonus.luck
	  elseif flag == CacheFlag.CACHE_RANGE then player.TearHeight = player.TearHeight - bonus.range
	  elseif flag == CacheFlag.CACHE_SHOTSPEED then player.ShotSpeed = player.ShotSpeed + bonus.shotspeed
	  elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = player.MaxFireDelay - bonus.tears
	  end
  end
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if deliveranceData.temporary.glasscrowngood==nil then
      deliveranceData.temporary.glasscrowngood=true
      deliveranceDataHandler.directSave()
    end
    if deliveranceData.temporary.glasscrowngood then
      bonus.speed = 0.5
      bonus.damage = 5
      bonus.luck = 3
      bonus.range = 10
      bonus.shotspeed = 2
      bonus.tears = 5
    else
      bonus.speed = 1
      bonus.damage = 1
      bonus.luck = 1
      bonus.range = 1
      bonus.shotspeed = 1
      bonus.tears = 1
    end
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()
  end
end


function this:trigger(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if deliveranceData.temporary.glasscrowngood then
      deliveranceData.temporary.glasscrowngood=false
      deliveranceDataHandler.directSave()
    end
  end
end

function this:updateFloor()
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if player:HasCollectible(this.id) then
    deliveranceData.temporary.glasscrowngood=true
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.updateFloor)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  end
  
return this