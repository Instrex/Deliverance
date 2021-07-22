local this = {}
this.costume = Isaac.GetCostumeIdByPath("gfx/characters/deliverance/character_awan.anm2")
this.playerAwan = Isaac.GetPlayerTypeByName("Awan")

this.speedBonus = 0
this.currentSlot = 1
local MaterialMap = {
   [CauldronMaterialID.gunpowder] = 1,
   [CauldronMaterialID.paper] = 2,
   [CauldronMaterialID.blood] = 3,
   [CauldronMaterialID.rib] = 4,
   [CauldronMaterialID.feather] = 5
}

function _awan_getCurrentMaterialInfo() 
   local id = 0
   for key, val in pairs(MaterialMap) do 
      if val == this.currentSlot then 
         id = key 
         break
      end
   end

   return {
      count = deliveranceData.temporary.materials[this.currentSlot],
      type = id,
      slot = this.currentSlot
   }
end

local needToSpawnCauldron = false

function this.checkForCauldron()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e.Type == Isaac.GetEntityTypeByName("Cauldron") and e.Variant == Isaac.GetEntityVariantByName("Cauldron") then count = count + 1 end
  end

  return count
end

local function isCauldronComponent(id)
   return utils.contains(CauldronMaterialID, id)
end

function this:Update()
   local game = Game()
   local player = Isaac.GetPlayer(0)
   local level = game:GetLevel()
   local stage = level:GetStage()
   local room = game:GetRoom()

   if player:GetPlayerType() == this.playerAwan then
    if not player:IsDead() then
	
	if deliveranceData.persistent and not deliveranceData.persistent.completiondata then
		deliveranceData.persistent.completiondata = {
			[0] = 0, -- Paper/Delirium
			[1] = 0, -- Mom's Heart
			[2] = 0, -- Isaac
			[3] = 0, -- Satan
			[4] = 0, -- Boss Rush
			[5] = 0, -- ???
			[6] = 0, -- The Lamb
			[7] = 0, -- Mega Satan
			[8] = 0, -- Greed/Greedier
			[9] = 0, -- Hush
		}
		end

      if not deliveranceData.temporary.awanStartUp then
         deliveranceData.temporary.deletedFirstItem = deliveranceData.temporary.deletedFirstItem or false
         deliveranceData.temporary.materials = deliveranceData.temporary.materials or {0, 0, 0, 0, 0}
         player:AddCard(Card.CARD_DICE_SHARD)
         deliveranceData.temporary.awanStartUp=true
         deliveranceDataHandler.directSave()
      end

      local trinket = player:GetTrinket(0)
      if utils.contains(CauldronMaterialID, trinket) then
         deliveranceData.temporary.materials[MaterialMap[trinket]] = deliveranceData.temporary.materials[MaterialMap[trinket]] + 1
         deliveranceDataHandler.directSave()

         player:TryRemoveTrinket(trinket)
      end

      if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 then
         this.speedBonus = 0
         player:AddCacheFlags(CacheFlag.CACHE_SPEED)
         player:EvaluateItems()
         --player:AddCard(Card.CARD_DICE_SHARD)
      end

      if room:GetFrameCount() == 1 then
	    player:AddNullCostume(this.costume)
      end

      for e, collect in pairs(Isaac.GetRoomEntities()) do

         if collect.Type == 5 then 
            if (collect.Variant == 150 or collect.Variant == 100) then 
               if room:GetType() ~= RoomType.ROOM_BOSSRUSH then 
                  if (this.checkForCauldron()==0 and (game.Difficulty==0 or game.Difficulty==1)) 
                  or ((game.Difficulty==2 or game.Difficulty==3) and stage ~= 7 and 
                    ((stage < 6 and (level:GetCurrentRoomIndex() ~= 98 or (level:GetCurrentRoomIndex() == 98 and not deliveranceData.temporary.deletedFirstItem)))) or (stage == 6 and this.checkForCauldron()==0)) then
                     if collect.SubType ~= CollectibleType.COLLECTIBLE_POLAROID and 
                     collect.SubType ~= CollectibleType.COLLECTIBLE_NEGATIVE and 
                     collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 and 
                     collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 then
                        Isaac.Spawn(1000, 15, 0, collect.Position, vectorZero, npc)
                        sfx:Play(Utils.choose(SoundEffect.SOUND_POWERUP1,SoundEffect.SOUND_POWERUP2,SoundEffect.SOUND_POWERUP3), 0.25, 0, false, 0.825) 
                        local loot = {}
               
                        if room:GetType() == RoomType.ROOM_DEVIL then       for i=1,Utils.choose(1,2) do table.insert(loot, Utils.choose(CauldronMaterialID.blood, CauldronMaterialID.rib)) end
                        elseif room:GetType() == RoomType.ROOM_CURSE then   table.insert(loot, CauldronMaterialID.blood)
                        elseif room:GetType() == RoomType.ROOM_SECRET or room:GetType() == RoomType.ROOM_SUPERSECRET then table.insert(loot, CauldronMaterialID.rib)
                        elseif room:GetType() == RoomType.ROOM_LIBRARY then table.insert(loot, CauldronMaterialID.paper)
                        elseif room:GetType() == RoomType.ROOM_ANGEL then   for i=1,Utils.choose(1,2) do table.insert(loot, CauldronMaterialID.feather) end
                        elseif room:GetType() == RoomType.ROOM_TREASURE then
                          if stage == LevelStage.STAGE1_1 or (stage == LevelStage.STAGE1_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                            for i=1,Utils.choose(3,4) do table.insert(loot, Utils.chooset(CauldronMaterialID)) end
                          elseif stage == LevelStage.STAGE1_2 then
                            for i=1,Utils.choose(2,3) do table.insert(loot, Utils.chooset(CauldronMaterialID)) end
                          elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                            for i=1,2 do table.insert(loot, Utils.chooset(CauldronMaterialID)) end
                          else
                            table.insert(loot, Utils.chooset(CauldronMaterialID))
                          end
                        elseif room:GetType() == RoomType.ROOM_BOSS then
                          if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 or (stage == LevelStage.STAGE1_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                            for i=1,Utils.choose(2,3) do table.insert(loot, Utils.chooset(CauldronMaterialID)) end
                          elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                            for i=1,2 do table.insert(loot, Utils.chooset(CauldronMaterialID)) end
                          else
                            table.insert(loot, Utils.chooset(CauldronMaterialID))
                          end
                        else
                          for i=1,2 do table.insert(loot, Utils.chooset(CauldronMaterialID)) end
                        end
                
                        if collect:ToPickup():IsShopItem() and not (room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_BLACK_MARKET) then
                            local pick = Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect)
                            pick:ToPickup().Price = 5
                        else
                            for i=1, #loot do Isaac.Spawn(5, 350, loot[i], collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect) end
                        end

                        if level:GetCurrentRoomIndex() == 98 and not deliveranceData.temporary.deletedFirstItem then
                           deliveranceData.temporary.deletedFirstItem=true
                           deliveranceDataHandler.directSave()
                        end
                        collect:Remove()
                     end
                  end
               end
            end
            if collect.Variant == 350 and not isCauldronComponent(collect.SubType) then
               if collect:ToPickup():IsShopItem() and (room:GetType() ~= RoomType.ROOM_DEVIL or room:GetType() ~= RoomType.ROOM_BLACK_MARKET) then
                  local pick = Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect)
                  pick:ToPickup().Price = 5
               else
                  Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), collect.Position, vectorZero, npc)
               end
               collect:Remove()
            end
         end
      end

      for e, entity in pairs(Isaac.GetRoomEntities()) do 
        if entity.Type == 17 then 
           if entity.Variant == 0 then
              entity:GetSprite():ReplaceSpritesheet(0,"gfx/effects/awanShopkeeper.png")
              entity:GetSprite():LoadGraphics()
           end
           if entity.Variant == 3 then
              entity:GetSprite():ReplaceSpritesheet(0,"gfx/effects/awanShopkeeper2.png")
              entity:GetSprite():LoadGraphics()
           end
        end 
      end

      if needToSpawnCauldron then 
         if game.Difficulty==0 or game.Difficulty==1 then
            if stage == LevelStage.STAGE4_3 then 
                this.spawnCauldron(Isaac.GetFreeNearPosition(room:GetCenterPos() - Vector(0, 160), 1))
                needToSpawnCauldron = false
            else
                this.spawnCauldron(Isaac.GetFreeNearPosition(room:GetCenterPos() - Vector(100, 80), 1))
                needToSpawnCauldron = false
            end
      
         elseif game.Difficulty==2 or game.Difficulty==3 then
            if stage ~= 6 and stage ~= 7 then
               this.spawnGreedCauldron(room:GetCenterPos() - Vector(0, 200), 98)
            end

            if stage == 6 then
               this.spawnCauldron(room:GetCenterPos() - Vector(133, 250))
               needToSpawnCauldron = false
            end
         end
      end

      if room:IsClear() then this.speedBonus=1.5 else this.speedBonus=1 end
      player:AddCacheFlags(CacheFlag.CACHE_SPEED)
      player:EvaluateItems()
   end

   else
      for e, collect in pairs(Isaac.GetRoomEntities()) do 
         if collect.Type == 5 then
            if collect.Variant == 350 and isCauldronComponent(collect.SubType) then
               Isaac.Spawn(5, 350, 0, collect.Position, vectorZero, player)
               collect:Remove()
            end
         end 
      end
   end
