local this = {}
this.id = Isaac.GetItemIdByName("D<3")
this.description = "Turns all pickups into different kinds of hearts"

function this.use()
  local player = Isaac.GetPlayer(0)
  sfx:Play(SoundEffect.SOUND_DEATH_CARD , 0.8, 0, false, 1)
  for _, e in pairs(Isaac:GetRoomEntities()) do
    local pickup = e:ToPickup()
--  if pickup ~= nil and pickup.Variant == PickupVariant.PICKUP_HEART then
    if pickup ~= nil then
      Isaac.Spawn(1000, 14, 1, pickup.Position, vectorZero, nil)
      for i = 0, math.random(1, 2) do
        Isaac.Spawn(1000, 5, 0, pickup.Position, Vector(math.random(-5, 5),math.random(-5, 5)), nil)
      end
      if pickup:CanReroll() then
        pickup:Morph(5, 10, 0, true)
      end
    end
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
