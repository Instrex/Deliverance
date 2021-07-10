local this = {}
this.playerAwan = Isaac.GetPlayerTypeByName("Awan")

function this:playerSwitch(player)
	if player:GetPlayerType() == this.playerAwan then
		player:ChangePlayerType(PlayerType.PLAYER_THELOST)
		print("Don't even try. The result will always be a disappointment")
	end
end


function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.playerSwitch)
end

return this