end

function this.spawnGreedCauldron(pos, room)
   npcPersistence.addPhantom(Isaac.GetEntityTypeByName("Cauldron"), Isaac.GetEntityVariantByName("Cauldron"), pos.X, pos.Y, room)
   needToSpawnCauldron = false
end

function this.spawnCauldron(pos)
   deliveranceData.temporary.cauldronSpawned=true
   deliveranceDataHandler.directSave() 
end

function this:nullCauldronSpawn()   
   if deliveranceData.temporary.cauldronSpawned~=nil then
      deliveranceData.temporary.cauldronSpawned=false
      deliveranceDataHandler.directSave()
   end
end

function this:PostInit(player)
   if player:GetPlayerType() == this.playerAwan then
	--player:TryRemoveNullCostume(this.justHeadCostume)
	player:AddNullCostume(this.costume)
	costumeEquipped = true
   else
	player:TryRemoveNullCostume(this.costume)
	--player:TryRemoveNullCostume(this.justHeadCostume)
	costumeEquipped = false
  end
end

function this:EvaluateCache(player, cacheFlag)
  if player:GetPlayerType() == this.playerAwan then 
     if cacheFlag == CacheFlag.CACHE_SPEED then
	player.MoveSpeed = player.MoveSpeed * this.speedBonus
     elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.94
     elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck - 1
     --elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then 
     --   player.MaxFireDelay = player.MaxFireDelay - 1
     end
  end
