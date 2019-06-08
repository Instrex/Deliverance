local this = {}
this.id = Isaac.GetTrinketIdByName("Discount Brochure")
this.description = "Teleports you into the shop after reaching next floor"

function this:discountBrochureUpdate()
  local player = Isaac.GetPlayer(0)
  local level = game:GetLevel()
  local f = level:GetStage()
  if player:HasTrinket(this.id) and not deliveranceData.temporary.discounted then
    if (f == LevelStage.STAGE1_1 or f == LevelStage.STAGE1_2 or f == LevelStage.STAGE2_1 or f == LevelStage.STAGE2_2 or f == LevelStage.STAGE3_1 or f == LevelStage.STAGE3_2 or (player:HasTrinket(110) and (f == LevelStage.STAGE4_1 or f == LevelStage.STAGE4_2))) then
      player:UseCard(Card.CARD_HERMIT)
      deliveranceData.temporary.discounted=true
      deliveranceDataHandler.directSave()
    end
  end
end

function this:nullDiscountBrochure()   
   if deliveranceData.temporary.discounted~=nil then
      deliveranceData.temporary.discounted=false
      deliveranceDataHandler.directSave()
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.discountBrochureUpdate)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.nullDiscountBrochure)
end

return this
