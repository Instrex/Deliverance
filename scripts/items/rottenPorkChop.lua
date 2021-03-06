local this = {}
this.id = Isaac.GetItemIdByName("Rotten Pork Chop")
this.variant = Isaac.GetEntityVariantByName("Rotten Fart")
this.description = "Chance for a powerful fart during shot"
this.rusdescription ={"Rotten Pork Chop /������ �������", "���� ����� ������� ��� ��������"}

function this:cache(player, flag)
  if flag == CacheFlag.CACHE_TEARCOLOR and player:HasCollectible(this.id) then

    player.Color = Color(0.6,1,0.6,1,0,0,0)
  end
end

function this:rottenUpdate(player)
  if player:HasCollectible(this.id) then
    if player:GetFireDirection() ~= Direction.NO_DIRECTION and math.random(1, 210-(math.min(math.floor(player.Luck)*12, 105))) == 2 then
      local dirs = { 
         [Direction.LEFT] = Vector(15, 0), 
         [Direction.UP] = Vector(0, 15), 
         [Direction.RIGHT] = Vector(-15, 0), 
         [Direction.DOWN] = Vector(0, -15), 
         [Direction.NO_DIRECTION] = vectorZero, 
      }
      sfx:Play(SoundEffect.SOUND_FART , 0.8, 0, false, math.random(11, 13) / 10)
      local fart = Isaac.Spawn(1000, this.variant, 0, player.Position + dirs[player:GetFireDirection()], dirs[player:GetFireDirection()], player)
      fart:GetSprite():Play("Fart")
      local fartSize = Utils.choose(1, 1.25, 1.5, 1.75, 2)
      fart:GetSprite().Scale = Vector(fartSize, fartSize)
      local data = fart:GetData()
      data.radius = 32*fartSize
      data.fartDamage = 1
    end
  end
end

function this:updateFart(npc)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  --  sprite.Rotation = npc.Velocity:GetAngleDegrees() + 90
  npc.Velocity = npc.Velocity * 0.85

  if sprite:IsFinished("Fart") then npc:Remove() end

  for e, enemies in pairs(Isaac.FindInRadius(npc.Position, data.radius, EntityPartition.ENEMY)) do
    if enemies:IsActiveEnemy() and not enemies:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
      for _, player in pairs(Utils.GetPlayers()) do
        if player:HasCollectible(202) then
          print("funny")
          enemies:AddPoison(EntityRef(nil), 120, 2*data.fartDamage)
        elseif player:HasCollectible(378) then
          enemies:AddPoison(EntityRef(nil), 80, 4*data.fartDamage)
        elseif player:HasCollectible(202) and player:HasCollectible(378) then
          enemies:AddPoison(EntityRef(nil), 150, 5*data.fartDamage)
        else
          enemies:AddPoison(EntityRef(nil), 80, 2*data.fartDamage)
        end
      end
    end
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.rottenUpdate)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateFart, this.variant)
end

return this