end

local HudMaterials = Sprite() HudMaterials:Load("gfx/ui/hudMaterials_OLD.anm2", true)
local HudBackground = Sprite() HudBackground:Load("gfx/ui/hudBackround.anm2", true)
local HudChoose = Sprite() HudChoose:Load("gfx/ui/hudChooseMaterial.anm2", true)
local HudHint = Sprite() HudHint:Load("gfx/ui/hudHint.anm2", true)

local hint = 0
local appearcheck = false

-- local AchSprite = Sprite() AchSprite:Load("gfx/ui/achievement/achievement.anm2", true)
-- local AchName = "gfx/ui/achievement/achievement_awan1.png"
local Completion_Widget = Sprite() Completion_Widget:Load("gfx/ui/achievement/completion_widget.anm2", true)
local Completion_Icons = Sprite() Completion_Icons:Load("gfx/ui/achievement/completion_icons.anm2", true)
-- local AchTimer = 0
local Completion_Y = 0

function this:onRender()

   local r = Game():GetRoom()
	if r:GetFrameCount() == 0 and r:GetType() == RoomType.ROOM_BOSS and not r:IsClear() then
		return
   end
   
   local player = Isaac.GetPlayer(0)
   if player:GetPlayerType() == this.playerAwan and deliveranceData.temporary.awanStartUp then 
	
	--Stats render
	local screenpos = Isaac.WorldToScreen(player.Position)
	Isaac.RenderScaledText("Cauldron: "..this.checkForCauldron(),screenpos.X - 35,screenpos.Y + 10,0.5,0.5,1,1,1,1)
	
	Isaac.RenderScaledText("Res count: ".._awan_getCurrentMaterialInfo().count,screenpos.X + 10,screenpos.Y + 10,0.5,0.5,1,1,1,1)
	Isaac.RenderScaledText("Res Type: ".._awan_getCurrentMaterialInfo().type,screenpos.X + 10,screenpos.Y + 15,0.5,0.5,1,1,1,1)

      if this.checkForCauldron()~=0 then
         --hint hide/check
            if not HudBackground:IsPlaying("Appear") and not appearcheck then
               HudBackground:Play("Appear",false)
            end
            if HudBackground:IsFinished("Appear") then
               appearcheck = true
               HudBackground:Play("Idle",true)
            end

         if hint < 13 then hint = hint + 1 end
      else
         HudBackground:Play("New Animation")
         if HudBackground:IsFinished("New Animation")then
            appearcheck = false
         end

         if hint > 0 then hint = hint - 1 end
      end

      for i = 0, 9 do
         HudBackground:RenderLayer(i, Vector(50,238))
      end

      if (not Game():IsPaused()) then
         HudBackground:Update()
      end

      HudHint:SetFrame("Appear", hint)
      HudHint:RenderLayer(0, Vector(97,231))
      HudHint:RenderLayer(1, Vector(97,231))



      for i=1, #deliveranceData.temporary.materials do
        if HudBackground:IsPlaying("Idle") then
         HudMaterials:SetFrame("Idle", i-1)
         HudMaterials:RenderLayer(0, Vector(-5+i*17,225))
         Utils.RenderNumber(deliveranceData.temporary.materials[i], Vector(-2+i*16,240), true)
        end
      end

     Completion_Widget:SetFrame("Idle", 0)
     Completion_Widget:RenderLayer(0, Vector(40,-120+Completion_Y))
     
     if (deliveranceData.persistent.completiondata[5]>1) then
        Completion_Icons:SetFrame("Idle", 1)
      else
         Completion_Icons:SetFrame("Idle", 0)
      end
      Completion_Icons:RenderLayer(0, Vector(40+17,-120+Completion_Y+15))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 3)
      else
         Completion_Icons:SetFrame("Idle", 2)
      end
      Completion_Icons:RenderLayer(0, Vector(40+31,-120+Completion_Y+9))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 5)
      else
         Completion_Icons:SetFrame("Idle", 4)
      end
      Completion_Icons:RenderLayer(0, Vector(40+46,-120+Completion_Y+13))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 7)
      else
         Completion_Icons:SetFrame("Idle", 6)
      end
      Completion_Icons:RenderLayer(0, Vector(40+55,-120+Completion_Y+24))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 9)
      else
         Completion_Icons:SetFrame("Idle", 8)
      end
      Completion_Icons:RenderLayer(0, Vector(40+13,-120+Completion_Y+33))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 11)
      else
         Completion_Icons:SetFrame("Idle", 10)
      end
      Completion_Icons:RenderLayer(0, Vector(40+21,-120+Completion_Y+47))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 13)
      else
         Completion_Icons:SetFrame("Idle", 12)
      end
      Completion_Icons:RenderLayer(0, Vector(40+27,-120+Completion_Y+29))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 15)
      else
         Completion_Icons:SetFrame("Idle", 14)
      end
      Completion_Icons:RenderLayer(0, Vector(40+41,-120+Completion_Y+32))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 17)
      else
         Completion_Icons:SetFrame("Idle", 16)
      end
      Completion_Icons:RenderLayer(0, Vector(40+38,-120+Completion_Y+50))

      if (deliveranceData.persistent.completiondata[5]>1) then
         Completion_Icons:SetFrame("Idle", 19)
      else
         Completion_Icons:SetFrame("Idle", 18)
      end
      Completion_Icons:RenderLayer(0, Vector(40+53,-120+Completion_Y+40))

      if not game:IsPaused() and Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) then
         if Completion_Y<150 then Completion_Y=Completion_Y+25 end
      else
         if Completion_Y>0 then Completion_Y=Completion_Y-25 end
      end

      if HudChoose:IsFinished("Select") then
         HudChoose:Play("Idle", false)
      end
      
      if HudBackground:IsPlaying("Idle") then
         HudChoose:RenderLayer(0, Vector(3+this.currentSlot*16,235))
         HudChoose:Update()
      end
      if not game:IsPaused() and (deliveranceData.temporary.materials[this.currentSlot] == 0 or Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex)) then
         local selected = false
         for _slot = this.currentSlot + 1, 10 do
            local slot = _slot
            if slot > 5 then
               slot = slot - 5
            end

            if deliveranceData.temporary.materials[slot] > 0 then
               this.currentSlot = slot
               HudChoose:Play("Select", false)
               selected = true

               break
            end
         end
         if not selected then 
            HudChoose:Play("None", false)
         end
      end      
   
      -- if AchName~=nil and AchTimer>0 then
         -- AchTimer = AchTimer + 1
         -- AchSprite:SetFrame("Appear", AchTimer)
         -- AchSprite:ReplaceSpritesheet(2, AchName)
        
         -- AchSprite:LoadGraphics()
  
         -- if AchTimer>=152 then
            
            -- AchTimer=0 
         -- end
         -- AchSprite:RenderLayer(0, Utils.getScreenCenterPosition()+Vector(0,-30))
         -- AchSprite:RenderLayer(1, Utils.getScreenCenterPosition()+Vector(0,-30))
         -- AchSprite:RenderLayer(2, Utils.getScreenCenterPosition()+Vector(0,-30))
      -- end
   end
