local this = {}
this.id = Isaac.GetItemIdByName("Mystery Bag")
this.description = "Gives three random runes"
this.rusdescription ={"Mystery Bag /Загадочный мешочек", "Даёт три случайные руны"}

function this:dropRune(player)
  local data = player:GetData()
  data.runeDropped = data.runeDropped or player:GetCollectibleNum(this.id)

  if data.runeDropped < player:GetCollectibleNum(this.id) then
    for i = 1,3 do
      Isaac.Spawn(5, 300, math.random (32,41), Isaac.GetFreeNearPosition(player.Position, 1), Vector.FromAngle(math.random(360)):Resized(2.5), nil)
    end
    data.runeDropped = player:GetCollectibleNum(this.id)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.dropRune)
end

return this
 