local this = {}

local AchSprite = Sprite() AchSprite:Load("gfx/ui/achievement/achievement.anm2", true)
local AchName = "gfx/ui/achievement/achievement_awan1.png"
local AchTimer = 0
	
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_)
	
	
  deliveranceData.persistent.completiondata = {
    [0] = deliveranceData.persistent.deliriumcomp or 0, -- Paper/Delirium
    [1] = deliveranceData.persistent.heartcomp or 0, -- Mom's Heart
    [2] = deliveranceData.persistent.isaaccomp or 0, -- Isaac
    [3] = deliveranceData.persistent.satancomp or 0, -- Satan
    [4] = deliveranceData.persistent.rushcomp or 0, -- Boss Rush
    [5] = deliveranceData.persistent.bluebabycomp or 0, -- ???
    [6] = deliveranceData.persistent.lambcomp or 0, -- The Lamb
    [7] = deliveranceData.persistent.megasatancomp or 0, -- Mega Satan
    [8] = deliveranceData.persistent.greedcompn or 0, -- Greed/Greedier
    [9] = deliveranceData.persistent.hushcomp or 0, -- Hush
	[10] = deliveranceData.persistent.shockcomp or 0, -- Shock Therapy
  }
  
   local i = game:GetItemPool()

  local delirium = deliveranceData.persistent.completiondata[0] 
  local heart = deliveranceData.persistent.completiondata[1]
  local isaac = deliveranceData.persistent.completiondata[2]
  local satan = deliveranceData.persistent.completiondata[3]
  local rush = deliveranceData.persistent.completiondata[4]
  local bluebaby = deliveranceData.persistent.completiondata[5]
  local lamb = deliveranceData.persistent.completiondata[6]
  local megasatan = deliveranceData.persistent.completiondata[7]
  local greed = deliveranceData.persistent.completiondata[8]
  local hush = deliveranceData.persistent.completiondata[9]
  local shock = deliveranceData.persistent.completiondata[10]
  
  local normal = 1
  local hard = 2

  if heart < hard then
    i:RemoveCollectible(deliveranceContent.items.momsEarrings.id)
  end
  if isaac < normal then
    i:RemoveCollectible(deliveranceContent.items.silverBar.id)
  end
  if bluebaby < normal then
    i:RemoveCollectible(deliveranceContent.items.timeGal.id)
  end
  if satan < normal then
    i:RemoveCollectible(deliveranceContent.items.sinisterShalk.id)
  end
  if lamb < normal then
    i:RemoveCollectible(deliveranceContent.items.theDivider.id)
  end
  if delirium < normal then
    i:RemoveCollectible(deliveranceContent.items.obituary.id)
  end
  if greed < normal then
    i:RemoveCollectible(deliveranceContent.items.encharmedPenny.id)
  end

  if greed < hard then
    i:RemoveCollectible(deliveranceContent.items.urnOfWant.id)
  end
  if shock = 0 then
	i:RemoveTrinket(deliveranceContent.trinkets.bloatedcapacitor.id)
  end
end)
 
 

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
  if AchName~=nil and AchTimer>0 then
    AchTimer = AchTimer + 1
    AchSprite:SetFrame("Appear", AchTimer)
    AchSprite:ReplaceSpritesheet(2, AchName)

    AchSprite:LoadGraphics()

    if AchTimer>=152 then

      AchTimer=0
    end
    AchSprite:RenderLayer(0, Utils.getScreenCenterPosition()+Vector(0,-30))
    AchSprite:RenderLayer(1, Utils.getScreenCenterPosition()+Vector(0,-30))
    AchSprite:RenderLayer(2, Utils.getScreenCenterPosition()+Vector(0,-30))
  end
end)

function this.playAchievement(name)
    sfx:Play(8, 1, 0, false, 1) 
    AchTimer=1
    AchName="gfx/ui/achievement/achievement_" .. name ..".png"
end

print("save loaded deliverance")
return this