local this = {}
this.id = Isaac.GetItemIdByName("Yum Rib")
this.description = "Gives one bone heart"
this.rusdescription = {"Yum Rib /Ням Ребро", "Даёт одно костяное сердце"}
this.isActive = true

function this.use()
	local player = Utils.GetPlayersItemUse()
	player:AddBoneHearts(1)
    sfx:Play(461, 0.8, 0, false, 1)
	if utils.chancep(0.1) then
		player:ChangePlayerType(PlayerType.PLAYER_THEFORGOTTEN)
		player:RemoveCollectible(this.id)
	end
	return true
end

function this.Init()
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this