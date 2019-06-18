local this = {}
this.costume = Isaac.GetCostumeIdByPath("gfx/characters/costumes/character_awan.anm2")
this.playerAwan = Isaac.GetPlayerTypeByName("Awan")
this.gunPowder = Isaac.GetTrinketIdByName("Gunpowder")
this.paper = Isaac.GetTrinketIdByName("Piece of Paper")
this.blood = Isaac.GetTrinketIdByName("Bottled Blood")
this.rib = Isaac.GetTrinketIdByName("Wooden Rib")
this.feather = Isaac.GetTrinketIdByName("Glowing Feather")

this.speedBonus = 0

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
      if level:GetAbsoluteStage() == 1 and level.EnterDoor == -1 and player.FrameCount == 1 then
        
         this.speedBonus = 0
         player:AddCacheFlags(CacheFlag.CACHE_SPEED)
         player:EvaluateItems()
         if player:GetPlayerType() == this.playerAwan and not player:IsDead() then
            --player:AddCollectible(CollectibleType.COLLECTIBLE_MOMS_PURSE, 0, false)
            --player:AddTrinket(COLLECTIBLE_MOMS_PURSE)
            player:AddCard(Card.CARD_DICE_SHARD)
         end
      end
      if room:GetFrameCount() == 1 then
	--if player:HasCollectible(CollectibleType.COLLECTIBLE_GUILLOTINE) or player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
	--    player:AddNullCostume(this.justHeadCostume)
	--else
	--    player:TryRemoveNullCostume(this.justHeadCostume)
	    player:AddNullCostume(this.costume)
	--end
      end
      for e, collect in pairs(Isaac.GetRoomEntities()) do 
         if collect.Type == 5 then 
            if collect.Variant == 100 and this.checkForCauldron()==0 and collect.SubType ~= CollectibleType.COLLECTIBLE_POLAROID and collect.SubType ~= CollectibleType.COLLECTIBLE_NEGATIVE then
               Isaac.Spawn(1000, 15, 0, collect.Position, vectorZero, npc)
               sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0, false, 0.8)
               local loot = Utils.choose(this.blood, this.rib, this.paper, this.gunPowder, this.feather)
               local amount = 1

               if room:GetType() == RoomType.ROOM_DEVIL then       loot = Utils.choose(this.blood, this.rib) amount=Utils.choose(1,2)
               elseif room:GetType() == RoomType.ROOM_SHOP then    loot = Utils.choose(this.paper, this.gunPowder)
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

               for i=1, amount do Isaac.Spawn(5, 350, loot, collect.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), npc) end

               collect:Remove()
            end
            if collect.Variant == 350 and collect.SubType~=this.gunPowder and collect.SubType~=this.paper and collect.SubType~=this.blood and collect.SubType~=this.rib and collect.SubType~=this.feather then
               Isaac.Spawn(5, 350, Utils.choose(this.blood, this.rib, this.paper, this.gunPowder, this.feather), collect.Position, vectorZero, npc)
               collect:Remove()
            end 
         end 
      end

      if utils.switchData('cauldronSpawned') then
         Isaac.Spawn(Isaac.GetEntityTypeByName("Cauldron"), Isaac.GetEntityVariantByName("Cauldron"), 0, Isaac.GetFreeNearPosition(player.Position - Vector(100, 200), 1), vectorZero, player)
      end

      if room:IsClear() then this.speedBonus=1.85 else this.speedBonus=1 end
      player:AddCacheFlags(CacheFlag.CACHE_SPEED)
      player:EvaluateItems()
    end
   else
      for e, collect in pairs(Isaac.GetRoomEntities()) do 
         if collect.Type == 5 and collect.Variant == 350 and (collect.SubType==this.gunPowder or collect.SubType==this.paper or collect.SubType==this.blood or collect.SubType==this.rib or collect.SubType==this.feather) then
            Isaac.Spawn(5, 350, 0, collect.Position, vectorZero, npc)
            collect:Remove()
         end 
      end
   end
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
	player.Damage = player.Damage - 0.17
     --elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then 
     --   player.MaxFireDelay = player.MaxFireDelay - 1
     end
  end
end

function this.Init()
  mod:AddCallback( ModCallbacks.MC_POST_UPDATE, this.Update)
  mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, this.PostInit)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.EvaluateCache)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.nullCauldronSpawn)
end

return this