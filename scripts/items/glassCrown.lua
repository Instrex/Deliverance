local this = {}
this.id = Isaac.GetItemIdByName("Glass Crown")
this.description = "Gives a bonus to stats that will decrease if the character takes damage#When receiving the third hit with this item, the crown breaks down"
this.rusdescription ={"Glass Crown /—текл€нна€ корона", "ƒаЄт бонус к характеристикам котора€ будет уменьшатьс€ если персонаж получит урон#ƒает бонус к статистике, котора€ будет уменьшатьс€, если персонаж получит урон#ѕосле получени€ третьего удара с этим предметом, корона ломаетс€"}

--add crown render later--


 local bonus = {
  speed = 0.15,
  damage = 0.85,
  luck = 1,
  range = 0.25,
  shotspeed = 0.10,
  tears = 1
}

function this:update(continue)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) and continue then
	  deliveranceData.temporary.glasscounter = deliveranceData.temporary.glasscounter or 3
	  player:AddCacheFlags(CacheFlag.CACHE_ALL)
	  player:EvaluateItems()
	  
	elseif not player:HasCollectible(this.id) then
		deliveranceData.temporary.glasscounter = nil
  end
  deliveranceDataHandler.directSave()
end

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
	deliveranceData.temporary.glasscounter = deliveranceData.temporary.glasscounter or 3
    if 	   flag == CacheFlag.CACHE_SPEED     then player.MoveSpeed = player.MoveSpeed + (bonus.speed * deliveranceData.temporary.glasscounter)
	elseif flag	== CacheFlag.CACHE_DAMAGE    then player.Damage = player.Damage + (bonus.damage * deliveranceData.temporary.glasscounter)
	elseif flag == CacheFlag.CACHE_LUCK      then player.Luck = player.Luck + (bonus.luck * deliveranceData.temporary.glasscounter)
	elseif flag == CacheFlag.CACHE_RANGE     then player.TearHeight = player.TearHeight - (bonus.range * deliveranceData.temporary.glasscounter)
	elseif flag == CacheFlag.CACHE_SHOTSPEED then player.ShotSpeed = player.ShotSpeed + (bonus.shotspeed * deliveranceData.temporary.glasscounter)
	elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = player.MaxFireDelay - (bonus.tears * deliveranceData.temporary.glasscounter)
	  end
  end
end

function this:trigger(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
  deliveranceData.temporary.glasscounter = deliveranceData.temporary.glasscounter or 3
	if deliveranceData.temporary.glasscounter then
      deliveranceData.temporary.glasscounter = deliveranceData.temporary.glasscounter - 1
	  player:AddCacheFlags(CacheFlag.CACHE_ALL)
	  player:EvaluateItems()
    deliveranceDataHandler.directSave()
	end
	if deliveranceData.temporary.glasscounter <= 0 then
		player:RemoveCollectible(this.id)
		deliveranceData.temporary.glasscounter = nil
	end
  end
end

function this:crownrender()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(this.id) then
		if crown ==nil then
		crown = Sprite()
		crown:Load("gfx/glassCrown.anm2", true)
		crown:Play("Idle",true)
	elseif crown then
		crown:Update()
	end
	crown:Render(Isaac.WorldToScreen(player.Position + Vector(0, player.Size)), vectorZero,vectorZero)
	end
end
--[[function this:updateFloor()
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if player:HasCollectible(this.id) then
    if this.bonusMulti < 3 then
      this.bonusMulti = 3
      player:AddCacheFlags(CacheFlag.CACHE_ALL)
      player:EvaluateItems()
    end
  end
end--]]

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.update)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  --mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.updateFloor)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.crownrender)
end
  
return this