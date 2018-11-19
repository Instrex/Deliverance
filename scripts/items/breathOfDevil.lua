local this = {}
this.id = Isaac.GetItemIdByName("Breath of the Devil")


-- Replace all hearts to their corresponding reward --
function this:pickupMorph(pickup)
  if Isaac.GetPlayer(0):HasCollectible(this.id) and pickup.Variant == PickupVariant.PICKUP_HEART then
    if pickup.SubType == HeartSubType.HEART_FULL then
      pickup:Morph(5, 20, 1)

    elseif pickup.SubType == HeartSubType.HEART_SOUL then
      for i = 0, math.random(1, 3) do
        Isaac.Spawn(3, 43, 0, pickup.Position, Vector(0, 0), nil)
      end

      pickup:Remove()

    elseif pickup.SubType == HeartSubType.HEART_BLACK then
      pickup:Morph(5, 40, 1)

    elseif pickup.SubType == HeartSubType.HEART_ETERNAL then
      pickup:Morph(5, 30, 2)

    elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL or pickup.SubType == HeartSubType.HEART_HALF or pickup.SubType == HeartSubType.HEART_BLENDED then
      Isaac.Spawn(3, 43, 0, pickup.Position, Vector(0, 0), nil)

      pickup:Remove()

    elseif pickup.SubType == HeartSubType.HEART_BONE then
      pickup:Morph(5, 30, 1)

    elseif pickup.SubType == HeartSubType.HEART_DOUBLEPACK then
      pickup:Morph(5, 20, 40)

    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, this.pickupMorph)
end

return this
