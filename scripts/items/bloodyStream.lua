local this = {}
this.id = Isaac.GetItemIdByName("Bloody Stream")
this.variant = Isaac.GetEntityVariantByName("Bloody Stream")
this.description = "Summons huge brimstone pillars which obliterate everything in the room"
this.rusdescription ={"Bloody Stream /Кровавый поток", "Призывает огромные серные колонны, уничтожающие всё на своем пути"}
this.isActive = true

function this.use()
  this.time = 0
  game:ShakeScreen(60)
  sfx:Play(SoundEffect.SOUND_SATAN_RISE_UP , 0.8, 0, false, 1.1)
  for i = 0, 8 do
    local stream = Isaac.Spawn(1000, this.variant, 0, Utils.GetPlayersItemUse().Position, vectorZero, nil)
    local data = stream:GetData()
    data.id = i
    data.time = 0
    stream:GetSprite():Play("Start")
  end
  return true
end

function this:update(npc)
  if npc.Variant == this.variant then
    local player = Utils.GetPlayersItemUse()
    local data = npc:GetData()
    local sprite = npc:GetSprite()

    data.time = data.time + 6
    npc.Position = game:GetRoom():GetClampedPosition(player.Position + Vector(data.time * 1.5, 0):Rotated(data.id * 45 + data.time), 1)

    -- Spawn creep with 50% chance --
    if utils.chancep(50) then
      Isaac.Spawn(1000, 46, 0, npc.Position, vectorZero, nil):ToEffect().Scale = 1.5
    end

    -- Animate beam sprite --
    if sprite:IsFinished("Start") then
      sprite:Play("Loop")
    end

    if sprite:IsFinished("End") then
      npc:Remove()
    end

    -- Destroy on time --
    if data.time >= 240 then
      sprite:Play("End")
    end

    -- Deal damage --
    for e, enemies in pairs(Isaac.FindInRadius(npc.Position, 45, EntityPartition.ENEMY)) do
      enemies:TakeDamage(10, 0, EntityRef(nil), 0)
    end

    -- Break anything in it's path --
    local room = game:GetRoom()
    local grid = room:GetGridEntityFromPos(npc.Position)
    if grid then
      grid:Destroy(false)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.update)
end

return this
