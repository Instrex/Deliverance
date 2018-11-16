local mod = RegisterMod("Kal-Mem", 1)
local game = Game()

--                  Collectibles
local lifetap = Isaac.GetItemIdByName("Life Tap")
local breathofdevil = Isaac.GetItemIdByName("Breath of the Devil")
local secondChance = Isaac.GetItemIdByName("Second Chance")
local sailorhat = Isaac.GetItemIdByName("Sailor's Hat")
local dheart = Isaac.GetItemIdByName("D<3")
local sistersheart = Isaac.GetItemIdByName("Sister's Heart")
local sage = Isaac.GetItemIdByName("Sage")
local specialdelivery = Isaac.GetItemIdByName("Special Delivery")

--                   Pills
local soultemesisPill = Isaac.GetPillEffectByName("Dissociative Reaction")

--                  Monsters
local cracker = Isaac.GetEntityTypeByName("Cracker")
local glutty = Isaac.GetEntityTypeByName("Nutcracker")
local jester = Isaac.GetEntityTypeByName("Jester")
local joker = Isaac.GetEntityTypeByName("Joker")
local beamo = Isaac.GetEntityTypeByName("Beamo")

--                   Familiars
local sisheart = Isaac.GetEntityVariantByName("Sister's Heart")
local sagesoul = Isaac.GetEntityVariantByName("Sage Soul")

--                   Projectiles
local specialDel_target = Isaac.GetEntityVariantByName("Special Delivery Target")
local specialDel  = Isaac.GetEntityVariantByName("Special Delivery")

--                  Cards
local card_mannaz = Isaac.GetCardIdByName("Mannaz")

--                  Trinkets
local discountBrochure = Isaac.GetTrinketIdByName("Discount Brochure")


local costumes = {
  sailorhat_costume = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_sailorhat.anm2"),
  tech3k_costume = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_tech3000.anm2")
}
----------------------------------------
-- Life Tap
----------------------------------------

LifeTapCount = 0
function mod:lifeTapUse()
  local EntityPlayer = Isaac.GetPlayer(0)
  if EntityPlayer:GetMaxHearts() >= 2 then
    EntityPlayer:AddMaxHearts(-2, false)
    SFXManager():Play(SoundEffect.SOUND_MAW_OF_VOID , 0.8, 0, false, 1)
    EntityPlayer:AnimateSad()
    LifeTapCount = LifeTapCount + 1;
  end
  if EntityPlayer:GetHearts() == 0 and EntityPlayer:GetSoulHearts() == 0 and EntityPlayer:GetBlackHearts() == 0
  and EntityPlayer:GetBoneHearts() == 0 then
    EntityPlayer:Die()
  end
  if EntityPlayer:GetPlayerType() == PlayerType.PLAYER_THELOST then
    EntityPlayer:Die()
  end
end

function mod:lifeTapCache(player, flag)
  if LifeTapCount > 0 then
    if flag == CacheFlag.CACHE_DAMAGE then
      player.Damage = player.Damage + (LifeTapCount * 1.1 + 1);

      -- Prevent Delay From Going Too Low
      -- (Best Practice Is 5 As Lowest Value)
      if player.MaxFireDelay >= 5 + (LifeTapCount + 1) * 2 then
        player.MaxFireDelay = player.MaxFireDelay - (LifeTapCount + 1) * 2;
      elseif player.MaxFireDelay >= 5 then
        player.MaxFireDelay = 5;
      end
    end

    if flag == CacheFlag.CACHE_SPEED then
      player.MoveSpeed = player.MoveSpeed + (LifeTapCount + 1) * 0.3;
    end

    if flag == CacheFlag.CACHE_RANGE then
      player.TearHeight = player.TearHeight - 1;
      --player.TearFallingSpeed = player.TearFallingSpeed - 1;
      --player.TearColor = TearFlags.TEAR_FEAR;
    end

    if flag == CacheFlag.CACHE_SHOTSPEED then
      player.ShotSpeed = player.ShotSpeed + (LifeTapCount + 1) * 0.15;
    end
  end
end

function mod:NullLifeTap()
  LifeTapCount = 0
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.lifeTapUse, lifetap)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.lifeTapCache)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.NullLifeTap)

