local this = {}
this.id = Isaac.GetItemIdByName("Bloody Stream")
this.variant = Isaac.GetEntityVariantByName("Bloody Stream")

function this.use()
  this.time = 0
  game:ShakeScreen(60)
  SFXManager():Play(SoundEffect.SOUND_SATAN_RISE_UP , 0.8, 0, false, 1.1)
  for i = 0, 8 do
    local stream = Isaac.Spawn(1000, this.variant, 0, Isaac.GetPlayer(0).Position, Vector(0, 0), nil)
    local data = stream:GetData()
    data.id = i
    data.time = 0
    stream:GetSprite():Play("Start")
  end
  return true
end

function this:update(npc)
  if npc.Variant == this.variant then
    local player = Isaac.GetPlayer(0)
    local data = npc:GetData()
    local sprite = npc:GetSprite()

    data.time = data.time + 6
    npc.Position = game:GetRoom():GetClampedPosition(player.Position + Vector(data.time * 1.5, 0):Rotated(data.id * 45 + data.time), 1)

    if utils.chancep(50) then
      Isaac.Spawn(1000, 46, 0, npc.Position, Vector(0, 0), nil):ToEffect().Scale = 1.5
    end

    if sprite:IsFinished("Start") then
      sprite:Play("Loop")
    end

    if sprite:IsFinished("End") then
      npc:Remove()
    end

    if data.time >= 240 then
      sprite:Play("End")
    end

    for e, enemies in pairs(Isaac.FindInRadius(npc.Position, 45, EntityPartition.ENEMY)) do
      enemies:TakeDamage(10, 0, EntityRef(nil), 0)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.update)
end

return this
