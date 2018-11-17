local this = {}
this.id = Isaac.GetItemIdByName("D<3")

function this.use()
  local player = Isaac.GetPlayer(0)
  for _, e in pairs(Isaac:GetRoomEntities()) do
    local pickup = e:ToPickup()
    if pickup ~= nil then
      pickup:Morph(5, 10, 0, true)
    end
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