----------------------------------------
---Pill: Dissociative Reaction
----------------------------------------

function mod:soultesPill(soultemesisPill)
  local player = Isaac.GetPlayer(0)
  local hearts = player:GetSoulHearts() - 1
  player:AddSoulHearts(0 - (hearts + 1))
  for i = 0, hearts do
    local room = Game():GetRoom()
    local position = Isaac.GetFreeNearPosition(player.Position,1)
    Isaac.Spawn(5, 10, 8, position, Vector(0, 0), player)
  end
end
Isaac.AddPillEffectToPool(soultemesisPill)
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.soultesPill, soultemesisPill)

------------------------------------------
-- Monster: Cracker -------------------------
------------------------------------------

function mod:update(cracker)

    local sprite = cracker:GetSprite();
    local player = Isaac.GetPlayer(0);
    local data = cracker:GetData()
    if not data.initialized then

data.died = false

data.initialized = true

    end

    if(cracker.State == NpcState.STATE_INIT) then
        cracker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        cracker.State = NpcState.STATE_MOVE;
    end
    if(cracker.State == NpcState.STATE_MOVE) then

--      cracker.Velocity = (cracker:GetPlayerTarget().Position - cracker.Position):Normalized()*3
      cracker.Pathfinder:FindGridPath(player.Position, 0.75, 2, false)

      cracker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

        randomAttack = math.random(1,30);

        if randomAttack < 2 or cracker:CollidesWithGrid() then
            SFXManager():Play(SoundEffect.SOUND_MEAT_JUMPS , 1.2, 0, false, 1)
            cracker.State = NpcState.STATE_ATTACK;
            cracker.StateFrame = 0;
        end

    end

    if(cracker.State == NpcState.STATE_ATTACK) then
        sprite:Play("Jump");

        cracker.Velocity = (player.Position - cracker.Position):Normalized()*7.5

        local grindex = game:GetRoom():GetGridIndex(cracker.Position + cracker.Velocity)
        local grid = game:GetRoom():GetGridEntity(grindex)
        if grid and grid.Desc.Type~=GridEntityType.GRID_DECORATION and grid.Desc.Type~=GridEntityType.GRID_SPIKES and grid.Desc.Type~=GridEntityType.GRID_SPIKES_ONOFF and grid.Desc.Type~=GridEntityType.GRID_SPIKES_ONOFF and grid.Desc.Type~=GridEntityType.GRID_SPIDERWEB and grid.Desc.Type~=GridEntityType.GRID_PRESSURE_PLATE then
            game:GetRoom():DestroyGrid(grindex, true)
        end

        if(sprite:IsFinished("Jump")) then

            cracker.State = NpcState.STATE_ATTACK2;
            cracker.StateFrame = 0;
            SFXManager():Play(SoundEffect.SOUND_POT_BREAK , 1, 0, false, 1)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(0, 7.5), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(7.5, 0), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(0, -7.5), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(-7.5, 0), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(6, 6), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(-6, 6), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(6, -6), player)
            Isaac.Spawn(9, 0, 0, cracker.Position, Vector(-6, -6), player)
            Game():ShakeScreen(6)
        end
    end

    if(cracker.State == NpcState.STATE_ATTACK2) then
        if(cracker.StateFrame == 0) then
            sprite:Play("Land");

            player = Isaac.GetPlayer(0);
            cracker.Velocity = (player.Position - cracker.Position):Normalized()*0
            angle = math.random(1,359);
            mag = math.random(5,10);

        end

        if(sprite:IsFinished("Land")) then
            randomAttack = math.random(-30,-15);
            cracker.State = NpcState.STATE_MOVE;
            cracker.StateFrame = 0;
        end
        cracker.StateFrame = cracker.StateFrame + 1;
    end

        if(cracker:IsDead()) then
          Isaac.Spawn(1000, 77, 0, cracker.Position, Vector(0, 0), player)
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, cracker)


