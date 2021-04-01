local this = {
	id = Isaac.GetChallengeIdByName("[D#1]Shock Therapy")
}



function this:onchallengestart()
	local player = Isaac.GetPlayer(0)
	local pool = game:GetItemPool()
	if Isaac.GetChallenge() == this.id then
		player:AddCollectible(deliveranceContent.items.roundBattery.id, 0, false)
		pool:RemoveCollectible(deliveranceContent.items.roundBattery.id)
	end
end

function this:challengeunlock(pickup, collider,low)
	if pickup.Variant == 370 and collider.Type == 1 and deliveranceData.persistent.completiondata[10] == 0 and Isaac.GetChallenge() == this.id then
		pd.playAchievement("bloatedcapacitor") -- swipe sprite later
		deliveranceData.persistent.completiondata[10] = 1
		deliveranceDataHandler.directSave()
	end
end

function this.Init()
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.onchallengestart)
	mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, this.challengeunlock)
end

return this