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

--                   Pills
local soultemesisPill = Isaac.GetPillEffectByName("Dissociative Reaction")


--                   Familiars
local sagesoul = Isaac.GetEntityVariantByName("Sage Soul")

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