function mod:hosttocracker(entity)

        local game = Game()
	local level = game:GetLevel()
        local current_floor = level:GetStage()
        local player = Isaac.GetPlayer(0)
        if entity.FrameCount <= 5 then
            local chance = math.random(1,5)
            if (chance == 1 and current_floor == LevelStage.STAGE4_1 or current_floor == LevelStage.STAGE4_2) then
                enemy = entity:ToNPC()
                if enemy then
                    Isaac.Spawn(cracker,0,0,enemy.Position, Vector(0,0), player);
                    player.Remove(enemy,enemy.Position, Vector(0,0), player);
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hosttocracker, 247)

------------------------------------------
-- Monster: Jester -------------------------
------------------------------------------

function mod:update(jester)

    local player = Isaac.GetPlayer(0);
    local randomAttack=0;
    local sprite = jester:GetSprite();
    local data = jester:GetData()
    if not data.initialized then
      data.targetVel = Vector(0, 0)
      data.died = false
      data.initialized = true
    end

    if(jester.State == NpcState.STATE_INIT) then
        jester:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        jester.State = NpcState.STATE_MOVE;
    end

    if(jester.State == NpcState.STATE_MOVE) then

    jester.Pathfinder:FindGridPath(player.Position, 0.75, 1, false)

    jester:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

        if (jester.Position:Distance(player.Position) <= 250) then
          jester.StateFrame = jester.StateFrame + 1
        end

        if(jester.StateFrame == 50) then
            SFXManager():Play(SoundEffect.SOUND_FAT_GRUNT , 1.2, 0, false, 1)
            jester.State = NpcState.STATE_ATTACK;
            jester.StateFrame = 0;
            randomAttack=0
        end

    end

    if(jester.State == NpcState.STATE_ATTACK) then
        sprite:Play("Charge");
        jester.Velocity = (player.Position - jester.Position):Normalized()*0

        if(sprite:IsFinished("Charge")) then

            jester.State = NpcState.STATE_ATTACK2;
            jester.StateFrame = 0;
            SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1)
            local urod = Game():Spawn(227, 0, jester.Position, Vector(0,0), jester, 0, 1):ToNPC()
            jester:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            urod.HitPoints = 3
            urod.State = 0
            urod:SetSize(9, Vector(1,1), 12)
            urod.Scale = 0.75
            Isaac.Spawn(1000, 15, 0, jester.Position+Vector(0, 15), Vector(0, 0), nil)
            Game():ShakeScreen(3)
        end
    end

    if(jester.State == NpcState.STATE_ATTACK2) then
        if(jester.StateFrame == 0) then
            sprite:Play("Summon");

            player = Isaac.GetPlayer(0);
            jester.Velocity = (player.Position - jester.Position):Normalized()*0

        end

        if(sprite:IsFinished("Summon")) then
            jester.State = NpcState.STATE_MOVE;
            jester.StateFrame = 0;
        end
        jester.StateFrame = jester.StateFrame + 1;
    end

        if math.random(1, 25) == 1 then
          if(jester:IsDead()) then
            proj = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card_mannaz, jester.Position, Vector(0, 0), player)
          end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, jester)

function mod:hosttojester(entity)

        local game = Game()
	local level = game:GetLevel()
        local current_floor = level:GetStage()
        local player = Isaac.GetPlayer(0)
        if entity.FrameCount <= 5 then
            if (math.random(1,5) == 1 and current_floor == LevelStage.STAGE3_1 or current_floor == LevelStage.STAGE3_2) then
                enemy = entity:ToNPC()
                if enemy then
                    Isaac.Spawn(jester,0,0,enemy.Position, Vector(0,0), player);
                    player.Remove(enemy,enemy.Position, Vector(0,0), player);
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hosttojester, 27)


------------------------------------------
-- Monster: Joker -------------------------
------------------------------------------