end


-- Callbacks --
function this:die(npc)
  local player = Isaac.GetPlayer(0)
  if player:GetPlayerType() == this.playerAwan then
    if npc.Type==17 then
      if npc.Variant == 0 then
        if npc.SubType == 1 then Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 2 then Isaac.Spawn(5, 350, CauldronMaterialID.gunpowder, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 3 then Isaac.Spawn(5, 350, CauldronMaterialID.paper, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 4 then Isaac.Spawn(5, 350, CauldronMaterialID.blood, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 5 then Isaac.Spawn(5, 350, CauldronMaterialID.rib, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 6 then Isaac.Spawn(5, 350, CauldronMaterialID.feather, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 7 then Isaac.Spawn(5, 350, CauldronMaterialID.blood, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 8 then Isaac.Spawn(5, 350, CauldronMaterialID.rib, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        if npc.SubType == 9 then Isaac.Spawn(5, 350, CauldronMaterialID.feather, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
      end
      if npc.Variant == 3 then
        for i=1,2 do
          if npc.SubType == 1 then Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 2 then Isaac.Spawn(5, 350, CauldronMaterialID.gunpowder, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 3 then Isaac.Spawn(5, 350, CauldronMaterialID.paper, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 4 then Isaac.Spawn(5, 350, CauldronMaterialID.blood, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 5 then Isaac.Spawn(5, 350, CauldronMaterialID.rib, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 6 then Isaac.Spawn(5, 350, CauldronMaterialID.feather, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 7 then Isaac.Spawn(5, 350, CauldronMaterialID.blood, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 8 then Isaac.Spawn(5, 350, CauldronMaterialID.rib, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
          if npc.SubType == 9 then Isaac.Spawn(5, 350, CauldronMaterialID.feather, npc.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end
        end
      end
    end
	
    local diff = 2 - (game.Difficulty + 1) % 2
	
    if npc.Type == 45 then
      if diff >= 1 and deliveranceData.persistent.completiondata[1] < 1 then
        pd.playAchievement("momsEarrings")
	  end
        deliveranceData.persistent.completiondata[1] = math.max(deliveranceData.persistent.completiondata[1],diff)
        deliveranceDataHandler.directSave()
    elseif npc.Type == 102 then
      if npc.Variant == 0 then
        if diff >= 1 and deliveranceData.persistent.completiondata[2] < 1 then
          pd.playAchievement("silverBar")
        end
        deliveranceData.persistent.completiondata[2] = math.max(deliveranceData.persistent.completiondata[2],diff)
        deliveranceDataHandler.directSave()
      elseif npc.Variant == 1 then
        if diff >= 1 and deliveranceData.persistent.completiondata[5] < 1 then
          pd.playAchievement("timeGal")
        end
        deliveranceData.persistent.completiondata[5] = math.max(deliveranceData.persistent.completiondata[5],diff)
        deliveranceDataHandler.directSave()
      end

    elseif npc.Type == 84 and npc.Variant == 10 then
      if diff >= 1 and deliveranceData.persistent.completiondata[3] < 1 then
        pd.playAchievement("sinisterChalk")
      end
      deliveranceData.persistent.completiondata[3] = math.max(deliveranceData.persistent.completiondata[3],diff)
      deliveranceDataHandler.directSave()
    elseif npc.Type == 273 then
      if diff >= 1 and deliveranceData.persistent.completiondata[6] < 1 then
        pd.playAchievement("theDivider")
      end
      deliveranceData.persistent.completiondata[6] = math.max(deliveranceData.persistent.completiondata[6],diff)
      deliveranceDataHandler.directSave()
    elseif npc.Type == 407 then
      if diff >= 1 and deliveranceData.persistent.completiondata[9] < 1 then
        pd.playAchievement("rainbowHearts")
      end
      deliveranceData.persistent.completiondata[9] = math.max(deliveranceData.persistent.completiondata[9],diff)
      deliveranceDataHandler.directSave()
    elseif npc.Type == 275 then
      if diff >= 1 and deliveranceData.persistent.completiondata[7] < 1 then
        pd.playAchievement("lawful")
      end
      deliveranceData.persistent.completiondata[7] = math.max(deliveranceData.persistent.completiondata[7],diff)
      deliveranceDataHandler.directSave()
      --[[elseif npc.Type == 406 and npc.Variant == 0 and game.Difficulty==2 then
      pd.playAchievement("encharmedPenny")
    elseif npc.Type == 406 and npc.Variant == 1 and game.Difficulty==3 then
      pd.playAchievement("urnOfWant")--]]
    elseif npc.Type == 412 then
      if diff >= 1 and deliveranceData.persistent.completiondata[7] < 1 then
        pd.playAchievement("obituary")
      end
      deliveranceData.persistent.completiondata[0] = math.max(deliveranceData.persistent.completiondata[0],diff)
      deliveranceDataHandler.directSave()
    end

  end
end

function this.spawnCauldron(pos) 
   Isaac.Spawn(Isaac.GetEntityTypeByName("Cauldron"), Isaac.GetEntityVariantByName("Cauldron"), 0, pos, vectorZero, player)
   Isaac.Spawn(1000, 15, 0, pos, vectorZero, npc)
   sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.75, 0, false, 1)
end

function this.onNewFloor()
   needToSpawnCauldron = true
   deliveranceData.temporary.deletedFirstItem=false
   --deliveranceDataHandler.directSave() 
end

function this:updateCollectible(collect)
   local player = Isaac.GetPlayer(0)
   local level = game:GetLevel()
   local stage = level:GetStage()
   local room = game:GetRoom()
   if collect.Type == 5 then 
      if (collect.Variant == 150 or collect.Variant == 100) then 
         if player:GetPlayerType() == this.playerAwan then
                if room:GetType() ~= RoomType.ROOM_BOSSRUSH then 
                   if (this.checkForCauldron()==0 and (game.Difficulty==0 or game.Difficulty==1)) 
                   or ((game.Difficulty==2 or game.Difficulty==3) and stage ~= 7 and 
                     ((stage < 6 and (level:GetCurrentRoomIndex() ~= 98 or (level:GetCurrentRoomIndex() == 98 and not deliveranceData.temporary.deletedFirstItem)))) or (stage == 6 and this.checkForCauldron()==0)) then
                      if collect.SubType ~= CollectibleType.COLLECTIBLE_POLAROID and 
                      collect.SubType ~= CollectibleType.COLLECTIBLE_NEGATIVE and 
                      collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 and 
                      collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 then
                          collect.Visible=false
                          collect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                      end
               end
            end
         end

         -- local changedPool = nil
         -- if collect.SubType == Isaac.GetItemIdByName("Mom's Earrings") and not deliveranceData.persistent.unlockedMomsEarrings then
            -- changedPool = ItemPoolType.POOL_TREASURE
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Sinister Shalk") and not deliveranceData.persistent.unlockedSinisterShalk then
            -- changedPool = ItemPoolType.POOL_CURSE
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Time Gal") and not deliveranceData.persistent.unlockedTimeGal then
            -- changedPool = ItemPoolType.POOL_DEVIL
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Lawful") and not deliveranceData.persistent.unlockedLawful then
            -- changedPool = ItemPoolType.POOL_ANGEL
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("The Divider") and not deliveranceData.persistent.unlockedTheDivider then
            -- changedPool = ItemPoolType.POOL_SECRET
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Silver Bar") and not deliveranceData.persistent.unlockedSilverBar then
            -- changedPool = ItemPoolType.POOL_TREASURE
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Encharmed Penny") and not deliveranceData.persistent.unlockedEncharmedPenny then
            -- changedPool = ItemPoolType.POOL_TREASURE
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Urn Of Want") and not deliveranceData.persistent.unlockedUrnOfWant then
            -- changedPool = ItemPoolType.POOL_SECRET
         -- end
         -- if collect.SubType == Isaac.GetItemIdByName("Obituary") and not deliveranceData.persistent.unlockedObituary then
            -- changedPool = ItemPoolType.POOL_LIBRARY
         -- end

         -- if changedPool ~= nil then
            -- Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(changedPool,false,math.random(1,RNG():GetSeed())), collect.Position, vectorZero, nil)
            -- collect:Remove()
         -- end
      end
   end
 end

--[[Awan_Cock = { do you like what you see?
	Name = "Awan",
    Type = PlayerType.PLAYER_ISAAC,
    SelectionGfx = "gfx/truecoop/awan.png",
    GhostCostume = this.costume,
    MaxHearts = 2,
    Hearts = 2,
    BlackHearts = 2,
    Card = 49,
    Bombs = 3,
    OnStart = function(player)
		--player:GetSprite():Load("gfx/characters/costumes/character_awan.anm2", true)
		player:AddNullCostume(this.costume)
		local sprite = player:GetSprite()
		sprite:ReplaceSpritesheet(1, "gfx/characters/costumes/Character_Awan.png")
		sprite:ReplaceSpritesheet(4, "gfx/characters/costumes/Character_Awan.png")
		sprite:ReplaceSpritesheet(12, "gfx/characters/costumes/Character_Awan.png")
		sprite:LoadGraphics()
	end,
    AllowHijacking = true,
    ActualType = this.playerAwan,
    --FetusSprite = "gfx/truecoop/foetus_mammon.anm2",
    BossPortrait = "gfx/ui/boss/playerportrait_awan.png",
    BossName = "gfx/ui/boss/playername_awan.png",
    GhostPortrait = "gfx/ui/boss/playerportrait_awan.png",
    GhostName = "gfx/ui/boss/playername_awan.png",
}

local function onTrueCoopInit()
    InfinityTrueCoopInterface.AddCharacter(Awan_Cock)
    InfinityTrueCoopInterface.AddCharacterToWheel("Awan")
    InfinityTrueCoopInterface.AssociatePlayerTypeName(this.playerAwan, "Awan")
end

if InfinityTrueCoopInterface then
    onTrueCoopInit()
else
    if not __infinityTrueCoop then
        __infinityTrueCoop = {}
    end

    __infinityTrueCoop[#__infinityTrueCoop + 1] = onTrueCoopInit
end--]]

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.Update)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.PostInit)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.EvaluateCache)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.onNewFloor)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.onRender)
  mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateCollectible)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die)
end

return this