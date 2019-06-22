local this = {}
this.costume = Isaac.GetCostumeIdByPath("gfx/characters/costumes/character_awan.anm2")
this.playerAwan = Isaac.GetPlayerTypeByName("Awan")

this.gunPowder = Isaac.GetTrinketIdByName("Gunpowder")
this.paper = Isaac.GetTrinketIdByName("Piece of Paper")
this.blood = Isaac.GetTrinketIdByName("Bottled Blood")
this.rib = Isaac.GetTrinketIdByName("Wooden Rib")
this.feather = Isaac.GetTrinketIdByName("Glowing Feather")

this.speedBonus = 0
this.currentSlot = 1
this.currentMaterial = this.gunPowder
this.currentMaterialNumber = 0

function this.checkForCauldron()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e.Type == Isaac.GetEntityTypeByName("Cauldron") and e.Variant == Isaac.GetEntityVariantByName("Cauldron") then count = count + 1 end
  end

  return count
end

function this:Update()
   local game = Game()
   local player = Isaac.GetPlayer(0)
   local level = game:GetLevel()
   local stage = level:GetStage()
   local room = game:GetRoom()

   if player:GetPlayerType() == this.playerAwan then 
    if not player:IsDead() then
   
      if deliveranceData.temporary.awanStartUp == nil then
        deliveranceData.temporary.hasMaterial = deliveranceData.temporary.hasMaterial or {}
         for i=1, 5 do 
            table.insert(deliveranceData.temporary.hasMaterial, 0)
         end
         deliveranceData.temporary.awanStartUp=true
         deliveranceDataHandler.directSave() 
      end

      if player:GetTrinket(0)==this.gunPowder then deliveranceData.temporary.hasMaterial[1]=deliveranceData.temporary.hasMaterial[1]+1 deliveranceDataHandler.directSave() player:TryRemoveTrinket(player:GetTrinket(0)) end
      if player:GetTrinket(0)==this.paper then deliveranceData.temporary.hasMaterial[2]=deliveranceData.temporary.hasMaterial[2]+1 deliveranceDataHandler.directSave() player:TryRemoveTrinket(player:GetTrinket(0)) end
      if player:GetTrinket(0)==this.blood then deliveranceData.temporary.hasMaterial[3]=deliveranceData.temporary.hasMaterial[3]+1 deliveranceDataHandler.directSave() player:TryRemoveTrinket(player:GetTrinket(0)) end
      if player:GetTrinket(0)==this.rib then deliveranceData.temporary.hasMaterial[4]=deliveranceData.temporary.hasMaterial[4]+1 deliveranceDataHandler.directSave() player:TryRemoveTrinket(player:GetTrinket(0)) end
      if player:GetTrinket(0)==this.feather then deliveranceData.temporary.hasMaterial[5]=deliveranceData.temporary.hasMaterial[5]+1 deliveranceDataHandler.directSave() player:TryRemoveTrinket(player:GetTrinket(0)) end
      if this.currentSlot == 1 then this.currentMaterial = this.gunPowder this.currentMaterialNumber=deliveranceData.temporary.hasMaterial[1] end
      if this.currentSlot == 2 then this.currentMaterial = this.paper this.currentMaterialNumber=deliveranceData.temporary.hasMaterial[2] end
      if this.currentSlot == 3 then this.currentMaterial = this.blood this.currentMaterialNumber=deliveranceData.temporary.hasMaterial[3] end
      if this.currentSlot == 4 then this.currentMaterial = this.rib this.currentMaterialNumber=deliveranceData.temporary.hasMaterial[4] end
      if this.currentSlot == 5 then this.currentMaterial = this.feather this.currentMaterialNumber=deliveranceData.temporary.hasMaterial[5] end

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
            if (collect.Variant == 150 or collect.Variant == 100) and this.checkForCauldron()==0 and collect.SubType ~= CollectibleType.COLLECTIBLE_POLAROID and collect.SubType ~= CollectibleType.COLLECTIBLE_NEGATIVE and collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_1 and collect.SubType ~= CollectibleType.COLLECTIBLE_KEY_PIECE_2 then
               Isaac.Spawn(1000, 15, 0, collect.Position, vectorZero, npc)
               sfx:Play(SoundEffect.SOUND_POWERUP1, 0.5, 0, false, 0.825)
               local loot = Utils.choose(this.blood, this.rib, this.paper, this.gunPowder, this.feather)
               local amount = 1

               if room:GetType() == RoomType.ROOM_DEVIL then       loot = Utils.choose(this.blood, this.rib) amount=Utils.choose(1,2)
               elseif room:GetType() == RoomType.ROOM_CURSE then   loot = this.blood
               elseif room:GetType() == RoomType.ROOM_SECRET or room:GetType() == RoomType.ROOM_SUPERSECRET then loot = this.rib
               elseif room:GetType() == RoomType.ROOM_LIBRARY then loot = this.paper
               elseif room:GetType() == RoomType.ROOM_ANGEL then   loot = this.feather amount=Utils.choose(1,2)
               elseif room:GetType() == RoomType.ROOM_TREASURE then
                   if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 or (stage == LevelStage.STAGE1_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                       amount=Utils.choose(2,3)
                   elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                       amount=2
                   else
                       amount=1
                   end
               elseif room:GetType() == RoomType.ROOM_BOSS then
                   if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 or (stage == LevelStage.STAGE1_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                       amount=Utils.choose(2,3)
                   elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
                       amount=2
                   else
                       amount=1
                   end
               end

               if room:GetType() == RoomType.ROOM_SHOP then
                  Isaac.Spawn(5, 150, 0, collect.Position, vectorZero, collect)
               else
                  for i=1, amount do Isaac.Spawn(5, 350, loot, collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), collect) end
               end

               collect:Remove()
            end
            if collect.Variant == 350 and collect.SubType~=this.gunPowder and collect.SubType~=this.paper and collect.SubType~=this.blood and collect.SubType~=this.rib and collect.SubType~=this.feather then
               Isaac.Spawn(5, 350, Utils.choose(this.blood, this.rib, this.paper, this.gunPowder, this.feather), collect.Position, vectorZero, npc)
               collect:Remove()
            end 
         end 
      end

      if deliveranceData.temporary.cauldronSpawned==nil then
         if game.Difficulty==0 or game.Difficulty==1 then
            this.spawnCauldron(Isaac.GetFreeNearPosition(room:GetCenterPos() - Vector(100, 80), 1))
         elseif (game.Difficulty==2 or game.Difficulty==3) and room:GetType() == RoomType.ROOM_SHOP then
            this.spawnCauldron(room:GetCenterPos() - Vector(0, 50))
         end
      end

      if room:IsClear() then this.speedBonus=1.85 else this.speedBonus=1 end
      player:AddCacheFlags(CacheFlag.CACHE_SPEED)
      player:EvaluateItems()
    end
   else
      for e, collect in pairs(Isaac.GetRoomEntities()) do 
         if collect.Type == 5 and collect.Variant == 350 and (collect.SubType==this.gunPowder or collect.SubType==this.paper or collect.SubType==this.blood or collect.SubType==this.rib or collect.SubType==this.feather) then
            Isaac.Spawn(5, 350, 0, collect.Position, vectorZero, player)
            collect:Remove()
         end 
      end
   end
end

function this.spawnCauldron(pos)
   Isaac.Spawn(Isaac.GetEntityTypeByName("Cauldron"), Isaac.GetEntityVariantByName("Cauldron"), 0, pos, vectorZero, player)
   Isaac.Spawn(1000, 15, 0, pos, vectorZero, npc)
   sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.75, 0, false, 1)
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
     --elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
     --player.Damage = player.Damage - 0.17
     --elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then 
     --   player.MaxFireDelay = player.MaxFireDelay - 1
     end
  end