function mod:update(joker)

    local  player = Isaac.GetPlayer(0);
    local randomAttack=0;
    sprite = joker:GetSprite();
    local data = joker:GetData()
    if not data.initialized then
      data.targetVel = Vector(0, 0)
      data.died = false
      data.initialized = true
    end

    if(joker.State == NpcState.STATE_INIT) then
        joker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        joker.State = NpcState.STATE_MOVE;
    end

    if(joker.State == NpcState.STATE_MOVE) then

    joker.Pathfinder:FindGridPath(player.Position, 0.88, 1, false)

    joker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

        if (joker.Position:Distance(player.Position) <= 250) then
          joker.StateFrame = joker.StateFrame + 1
        end

        randomAttack = math.random(1,6);
        if(joker.StateFrame == 75) then
            SFXManager():Play(SoundEffect.SOUND_FAT_GRUNT , 1.2, 0, false, 1)

        if(randomAttack < 3) then
            joker.State = NpcState.STATE_ATTACK;
            joker.StateFrame = 0;
        end

        if(randomAttack >=3) then
            joker.State = NpcState.STATE_ATTACK3;
            joker.StateFrame = 0;
        end
        end

    end

    if(joker.State == NpcState.STATE_ATTACK) then

        sprite:Play("Charge");
        joker.Velocity = (player.Position - joker.Position):Normalized()*0

        if(sprite:IsFinished("Charge")) then

            joker.State = NpcState.STATE_ATTACK2;
            joker.StateFrame = 0;
            SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1)
            local urod = Game():Spawn(277, 0, joker.Position, Vector(0,0), joker, 0, 1):ToNPC()

            joker:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            urod.HitPoints = 3
            urod.State = 0
            urod:SetSize(9, Vector(1,1), 12)
            urod.Scale = 0.75
            Isaac.Spawn(1000, 15, 0, joker.Position+Vector(0, 15), Vector(0, 0), nil)
            Game():ShakeScreen(3)
        end
    end

    if(joker.State == NpcState.STATE_ATTACK2) then
        if(joker.StateFrame == 0) then
            sprite:Play("Summon");

            player = Isaac.GetPlayer(0);
            joker.Velocity = (player.Position - joker.Position):Normalized()*0

        end

        if(sprite:IsFinished("Summon")) then
            joker.State = NpcState.STATE_MOVE;
            joker.StateFrame = 0;
        end
        joker.StateFrame = joker.StateFrame + 1;
    end

    if(joker.State == NpcState.STATE_ATTACK3) then
        sprite:Play("Charge2");

    player = Isaac.GetPlayer(0);
    joker.Velocity = (player.Position - joker.Position):Normalized()*0

        if(sprite:IsFinished("Charge2")) then

            joker.State = NpcState.STATE_ATTACK4;
            joker.StateFrame = 0;
            SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_2 , 1, 0, false, 1)

            local brimstone_laser = EntityLaser.ShootAngle(1, joker.Position, 45, 15, Vector(0,-20), joker)

            brimstone_laser.DepthOffset = 200
            local brimstone_laser2 = EntityLaser.ShootAngle(1, joker.Position, 135, 15, Vector(0,-20), joker)

            brimstone_laser2.DepthOffset = 200
            local brimstone_laser3 = EntityLaser.ShootAngle(1, joker.Position, 225, 15, Vector(0,-20), joker)

            brimstone_laser3.DepthOffset = 200
            local brimstone_laser4 = EntityLaser.ShootAngle(1, joker.Position, 315, 15, Vector(0,-20), joker)

            brimstone_laser4.DepthOffset = 200

        end
    end

    if(joker.State == NpcState.STATE_ATTACK4) then
        if(joker.StateFrame == 0) then
            sprite:Play("Brimstone");

            player = Isaac.GetPlayer(0);
            joker.Velocity = (player.Position - joker.Position):Normalized()*0

        end

        if(sprite:IsFinished("Brimstone")) then
            joker.State = NpcState.STATE_MOVE;
            joker.StateFrame = 0;
        end
        joker.StateFrame = joker.StateFrame + 1;
    end

        if(joker:IsDead()) then
           Isaac.Explode(joker.Position, joker, 1.0)

           if math.random(1, 12) == 1 then
             proj = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card_mannaz, joker.Position, Vector(0, 0), player)
           end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, joker)

function mod:hosttojoker(entity)

        local game = Game()
	local level = game:GetLevel()
        local current_floor = level:GetStage()
        local player = Isaac.GetPlayer(0)
        if entity.FrameCount <= 5 then
            if math.random(1,5) == 1 and (current_floor == LevelStage.STAGE5_1 or current_floor == LevelStage.STAGE5_2) then
                enemy = entity:ToNPC()
                if enemy then
                    Isaac.Spawn(joker,0,0,enemy.Position, Vector(0,0), player);
                    player.Remove(enemy,enemy.Position, Vector(0,0), player);
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hosttojoker, 27)

