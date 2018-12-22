local this = {}
this.id = Isaac.GetItemIdByName("Rotten Pork Chop")
this.variant = Isaac.GetEntityVariantByName("Rotten Fart")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
    if flag == CacheFlag.CACHE_TEARCOLOR and player:HasCollectible(this.id) then
       
      if not deliveranceData.temporary.hasRottenPorkChop then
        deliveranceData.temporary.hasRottenPorkChop = true
        deliveranceDataHandler.directSave()
        player.Color = Color(0.6,1,0.6,1,0,0,0)
      end
    end
end

function this:rottenUpdate(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if player:GetFireDirection() ~= Direction.NO_DIRECTION and math.random(1, 210-(math.min(player.Luck*12, 105))) == 2 then
      local dirs = { 
         [Direction.LEFT] = Vector(15, 0), 
         [Direction.UP] = Vector(0, 15), 
         [Direction.RIGHT] = Vector(-15, 0), 
         [Direction.DOWN] = Vector(0, -15), 
         [Direction.NO_DIRECTION] = Vector(0, 0), 
      }
      SFXManager():Play(SoundEffect.SOUND_FART , 0.8, 0, false, math.random(11, 13) / 10)
      local fart = Isaac.Spawn(1000, this.variant, 0, player.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()], player)
      fart:GetSprite():Play("Fart")
    end
  end
end

function this:updateFart(npc)
  if npc.Variant == this.variant then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
--  sprite.Rotation = npc.Velocity:GetAngleDegrees() + 90
    npc.Velocity = npc.Velocity * 0.85

    if sprite:IsFinished("Fart") then npc:Remove() end

    for e, enemies in pairs(Isaac.FindInRadius(npc.Position, 32, EntityPartition.ENEMY)) do
      if player:HasCollectible(202) then  
         enemies:AddPoison(EntityRef(nil), 120, 2) 
      elseif player:HasCollectible(378) then  
         enemies:AddPoison(EntityRef(nil), 80, 4) 
      elseif player:HasCollectible(202) and player:HasCollectible(378) then  
         enemies:AddPoison(EntityRef(nil), 150, 5) 
      else
         enemies:AddPoison(EntityRef(nil), 80, 2) 
      end
    end
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.rottenUpdate)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateFart)
end

return this
