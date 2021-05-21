local this = {}
this.id = Isaac.GetItemIdByName("Sailor Hat")
this.description = "\1 +0.2 Speed up#Creates large damaging puddles when tear hits the enemy"
this.rusdescription ={"Sailor Hat /Матросская шляпа", "©+0.2 к скорости#Оставляет большие лужи при попадании по врагам"}

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.2
      end
  end
end

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and not npc:IsDead() and player:HasCollectible(this.id) then
    if math.random(1, 4-(math.min(player.Luck, 2))) == 2 then
      local creep = Isaac.Spawn(1000, 54, 0, npc.Position, vectorZero, player)
      if npc:IsBoss() then
         creep.SpriteScale = Vector(math.random(0,2),math.random(0,2))
		 creep.CollisionDamage = (npc.MaxHitPoints/1000)
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
