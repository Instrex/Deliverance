local this = {}
this.id = Isaac.GetItemIdByName("Sister's Heart")

local sfx = SFXManager()
function this.checkEnemies()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e:IsVulnerableEnemy() then count = count + 1 end
  end

  return count
end

function this:behaviour(fam)
  local sprite = fam:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = fam:GetData()

  if player:GetFireDirection() == Direction.NO_DIRECTION then
    sprite:Play("Shoot")
  else
    sprite:Play("Intense")
  end

  if sprite:IsEventTriggered("Shoot") and this.checkEnemies() >= 1 then
    sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTER, 1, 0, false, 1)
    Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 1, fam.Position + Vector(0, 15), Vector(-3,0):Rotated(math.random(0, 360)), nil)
  end

  if sprite:IsEventTriggered("IntenseShoot") then
    data.offset = (data.offset or -1) + 1

    if player:GetHearts() <= 1 or data.offset % 2 == 0 then
      sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTEST, 1, 0, false, 1)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, fam.Position + Vector(0, 15), Vector(7, 0):Rotated(10 * data.offset), nil)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, fam.Position + Vector(0, 15), Vector(-7, 0):Rotated(10 * data.offset), nil)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, fam.Position + Vector(0, 15), Vector(0, 7):Rotated(10 * data.offset), nil)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, fam.Position + Vector(0, 15), Vector(0, -7):Rotated(10 * data.offset), nil)
    end
  end

  if player:GetFireDirection() == Direction.NO_DIRECTION then
    fam:FollowParent()
  else fam.Velocity = Vector(0, 0) end
end

function this:awake(fam)
  fam:AddToFollowers()
end

function this:cache(player, flag)
  player:CheckFamiliar(this.id, player:GetCollectibleNum(this.id) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1), RNG())
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, this.awake, this.id)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
end

return this
