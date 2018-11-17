local this = {}
this.id = Isaac.GetItemIdByName("Special Delivery")
local specialDel_target = Isaac.GetEntityVariantByName("Special Delivery Target")
local specialDel  = Isaac.GetEntityVariantByName("Special Delivery")

function this.updatetarget(s)
  local sprite = s:GetSprite()
  local data = s:GetData()
  local player = Isaac.GetPlayer(0)

  if data.time == nil then data.time = 0 end

  if data.time ~= -1 then data.time = data.time + 1
    if data.time < 30  then sprite:Play("Idle")
    elseif data.time < 40 then sprite:Play("Explode")
    elseif data.time == 40 then sprite:Play("Die") data.time = -1 end
  end

  if sprite:IsFinished("Die") then s:Remove() Isaac.Spawn(1000, specialDel, 0, s.Position, Vector(0, 0), nil) player:AnimateCollectible(specialdelivery, "HideItem", "Idle") end

  if Input.IsMouseBtnPressed(0) then s.Velocity = (Input.GetMousePosition(true) - s.Position) / 6
  elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then s.Velocity = player:GetAimDirection()*10
  else s.Velocity = Vector(0,0) end
end

function this.updatebox(s)
  local sprite = s:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = s:GetData()

  if data.init == nil then data.init = 1 sprite:Play("Main") end

  if sprite:IsEventTriggered("Land") then
    SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 1)
  end

  if sprite:IsEventTriggered("Explode") then
    Isaac.Explode(s.Position, player, 180)
    local rand = math.random(0, 3)

    if rand == 0 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, math.random(0, 2), s.Position, Vector(0,0), nil) end
    if rand == 1 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, math.random(0, 2), s.Position, Vector(0,0), nil) end
    if rand == 2 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 1, s.Position, Vector(0,0), nil) end
    if rand == 3 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, math.random(0, 11), s.Position, Vector(0,0), nil) end
  end

  if sprite:IsEventTriggered("Die") then
    s:Remove()
  end
end

function this.use()

  local player = Isaac.GetPlayer(0)
  Isaac.Spawn(1000, specialDel_target, 0, player.Position, Vector(0, 0), nil)
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE , this.updatetarget, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE , this.updatebox, this.id)
end

return this
