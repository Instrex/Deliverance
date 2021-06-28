local this = {}
this.id = Isaac.GetItemIdByName("Smelly Pot")
this.description = ""
this.rusdescription ={""}
this.isActive = true

function this.use()
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
   Isaac.Spawn(1000, 34, 0, player.Position, vectorZero, player)
    Isaac.Spawn(1000, 43, 0, player.Position, vectorZero, player)
  for i=1, math.random(1, 3) do
   Isaac.Spawn(3, 201, math.random (0,13), Isaac.GetFreeNearPosition(player.Position, 1), Vector.FromAngle(math.random(360)):Resized(5.10), nil)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