end

local HudMaterials = Sprite() HudMaterials:Load("gfx/ui/hudMaterials.anm2", true)
local HudNumbers = Sprite() HudNumbers:Load("gfx/ui/hudNumbers.anm2", true)
local HudChoose = Sprite() HudChoose:Load("gfx/ui/hudChooseMaterial.anm2", true)
   
function RenderNumber(n, Position)
   if n==nil then n=0 end
   HudNumbers:SetFrame("Idle", math.floor(n/10))
   HudNumbers:RenderLayer(0,Position)
   HudNumbers:SetFrame("Idle", n % 10)
   HudNumbers:RenderLayer(0,Position+Vector(6,0))
end

function this:onRender()
   local player = Isaac.GetPlayer(0)
   if player:GetPlayerType() == this.playerAwan and deliveranceData.temporary.awanStartUp then 
      for i=1, 5 do 
        HudMaterials:SetFrame("Idle", i-1)
        HudMaterials:RenderLayer(0, Vector(-8+i*16,234))
        RenderNumber(deliveranceData.temporary.hasMaterial[i], Vector(-6+i*16,252))
      end
      HudChoose:Play("Idle", false)
      HudChoose:RenderLayer(0, Vector(this.currentSlot*16,246))
      HudChoose:Update()
      if not game:IsPaused() and Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0) then
         if this.currentSlot<5 then
            this.currentSlot=this.currentSlot+1
         else
            this.currentSlot=1
         end
      end
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.Update)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.PostInit)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.EvaluateCache)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.nullCauldronSpawn)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.onRender)
end

return this