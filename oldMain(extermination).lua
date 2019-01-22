local mod = RegisterMod("Kal-Mem", 1)
local game = Game()

--                  Collectibles
local sage = Isaac.GetItemIdByName("Sage")


--                   Familiars
local sagesoul = Isaac.GetEntityVariantByName("Sage Soul")

--                  Trinkets
local discountBrochure = Isaac.GetTrinketIdByName("Discount Brochure")

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
  return Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Variant, 0, player.Position, vectorZero, player):ToFamiliar()
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
    proj = Isaac.Spawn(1000, 15, 0, player.Position, vectorZero, player)
    proj.Color = Color( 0, 0, 0,   1,   255, 0, 255)
  end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseSage, sage)