------------------------------------------
-- Monster: Beamo -------------------------
------------------------------------------

function mod:update(beamo)
    local player = Isaac.GetPlayer(0)
    local sprite = beamo:GetSprite()
    local current_floor = level:GetStage()
    local brim_type=1;

    if (current_floor == LevelStage.STAGE5 or current_floor == LevelStage.STAGE5_GREED) then
      if level:GetStageType() == StageType.STAGETYPE_WOTL then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/dreamo.png")
        sprite:LoadGraphics()
        brim_type=3
      else
        sprite:ReplaceSpritesheet(0,"gfx/monsters/brimo.png")
        sprite:LoadGraphics()
        brim_type=1
      end
    else
        sprite:ReplaceSpritesheet(0,"gfx/monsters/beamo.png")
        sprite:LoadGraphics()
        brim_type=1
    end

    if(beamo.State == NpcState.STATE_INIT) then
        sprite:Play("Move");

        beamo.State = NpcState.STATE_MOVE;
    end

    if(beamo.State == NpcState.STATE_MOVE) then

      sprite:Play("Move");
      beamo.StateFrame = beamo.StateFrame + 1;

        if (beamo.StateFrame == 15) then
            if math.random(1, 3) == 1 then
              SFXManager():Play(SoundEffect.SOUND_RAGMAN_1, 1.2, 0, false, 1)
            else
              SFXManager():Play(SoundEffect.SOUND_RAGMAN_2, 1.2, 0, false, 1)
            end
        end

        if (beamo.StateFrame >= 30) then
          if player.Position.Y > beamo.Position.Y-40 and player.Position.Y < beamo.Position.Y+40  then
            if(player.Position.X > beamo.Position.X) then
              beamo.State = NpcState.STATE_ATTACK;
              beamo.StateFrame = 0;
              beamo.Velocity = Vector(0,0);
            else
              beamo.State = NpcState.STATE_ATTACK2;
              beamo.StateFrame = 0;
              beamo.Velocity = Vector(0,0);
            end
          end
        end

        beamo.Pathfinder:MoveRandomly();
    end

    if(beamo.State == NpcState.STATE_ATTACK) then

        sprite:Play("BrimstoneLeft");
        if(sprite:IsFinished("BrimstoneLeft")) then
            beamo.Velocity = Vector(-3,0);
            beamo.State = NpcState.STATE_MOVE;
            beamo.StateFrame = 0;
        end

        if sprite:IsEventTriggered("BrimLeft")
        then
            SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
            local brimstone_laser = EntityLaser.ShootAngle(brim_type, beamo.Position, 180, 15, Vector(-25,-9), beamo)

            brimstone_laser.DepthOffset = 200
            beamo.Velocity = Vector(25,0)
        end

        beamo.StateFrame = beamo.StateFrame + 1;

    end

    if(beamo.State == NpcState.STATE_ATTACK2) then

        sprite:Play("BrimstoneRight");
        if(sprite:IsFinished("BrimstoneRight")) then
            beamo.Velocity = Vector(3,0);
            beamo.State = NpcState.STATE_MOVE;
            beamo.StateFrame = 0;
        end

        if sprite:IsEventTriggered("BrimRight")
        then
            SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
            local brimstone_laser = EntityLaser.ShootAngle(brim_type, beamo.Position, 0, 15, Vector(22,-9), beamo)

            brimstone_laser.DepthOffset = 200
            beamo.Velocity = Vector(-25,0)
        end

        beamo.StateFrame = beamo.StateFrame + 1;

    end


    if(beamo:IsDead()) then
        proj = Isaac.Spawn(1000, 77, 0, beamo.Position, Vector(0, 0), player)
        if current_floor == LevelStage.STAGE5 and level:GetStageType() == StageType.STAGETYPE_WOTL then
          proj.Color = Color( 0, 0, 0,   1,   150, 150, 150)
        end
    end

end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, beamo)

