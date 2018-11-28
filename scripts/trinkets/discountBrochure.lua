local this = {}
this.id = Isaac.GetTrinketIdByName("Discount Brochure")

function this:discountBrochureUpdate()
  local player = Isaac.GetPlayer(0)
  local level = game:GetLevel()
  local f = level:GetStage()
  if player:HasTrinket(this.id) then
    if (f == LevelStage.STAGE1_1 or f == LevelStage.STAGE1_2 or f == LevelStage.STAGE2_1 or f == LevelStage.STAGE2_2 or f == LevelStage.STAGE3_1 or f == LevelStage.STAGE3_2 or (player:HasTrinket(110) and (f == LevelStage.STAGE4_1 or f == LevelStage.STAGE4_2))) then
      player:UseCard(Card.CARD_HERMIT)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.discountBrochureUpdate)
end

return this
