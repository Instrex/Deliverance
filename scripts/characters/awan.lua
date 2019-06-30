local this = {}
this.costume = Isaac.GetCostumeIdByPath("gfx/characters/costumes/character_awan.anm2")
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

      if not deliveranceData.temporary.awanStartUp then
         deliveranceData.temporary.materials = deliveranceData.temporary.materials or {0, 0, 0, 0, 0}
         deliveranceData.persistent.awanAchievements = deliveranceData.persistent.awanAchievements or {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
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
            if (collect.Variant == 150 or collect.Variant == 100) and room:GetType() ~= RoomType.ROOM_BOSSRUSH and this.checkForCauldron()==0 and collect.SubType ~= CollectibleType.COLLECTIBLE_POLAROID and collect.SubType ~= CollectibleType.COLLECTIBLE_NEGATIVE and collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 and collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 then
               
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
                
               if room:GetType() == RoomType.ROOM_SHOP then
                  --Isaac.Spawn(5, 150, 0, collect.Position, vectorZero, collect)
                  local pick = Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect)
                  pick:ToPickup().Price = PickupPrice.PRICE_TWO_HEARTS
               else
                  for i=1, #loot do Isaac.Spawn(5, 350, loot[i], collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect) end
               end
               collect:Remove() 
            end
            if collect.Variant == 350 and not isCauldronComponent(collect.SubType) then
               if room:GetType() == RoomType.ROOM_SHOP then
                  local pick = Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect)
                  pick:ToPickup().Price = PickupPrice.PRICE_TWO_HEARTS
               else
                  Isaac.Spawn(5, 350, Utils.chooset(CauldronMaterialID), collect.Position, vectorZero, npc)
               end
               collect:Remove()
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
      
         elseif (game.Difficulty==2 or game.Difficulty==3) then
            if stage ~= 6 and stage ~= 7 and room:GetType() == RoomType.ROOM_TREASURE then
               this.spawnCauldron(room:GetCenterPos() - Vector(0, 50))
               needToSpawnCauldron = false
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
        player.Damage = player.Damage + 0.54
     elseif cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck - 1
     --elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then 
     --   player.MaxFireDelay = player.MaxFireDelay - 1
     end
  end
end

local HudMaterials = Sprite() HudMaterials:Load("gfx/ui/hudMaterials.anm2", true)
local HudChoose = Sprite() HudChoose:Load("gfx/ui/hudChooseMaterial.anm2", true)
local HudHint = Sprite() HudHint:Load("gfx/ui/hudHint.anm2", true)
local AchSprite = Sprite() AchSprite:Load("gfx/ui/achievement/achievement.anm2", true)
local AchName = "gfx/ui/achievement/achievement_awan1.png"
local AchTimer = 0

function this:onRender()
   local player = Isaac.GetPlayer(0)
   if player:GetPlayerType() == this.playerAwan and deliveranceData.temporary.awanStartUp then 
      for i=1, #deliveranceData.temporary.materials do 
        HudMaterials:SetFrame("Idle", i-1)
        HudMaterials:RenderLayer(0, Vector(-8+i*16,226))
        Utils.RenderNumber(deliveranceData.temporary.materials[i], Vector(-7+i*16,244), true)
      end

      if this.checkForCauldron()~=0 then
         HudHint:SetFrame("Idle", 0)
         HudHint:RenderLayer(0, Vector(97,231))
      end

      if HudChoose:IsFinished("Select") then
         HudChoose:Play("Idle", false)
      end

      HudChoose:RenderLayer(0, Vector(this.currentSlot*16+1,238))
      HudChoose:Update()
      if not game:IsPaused() and (deliveranceData.temporary.materials[this.currentSlot] == 0 or Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0)) then
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
   end
end

-- Callbacks --

function this:die(npc) 
   local player = Isaac.GetPlayer(0)
   if player:GetPlayerType() == this.playerAwan then 
      if npc.Type == 45 then
         this.playAchievement(1)
      elseif npc.Type == 102 then
         this.playAchievement(2)
      elseif npc.Type == 84 then
         this.playAchievement(3)
      end
   end
end

function this.playAchievement(id)
   if deliveranceData.persistent.awanAchievements[id]~=1 then
      sfx:Play(8, 1, 0, false, 1) 
      AchTimer=1
      AchName="gfx/ui/achievement/achievement_awan" .. id ..".png"
      deliveranceData.persistent.awanAchievements[id]=1
      deliveranceDataHandler.directSave() 
   end
end

function this.spawnCauldron(pos) 
   Isaac.Spawn(Isaac.GetEntityTypeByName("Cauldron"), Isaac.GetEntityVariantByName("Cauldron"), 0, pos, vectorZero, player)
   Isaac.Spawn(1000, 15, 0, pos, vectorZero, npc)
   sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.75, 0, false, 1)
end

function this.onNewFloor()
   needToSpawnCauldron = true
end

function this:updateCollectible(collect)
  local player = Isaac.GetPlayer(0)
  if player:GetPlayerType() == this.playerAwan then
     if collect.Type == 5 then 
        if (collect.Variant == 150 or collect.Variant == 100) and this.checkForCauldron()==0 and collect.SubType ~= CollectibleType.COLLECTIBLE_POLAROID and collect.SubType ~= CollectibleType.COLLECTIBLE_NEGATIVE and collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 and collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 then
           collect.Visible=false
           collect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
        if collect.SubType == Isaac.GetItemIdByName("Mom's Earrings") and not deliveranceData.persistent.awanAchievements[1] then
           Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE,false,math.random(1,RNG():GetSeed())), collect.Position, vectorZero, nil)
           collect:Remove()
        end
        if collect.SubType == Isaac.GetItemIdByName("Sinister Shalk") and not deliveranceData.persistent.awanAchievements[3] then
           Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_CURSE,false,math.random(1,RNG():GetSeed())), collect.Position, vectorZero, nil)
           collect:Remove()
        end
     end
  end
end

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