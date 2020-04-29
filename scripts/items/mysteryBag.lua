local this = {}
this.id = Isaac.GetItemIdByName("Mystery Bag")
this.description = "Gives 3 runes."

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then 
  end
end

function this:dropRune()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) and not deliveranceData.temporary.runeDropped then
      for i = 1,3 do
      local rune = Isaac.Spawn(5, 300, math.random (32,41), Isaac.GetFreeNearPosition(player.Position, 1), Vector.FromAngle(math.random(360)):Resized(2.5), nil)
	  end
      deliveranceData.temporary.runeDropped=true
  deliveranceDataHandler.directSave()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.dropRune)
end

return this
 