function mod:redghosttobeamo(entity)

        local game = Game()
	local level = game:GetLevel()
        local current_floor = level:GetStage()
        local player = Isaac.GetPlayer(0)
        if entity.FrameCount <= 5 then
            if math.random(1,5) == 1 then
                enemy = entity:ToNPC()
                if enemy then
                    Isaac.Spawn(beamo,0,0,enemy.Position, Vector(0,0), player);
                    player.Remove(enemy,enemy.Position, Vector(0,0), player);
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.redghosttobeamo, 285)


-------------------------------------------
-- Cards: Mannaz -------------------
-------------------------------------------

function mod:CardCallback(cardId)
  local player = Isaac.GetPlayer(0)
  if cardId == card_mannaz then
    hearts = player:GetMaxHearts()
    player:AddSoulHearts(hearts * 2)
    player:AddMaxHearts(0 - hearts)
    SFXManager():Play(SoundEffect.SOUND_HOLY , 1, 0, false, 1.1)
  end
end

function mod:MannazSprite()
  for i,card in pairs(Isaac.GetRoomEntities()) do
    if card.Type == EntityType.ENTITY_PICKUP and card.Variant == PickupVariant.PICKUP_TAROTCARD and card.SubType == card_mannaz then
      local spr = card:GetSprite()
      spr:ReplaceSpritesheet(0,"gfx/items/pick ups/pickup_card.png")
      spr:LoadGraphics()
    end
  end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.CardCallback, card_mannaz)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.MannazSprite)

-------------------------------------------
-- Breath of Devil ------------------------
-------------------------------------------

local discStage = 0
local stage = 0
function mod:breathOfDevilUpdate()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(breathofdevil) then
    local curStage = Game():GetLevel():GetAbsoluteStage()
    if curStage > stage then
      local seed = Game():GetLevel():GetDevilAngelRoomRNG():GetSeed()
      if player:HasCollectible(414) then
        for i=0, 2 do
          pick = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, seed), Vector(240+(i*80),320), Vector(0,0), nil)
          pick:ToPickup().TheresOptionsPickup = true
        end
      elseif player:HasCollectible(249) then
        for i=0, 1 do
          pick = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, seed), Vector(280+(i*80),320), Vector(0,0), nil)
          pick:ToPickup().TheresOptionsPickup = true
        end
      else Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, seed), Vector(320,320), Vector(0,0), nil)
      end
      stage = curStage
      Game():ShakeScreen(30)
      SFXManager():Play(SoundEffect.SOUND_MAW_OF_VOID , 0.8, 0, false, 1)
      mod:Save()
    end

    local roomEntities = Isaac.GetRoomEntities()
    for e, entity in pairs(roomEntities) do
      if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART and entity.Visible == true then
        Isaac.Spawn(1000, 15, 0, entity.Position, Vector(0, 0), player)
        entity.Visible = false
        entity:Die()
        Game():ShakeScreen(2)
      end
    end
  end
end

function mod:InitPlayerVars(player)
  mod:Load()
  Isaac.GetPlayer(0):CheckFamiliar(sagesoul, sagesCount, RNG())
end

function mod:NullVariables()
  stage = 0
  discStage = 0
  darkStage = 0
  publicStage = 0
  sagesCount = 0
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.breathOfDevilUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.InitPlayerVars)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.NullVariables)

-------------------------------------------------------------------------------------------
--  SAVE IMPORTANT VARIABLES
-------------------------------------------------------------------------------------------
local publicStage = 0
local json = require("json")
mod.Data = {
  devilStage = 0,
  discountStage = 1,
  darkStage = 0,
  publicStage = 0,
  sagesCount = 0
}

function mod:Save()
  mod.Data.devilStage = stage
  mod.Data.discountStage = discStage
  mod.Data.darkStage = darkStage
  mod.Data.publicStage = publicStage
  mod.Data.sagesCount = sagesCount
  mod:SaveData(json.encode(mod.Data))
end

function mod:Load()
  if mod:HasData() then
    local loadData = json.decode(mod:LoadData())
    stage = loadData.devilStage
    discStage = loadData.discountStage
    darkStage = loadData.darkStage
    publicStage = mod.Data.publicStage
    sagesCount = mod.Data.sagesCount
    Isaac.GetPlayer(0):CheckFamiliar(sagesoul, sagesCount, RNG())
  end
end

-------------------------------------------------------------------------------------------
--  PublicStage
-------------------------------------------------------------------------------------------
-- потому что делать отдельную переменную для каждого ебучего предмета - говно!

function mod:OnNewStage(stageNum)
  -- функции для выполнения при переходе на новый этаж
  mod:SageFloor()
  mod:Save()
end

function mod:UpdatePublicStage()
  local stg = Game():GetLevel():GetAbsoluteStage()
  if stg > publicStage then
    publicStage = stg
    if publicStage ~= 0 then
      mod:OnNewStage(stg)
    end
  end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.UpdatePublicStage)
-------------------------------------------------------------------------------------------
--  Trinket: Discount Brochure
-------------------------------------------------------------------------------------------
function mod:DiscountBrochureUpdate()
  local player = Isaac.GetPlayer(0)
  if player:HasTrinket(discountBrochure) then
    local curStage = Game():GetLevel():GetAbsoluteStage()
    if curStage > discStage then
      player:UseCard(Card.CARD_HERMIT)
      discStage = curStage
      mod:Save()
    end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.DiscountBrochureUpdate)

-------------------------------------------------------------------------------------------
--  Second Chance
-------------------------------------------------------------------------------------------

function mod:SecondChanceUpdate()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(secondChance) then
    if player:GetHearts() == 0 and player:GetSoulHearts() == 0
    and player:GetBoneHearts() == 0 and player:GetBlackHearts() == 0 then
      SFXManager():Play(SoundEffect.SOUND_SUPERHOLY, 0.8, 0, false, 1)
      player:Revive()
      player:AddSoulHearts(2)

      if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        player:AddBoneHearts(2)
        player:AddSoulHearts(-2)
      end

      if player:GetPlayerType() == PlayerType.XXX then
        player:AddSoulHearts(6)
      end

      player:SetFullHearts()
      player:RemoveCollectible(secondChance)

      for e, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() then
          entity:TakeDamage(40, 0, EntityRef(nil), 0)
          entity:AddConfusion(EntityRef(nil), 60, false)
        end
      end
    end
  end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.SecondChanceUpdate)
-------------------------------------------------------------------------------------------
--  D<3
-------------------------------------------------------------------------------------------

function mod:dHeartReroll()
  local player = Isaac.GetPlayer(0)
  local roomEntities = Isaac.GetRoomEntities()
  for e, entity in pairs(roomEntities) do
    if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_HEART then
      entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, math.random(1, 11), false)
    end
  end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.dHeartReroll, dheart)

-------------------------------------------------------------------------------------------
--  FAMILIAR FUNCTIONS
-------------------------------------------------------------------------------------------

function mod:CheckRoomEnemies()
  local count = 0
  for _, entity in pairs(Isaac.GetRoomEntities()) do
    if entity:IsVulnerableEnemy() then
      count = count + 1
    end
  end
  return count
end

function SpawnFollower(Variant, player)
  return Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Variant, 0, player.Position, Vector(0,0), player):ToFamiliar()
end

function RealignFamiliars()
  local target = nil
  for _, entity in pairs(Isaac.GetRoomEntities()) do
    if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Child == nil then
      if target == nil then
        target = entity
      else
        if target.FrameCount < entity.FrameCount then
          target.Parent = entity
          entity.Child = target
        else
          entity.Parent = target
          target.Child = entity
        end
      end
    end
  end
end


-------------------------------------------------------------------------------------------
--  Bitwise Operations
-------------------------------------------------------------------------------------------
function bit(p)
     return 1 << p
end

function hasbit(x, p)
    return (x & p) ~= 0
end

function setbit(x, p)
    return x | p
end

-------------------------------------------------------------------------------------------
--  Sage
-------------------------------------------------------------------------------------------
--         ~ FAMILIAR
local sagesCount = 0
function mod:SageSoulInit(s)
  s:AddToFollowers()
end

function mod:OnSageSoulCache(player, flag)
  player:CheckFamiliar(sagesoul, sagesCount, RNG())
end

function mod:SageSoulBehaviour(sh)
  local sprite = sh:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = sh:GetData()

  --if sprite:IsFinished("Appear") then
  --  data.appeared = 1
  --end

    if sprite:IsFinished("Appear") then
      sh.State = 1
    end

    if sh.State == 1 then
      if player:GetFireDirection() ~= Direction.NO_DIRECTION then
        sprite:Play("Shoot")
        if sprite:IsEventTriggered("Shoot") then
          local vel = Vector(1, 0)
          if Input.IsMouseBtnPressed(0) then vel = (Input.GetMousePosition(true) - sh.Position):Normalized()*8
          elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then vel = player:GetAimDirection()*8
          end

          if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
            Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, sh.Position + Vector(-2, 4), vel, nil):ToTear()
            Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, sh.Position + Vector(2, 4), vel, nil):ToTear()
          else
            proj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, sh.Position + Vector(0, 12), vel, nil):ToTear()
          end
        end
      else
        sprite:Play("Idle")
      end
    end
    sh:FollowParent();
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnSageSoulCache)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.SageSoulBehaviour, sagesoul)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.SageSoulInit, sagesoul)

--        ~ ITEMS

function mod:UseSage()
  local player = Isaac.GetPlayer(0)
  for _, entity in pairs(Isaac.GetRoomEntities()) do
    if entity:IsVulnerableEnemy() then
      if sagesCount < 6 then
        entity:TakeDamage(10, 0, EntityRef(nil), 0)
      else entity:TakeDamage(40, 0, EntityRef(nil), 0) end
    end
  end
  sagesCount = math.min(sagesCount + 1, 6)
  player:CheckFamiliar(sagesoul, sagesCount, RNG())
  mod:Save()
  player:EvaluateItems()
end

function mod:SageFloor()
  if sagesCount > 0 then
    sagesCount = 0
    local player = Isaac.GetPlayer(0)
    player:CheckFamiliar(sagesoul, sagesCount, RNG())
    proj = Isaac.Spawn(1000, 15, 0, player.Position, Vector(0, 0), player)
    proj.Color = Color( 0, 0, 0,   1,   255, 0, 255)
  end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseSage, sage)

-------------------------------------------------------------------------------------------
--  Special Delivery
-------------------------------------------------------------------------------------------

-- ~  TARGET

function mod:UpdateSpecDeliveryTarget(s)
  local sprite = s:GetSprite()
  local data = s:GetData()
  local player = Isaac.GetPlayer(0)

  if data.time == nil then data.time = 0 end

  if data.time ~= -1 then data.time = data.time + 1
    if data.time < 30  then sprite:Play("Idle")
    elseif data.time < 40 then sprite:Play("Explode")
    elseif data.time == 40 then sprite:Play("Die") data.time = -1 end
  end

  if sprite:IsFinished("Die") then s:Remove() Isaac.Spawn(1000, specialDel, 0, s.Position, Vector(0, 0), nil) player:AnimateCollectible(specialdelivery, "HideItem", "Idle") end

  if Input.IsMouseBtnPressed(0) then s.Velocity = (Input.GetMousePosition(true) - s.Position) / 6
  elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then s.Velocity = player:GetAimDirection()*10
  else s.Velocity = Vector(0,0) end
end

function mod:SpecDeliveryBehaviour(s)
  local sprite = s:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = s:GetData()

  if data.init == nil then data.init = 1 sprite:Play("Main") end

  if sprite:IsEventTriggered("Land") then
    SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 1)
  end

  if sprite:IsEventTriggered("Explode") then
    Isaac.Explode(s.Position, player, 180)
    local rand = math.random(0, 3)

    if rand == 0 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, math.random(0, 2), s.Position, Vector(0,0), nil) end
    if rand == 1 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, math.random(0, 2), s.Position, Vector(0,0), nil) end
    if rand == 2 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 1, s.Position, Vector(0,0), nil) end
    if rand == 3 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, math.random(0, 11), s.Position, Vector(0,0), nil) end
  end

  if sprite:IsEventTriggered("Die") then
    s:Remove()
  end
end

function mod:UseSpecDelivery()
  local player = Isaac.GetPlayer(0)
  Isaac.Spawn(1000, specialDel_target, 0, player.Position, Vector(0, 0), nil)
  player:AnimateCollectible(specialdelivery, "LiftItem", "Idle")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseSpecDelivery, specialdelivery)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE , mod.UpdateSpecDeliveryTarget, specialDel_target)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE , mod.SpecDeliveryBehaviour, specialDel)
