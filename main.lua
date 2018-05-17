local mod = RegisterMod("Kal-Mem", 1)
local game = Game()

--                  Collectibles
local capbrooch = Isaac.GetItemIdByName("Captain's Brooch")
local lifetap = Isaac.GetItemIdByName("Life Tap")
local sisterskey = Isaac.GetItemIdByName("Sister's Key")
local breathofdevil = Isaac.GetItemIdByName("Breath of the Devil")
local secondChance = Isaac.GetItemIdByName("Second Chance")
local sailorhat = Isaac.GetItemIdByName("Sailor's Hat")
local dheart = Isaac.GetItemIdByName("D<3")
local tech3k = Isaac.GetItemIdByName("Technology 3000")
local sistersheart = Isaac.GetItemIdByName("Sister's Heart")
local sage = Isaac.GetItemIdByName("Sage")
local fadedsage = Isaac.GetItemIdByName("Faded Sage")

local apple1 = Isaac.GetItemIdByName("The Apple")
local apple2 = Isaac.GetItemIdByName("Bitten Apple")
local apple3 = Isaac.GetItemIdByName("Half of the Apple")
local apple4 = Isaac.GetItemIdByName("A bit of Apple")

--                   Pills
local soultemesisPill = Isaac.GetPillEffectByName("Dissociative Reaction")

--                  Monsters
local raga = Isaac.GetEntityTypeByName("Raga")
local cracker = Isaac.GetEntityTypeByName("Cracker")
local jester = Isaac.GetEntityTypeByName("Jester")
local joker = Isaac.GetEntityTypeByName("Joker")
local beamo = Isaac.GetEntityTypeByName("Beamo")

--                   Familiars
local sisheart = Isaac.GetEntityVariantByName("Sister's Heart")
local sagesoul = Isaac.GetEntityVariantByName("Sage Soul")

--                  Cards
local card_mannaz = Isaac.GetCardIdByName("Mannaz")

--                  Trinkets
local discountBrochure = Isaac.GetTrinketIdByName("Discount Brochure")
local uncertainty = Isaac.GetTrinketIdByName("Uncertainty")
local darklock = Isaac.GetTrinketIdByName("Dark Lock")


local costumes = {
  sailorhat_costume = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_sailorhat.anm2"),
  tech3k_costume = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_tech3000.anm2")
}
----------------------------------------
-- Captain's Brooch
----------------------------------------

local holding_capbrooch = false
function mod:triggerCapBrooch()
    local player = Isaac.GetPlayer(0)
    local health_roll = math.random(1, 5)
    local room = Game():GetRoom()
    local position = Isaac.GetFreeNearPosition(room:GetCenterPos(),1)
    player:AnimateCollectible(capbrooch, "LiftItem", "Idle")
    holding_capbrooch = true
    if health_roll == 1 then
        sfxManager = SFXManager();
        sfxManager:Play(SoundEffect.SOUND_SUMMONSOUND  , 0.8, 0, false, 1)
        Isaac.Spawn(5, 60, 0, position, Vector(0, 0), player)
    else
        sfxManager = SFXManager();
        sfxManager:Play(SoundEffect.SOUND_SUMMONSOUND  , 0.8, 0, false, 1)
        Isaac.Spawn(5, 50, 0, position, Vector(0, 0), player)
    end
end

local frames_passed = 0
function mod:animateCapBrooch()
    if holding_capbrooch then
        frames_passed = frames_passed + 1
        if (frames_passed == 10) then
            local player = Isaac.GetPlayer(0) holding_capbrooch = false frames_passed = 0 player:AnimateCollectible(capbrooch, "HideItem", "Idle")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.triggerCapBrooch, capbrooch)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.animateCapBrooch)

----------------------------------------
-- Life Tap
----------------------------------------

LifeTapCount = 0
function mod:lifeTapUse()
  local EntityPlayer = Isaac.GetPlayer(0)
  if EntityPlayer:GetMaxHearts() >= 2 then
    EntityPlayer:AddMaxHearts(-2, false)
    sfxManager = SFXManager();
    sfxManager:Play(SoundEffect.SOUND_MAW_OF_VOID , 0.8, 0, false, 1)
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
-- Sister's Key
----------------------------------------

local holding_siskey = false
function mod:useSistersKey()

  local player = Isaac.GetPlayer(0)
  player:AnimateCollectible(sisterskey, "LiftItem", "Idle")
  holding_siskey = true

  local roomEntities = Isaac.GetRoomEntities()
  for e, entity in pairs(roomEntities) do
    if entity.Type == EntityType.ENTITY_PICKUP
    and entity.Variant == PickupVariant.PICKUP_LOCKEDCHEST or entity.Variant == PickupVariant.PICKUP_CHEST
    or entity.Variant == PickupVariant.PICKUP_SPIKEDCHEST or entity.Variant == PickupVariant.PICKUP_ETERNALCHEST
    or entity.Variant == PickupVariant.PICKUP_REDCHEST or entity.Variant == PickupVariant.PICKUP_BOMBCHEST
    and entity.SubType ~= ChestSubType.CHEST_CLOSED then
      sfxManager = SFXManager();
      sfxManager:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 0.8, 0, false, 1)
      entity:ToPickup():TryOpenChest()
    end
  end
end

local frames_pass = 0
function mod:animateSistersKey()
    if holding_siskey then
        frames_pass = frames_pass + 1
        if (frames_pass == 20) then
            local player = Isaac.GetPlayer(0) holding_siskey = false frames_pass = 0 player:AnimateCollectible(sisterskey, "HideItem", "Idle")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useSistersKey, sisterskey)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.animateSistersKey)

----------------------------------------
-- Apple
----------------------------------------

local holding_apple1 = false
local holding_apple2 = false
local holding_apple3 = false
local holding_apple4 = false
local applecount = 0
function mod:useApple()
  local player = Isaac.GetPlayer(0)
  player:AddHearts(2)
  --player:UseCard(Card.CARD_STRENGTH)

  if applecount == 0 then
    player:AnimateCollectible(apple1, "LiftItem", "Idle")
    holding_apple1 = true
    player:RemoveCollectible(apple1)
    player:AddCollectible(apple2, 1, false)
    SFXManager():Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 0.6)
  end

  if applecount == 1 then
    player:AnimateCollectible(apple2, "LiftItem", "Idle")
    holding_apple2 = true
    player:RemoveCollectible(apple2)
    player:AddCollectible(apple3, 1, false)
    SFXManager():Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 0.75)
  end

  if applecount == 2 then
    player:AnimateCollectible(apple3, "LiftItem", "Idle")
    holding_apple3 = true
    player:RemoveCollectible(apple3)
    player:AddCollectible(apple4, 1, false)
    SFXManager():Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 1)
  end

  if applecount == 3 then
    player:AnimateCollectible(apple4, "LiftItem", "Idle")
    holding_apple4 = true
    player:RemoveCollectible(apple4)
    SFXManager():Play(SoundEffect.SOUND_1UP , 0.8, 0, false, 1.25)
  end

  applecount = applecount + 1
end

function mod:NullApple()
  applecount = 0
end

local frames_pass = 0

function mod:animateApple1()
    if holding_apple1 then frames_pass = frames_pass + 1 if (frames_pass == 10) then local player = Isaac.GetPlayer(0) holding_apple1 = false frames_pass = 0 player:AnimateCollectible(apple1, "HideItem", "Idle")  end end
end
function mod:animateApple2()
    if holding_apple2 then frames_pass = frames_pass + 1 if (frames_pass == 10) then local player = Isaac.GetPlayer(0) holding_apple2 = false frames_pass = 0 player:AnimateCollectible(apple2, "HideItem", "Idle")  end end
end
function mod:animateApple3()
    if holding_apple3 then frames_pass = frames_pass + 1 if (frames_pass == 10) then local player = Isaac.GetPlayer(0) holding_apple3 = false frames_pass = 0 player:AnimateCollectible(apple3, "HideItem", "Idle")  end end
end
function mod:animateApple4()
    if holding_apple4 then frames_pass = frames_pass + 1 if (frames_pass == 10) then local player = Isaac.GetPlayer(0) holding_apple4 = false frames_pass = 0 player:AnimateCollectible(apple4, "HideItem", "Idle")  end end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useApple, apple1)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useApple, apple2)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useApple, apple3)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useApple, apple4)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.animateApple1)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.animateApple2)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.animateApple3)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.animateApple4)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.NullApple)

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
-- Monster: Raga -------------------------
------------------------------------------

function mod:update(raga)
    player = Isaac.GetPlayer(0);
    sprite = raga:GetSprite();

    if(raga.State == NpcState.STATE_INIT) then
        sprite:Play("Fly");
        raga.State = NpcState.STATE_MOVE;
    end

    if(raga.State == NpcState.STATE_MOVE) then

        sprite:Play("Fly");

        randomAttack = math.random(1,30);

        if(randomAttack < 2) then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MONSTER_GRUNT_0 , 1.2, 0, false, 1)
            raga.State = NpcState.STATE_ATTACK;
            raga.StateFrame = 0;
        end
    end

    if(raga.State == NpcState.STATE_ATTACK) then

        sprite:Play("Charge");
        randomAttack = math.random(1,6);

        if(sprite:IsFinished("Charge")) then
        if(randomAttack < 4) then
            raga.State = NpcState.STATE_ATTACK2;
            raga.StateFrame = 0;
        end

        if(randomAttack > 3) then
            raga.State = NpcState.STATE_ATTACK3;
            raga.StateFrame = 0;
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_RAGMAN_1 , 1, 0, false, 1)
            proj1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, raga.Position, Vector(7.5,7.5), nil);
            proj1:ToProjectile():AddProjectileFlags(ProjectileFlags.SMART)
            proj1:ToProjectile():AddHeight(-20)
            proj2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, raga.Position, Vector(7.5,-7.5), nil);
            proj2:ToProjectile():AddProjectileFlags(ProjectileFlags.SMART)
            proj2:ToProjectile():AddHeight(-20)
            proj3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, raga.Position, Vector(-7.5,7.5), nil);
            proj3:ToProjectile():AddProjectileFlags(ProjectileFlags.SMART)
            proj3:ToProjectile():AddHeight(-20)
            proj4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, raga.Position, Vector(-7.5,-7.5), nil);
            proj4:ToProjectile():AddProjectileFlags(ProjectileFlags.SMART)
            proj4:ToProjectile():AddHeight(-20)
        end
        end
    end

    if(raga.State == NpcState.STATE_ATTACK2) then
        if(raga.StateFrame == 0) then
            sprite:Play("Summon");

            angle = math.random(1,359);
            mag = math.random(5,10);

            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MONSTER_YELL_A , 0.8, 0, false, 1)
            Isaac.Spawn(222, 0, 0, raga.Position, Vector.FromAngle(angle):__mul(mag), nil);
        end

        if(sprite:IsFinished("Summon")) then
            raga.State = NpcState.STATE_MOVE;
            raga.StateFrame = 0;
        end
        raga.StateFrame = raga.StateFrame + 1;
    end

    if(raga.State == NpcState.STATE_ATTACK3) then
        if(raga.StateFrame == 0) then
            sprite:Play("Attack");
        end

        if(sprite:IsFinished("Attack")) then
            raga.State = NpcState.STATE_MOVE;
            raga.StateFrame = 0;
        end
        raga.StateFrame = raga.StateFrame + 1;
    end

        if(raga:IsDead()) then
        proj = Isaac.Spawn(1000, 77, 0, raga.Position, Vector(0, 0), player)
        proj.Color = Color( 0, 0, 0,   1,   90, 0, 90)
        end

    raga.Velocity = (player.Position - raga.Position):Normalized()*4
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, raga)

function mod:nulltoraga(entity)

        if entity.FrameCount <= 5 then
            local chance = math.random(1,5)
            if chance == 1 then
                enemy = entity:ToNPC()
                if enemy then
                    enemy:Morph(raga, 0, 0, 0)
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.nulltoraga, 252)

------------------------------------------
-- Monster: Cracker -------------------------
------------------------------------------

function mod:update(cracker)

    sprite = cracker:GetSprite();
    local data = cracker:GetData()
    if not data.initialized then

data.targetVel = Vector(0, 0)

data.died = false

data.initialized = true

    end

    if(cracker.State == NpcState.STATE_INIT) then
cracker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        cracker.State = NpcState.STATE_MOVE;
    end
    if(cracker.State == NpcState.STATE_MOVE) then

if math.random(1, 30) == 1 then

data.targetVel = (Isaac.GetRandomPosition() - cracker.Position):Normalized()*3

end

cracker.Velocity = cracker.Velocity * 0.7 + data.targetVel * 0.3

cracker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

        randomAttack = math.random(1,100);

        if(randomAttack < 2) then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MEAT_JUMPS , 1.2, 0, false, 1)
            cracker.State = NpcState.STATE_ATTACK;
            cracker.StateFrame = 0;
        end

    end

    if(cracker.State == NpcState.STATE_ATTACK) then
        sprite:Play("Jump");

    player = Isaac.GetPlayer(0);
    cracker.Velocity = (player.Position - cracker.Position):Normalized()*10

        if(sprite:IsFinished("Jump")) then

            cracker.State = NpcState.STATE_ATTACK2;
            cracker.StateFrame = 0;
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_POT_BREAK , 1, 0, false, 1)
            Isaac.Spawn(1000, 97, 0, cracker.Position, Vector(0,0), nil);
            local room = Game():GetRoom()
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(-30, 0), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(30, 0), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(0, -30), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(0, 30), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(22, 22), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(-22, 22), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(22, -22), Vector(0,0), nil);
            Isaac.Spawn(1000, 55, 0, cracker.Position+Vector(-22, -22), Vector(0,0), nil);
            Game():ShakeScreen(12)
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
        if entity.FrameCount <= 5 then
            local chance = math.random(1,5)
            if (chance == 1 and current_floor == LevelStage.STAGE4_1 or current_floor == LevelStage.STAGE4_2)
                then
                enemy = entity:ToNPC()
                if enemy then
                    enemy:Morph(cracker, 0, 0, 0)
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hosttocracker, 247)


------------------------------------------
-- Monster: Jester -------------------------
------------------------------------------

function mod:update(jester)

    local randomAttack=0;
    sprite = jester:GetSprite();
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

if math.random(1, 30) == 1 then

data.targetVel = (Isaac.GetRandomPosition() - jester.Position):Normalized()*2

end

jester.Velocity = jester.Velocity * 0.7 + data.targetVel * 0.3


jester:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        jester.StateFrame = jester.StateFrame + 1;

        if(jester.StateFrame == 50) then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_FAT_GRUNT , 1.2, 0, false, 1)
            jester.State = NpcState.STATE_ATTACK;
            jester.StateFrame = 0;
            randomAttack=0
        end

    end

    if(jester.State == NpcState.STATE_ATTACK) then
        sprite:Play("Charge");

    player = Isaac.GetPlayer(0);
    jester.Velocity = (player.Position - jester.Position):Normalized()*0

        if(sprite:IsFinished("Charge")) then

            jester.State = NpcState.STATE_ATTACK2;
            jester.StateFrame = 0;
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1)
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

        if math.random(1, 5) == 1 then

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
        if entity.FrameCount <= 5 then
            local chance = math.random(1,5)
            if (chance == 1 and current_floor == LevelStage.STAGE3_1 or current_floor == LevelStage.STAGE3_2)
                then
                enemy = entity:ToNPC()
                if enemy then
                    enemy:Morph(jester, 0, 0, 0)
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hosttojester, 27)


------------------------------------------
-- Monster: Joker -------------------------
------------------------------------------

function mod:update(joker)

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

if math.random(1, 30) == 1 then

data.targetVel = (Isaac.GetRandomPosition() - joker.Position):Normalized()*2

end

joker.Velocity = joker.Velocity * 0.7 + data.targetVel * 0.3


joker:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        joker.StateFrame = joker.StateFrame + 1;

        randomAttack = math.random(1,6);
        if(joker.StateFrame == 75) then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_FAT_GRUNT , 1.2, 0, false, 1)

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

    player = Isaac.GetPlayer(0);
    joker.Velocity = (player.Position - joker.Position):Normalized()*0

        if(sprite:IsFinished("Charge")) then

            joker.State = NpcState.STATE_ATTACK2;
            joker.StateFrame = 0;
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1)
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
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_2 , 1, 0, false, 1)

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

        if math.random(1, 5) == 1 then
        proj = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card_mannaz, joker.Position, Vector(0, 0), player)
        end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, joker)

function mod:hosttojoker(entity)
        local game = Game()
	local level = game:GetLevel()
        local current_floor = level:GetStage()
        if entity.FrameCount <= 5 then
            local chance = math.random(1,5)
            if (chance == 1 and current_floor == LevelStage.STAGE5_1 or current_floor == LevelStage.STAGE5_2)
                then
                enemy = entity:ToNPC()
                if enemy then
                    enemy:Morph(joker, 0, 0, 0)
                end
            end
        end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.hosttojoker, 27)


function mod:update(beamo)
    player = Isaac.GetPlayer(0);
    sprite = beamo:GetSprite();

    if(beamo.State == NpcState.STATE_INIT) then
        sprite:Play("Idle");
        beamo.State = NpcState.STATE_MOVE;
    end

    if(beamo.State == NpcState.STATE_MOVE) then

        sprite:Play("Idle");

        beamo.Velocity = (player.Position - beamo.Position):Normalized()*0
        beamo.StateFrame = beamo.StateFrame + 1;
        randomAttack = math.random(1,6);
        if (beamo.StateFrame == 10) then
          if player.Position.Y > beamo.Position.Y-32 and player.Position.Y < beamo.Position.Y+32  then
            if(player.Position.X > beamo.Position.X) then
              beamo.State = NpcState.STATE_ATTACK2;
              beamo.StateFrame = 0;
            elseif(player.Position.X < beamo.Position.X) then
              beamo.State = NpcState.STATE_ATTACK3;
              beamo.StateFrame = 0;
            end
          else
            beamo.State = NpcState.STATE_ATTACK;
            beamo.StateFrame = 0;
          end
        end
    end

    if(beamo.State == NpcState.STATE_ATTACK) then

        sprite:Play("Hop");
        if(sprite:IsFinished("Hop")) then
            beamo.State = NpcState.STATE_MOVE;
            beamo.StateFrame = 0;
        end
        beamo.Velocity = (player.Position - beamo.Position):Normalized()*4

        if sprite:IsEventTriggered("MeatSound1") then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
        end
        if sprite:IsEventTriggered("MeatSound2") then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 0, false, 1)
        end
    end

    if(beamo.State == NpcState.STATE_ATTACK2) then

        sprite:Play("BrimstoneLeft");
        if(sprite:IsFinished("BrimstoneLeft")) then
            beamo.State = NpcState.STATE_MOVE;
            beamo.StateFrame = 0;
        end

        if sprite:IsEventTriggered("BrimLeft")
        then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
            local brimstone_laser = EntityLaser.ShootAngle(1, beamo.Position, 180, 15, Vector(-32,-13), beamo)

            brimstone_laser.DepthOffset = 200
            beamo.Velocity = Vector(20,0)
        end

        beamo.StateFrame = beamo.StateFrame + 1;

    end

    if(beamo.State == NpcState.STATE_ATTACK3) then

        sprite:Play("BrimstoneRight");
        if(sprite:IsFinished("BrimstoneRight")) then
            beamo.State = NpcState.STATE_MOVE;
            beamo.StateFrame = 0;
        end

        if sprite:IsEventTriggered("BrimRight")
        then
            sfxManager = SFXManager();
            sfxManager:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 1)
            local brimstone_laser = EntityLaser.ShootAngle(1, beamo.Position, 0, 15, Vector(32,-13), beamo)

            brimstone_laser.DepthOffset = 200
            beamo.Velocity = Vector(-20,0)
        end

        beamo.StateFrame = beamo.StateFrame + 1;

    end

end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update, beamo)


-------------------------------------------
-- Cards: Mannaz -------------------
-------------------------------------------

function mod:CardCallback(cardId)
  local player = Isaac.GetPlayer(0)
  if cardId == card_mannaz then
    hearts = player:GetMaxHearts()
    player:AddSoulHearts(hearts * 2)
    player:AddMaxHearts(0 - hearts)
    SFXManager():Play(SoundEffect.SOUND_HOLY , 0.8, 0, false, 1.25)
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
    mod:Save()
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
    mod:OnNewStage(stg)
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
--  Trinket: Uncertainty
-------------------------------------------------------------------------------------------

function mod:triggerUncertainty()
    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(uncertainty) then

      player:UseActiveItem(CollectibleType.COLLECTIBLE_D8, false, false, false, false)

    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.triggerUncertainty, EntityType.ENTITY_PLAYER)

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
--  Sailor's Hat
-------------------------------------------------------------------------------------------

function mod:applySailorsHatCache(player, flag)
    if player:HasCollectible(sailorhat) then
      if flag == CacheFlag.CACHE_TEARCOLOR then
        player:AddNullCostume(costumes.sailorhat_costume)
      elseif flag == CacheFlag.CACHE_SPEED then
       player.MoveSpeed = player.MoveSpeed + 0.2
    end
  end
end

function mod:SpawnCreepOnHit(npc)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and player:HasCollectible(sailorhat) then
      local roll = math.random(1, 6-(math.min(player.Luck, 4)))
      if roll == 2 then
      Isaac.Spawn(1000, 54, 0, npc.Position, Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, npc.Position+Vector(20, 0), Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, npc.Position+Vector(-20, 0), Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, npc.Position+Vector(0, 20), Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, npc.Position+Vector(0, -20), Vector(0, 0), player)
      end
  end
end



function mod:SpawnCreepOnPlayer()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(sailorhat) then

      Isaac.Spawn(1000, 54, 0, player.Position, Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, player.Position+Vector(20, 0), Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, player.Position+Vector(-20, 0), Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, player.Position+Vector(0, 20), Vector(0, 0), player)
      Isaac.Spawn(1000, 54, 0, player.Position+Vector(0, -20), Vector(0, 0), player)

    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.SpawnCreepOnPlayer, EntityType.ENTITY_PLAYER)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.SpawnCreepOnHit)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.applySailorsHatCache)


-------------------------------------------------------------------------------------------
--  Trinket: Dark Lock
-------------------------------------------------------------------------------------------

local darkStage = 0
function mod:DarkLockUpdate()
  local player = Isaac.GetPlayer(0)
  if player:HasTrinket(darklock) then
    local curStage = Game():GetLevel():GetAbsoluteStage()
    if curStage > darkStage then
      darkStage = curStage

      if curStage == 1 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, Vector(320,320), Vector(0,0), nil)
      end

      if curStage == 2 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 3, Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 3 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, Vector(320,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 4 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(0,Card.NUM_CARDS), Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, Vector(320,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 5 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 6, Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 6 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(0,Card.NUM_CARDS), Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 7 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(0,Card.NUM_CARDS), Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 8 then
        for i=0, 1 do
          for q=0, 1 do
            pick = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, Vector(240+(i*160),260+(60*q)), Vector(0,0), nil)
          end
        end
      end

      if curStage == 9 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 2, Vector(300,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 2, Vector(320,320), Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 2, Vector(340,320), Vector(0,0), nil)
      end

      if curStage == 10 and Game():GetLevel():IsAltStage() == false then
        for i=0, 1 do
          for q=0, 1 do
            pick = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, Vector(240+(i*160),260+(60*q)), Vector(0,0), nil)
          end
        end
      end

      if curStage == 10 and Game():GetLevel():IsAltStage() == true then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, 0, Vector(320,320), Vector(0,0), nil)
      end

      if curStage == 11 then
        local seed = Game():GetLevel():GetDevilAngelRoomRNG():GetSeed()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, seed), Vector(320,240), Vector(0,0), nil)
        player:TryRemoveTrinket(darklock)
      end

      mod:Save()
    end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.DarkLockUpdate)

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
--  Technology 3000
-------------------------------------------------------------------------------------------
function mod:ApplyTech3kCostume(player, flag)
    if player:HasCollectible(tech3k) then
      if flag == CacheFlag.CACHE_TEARCOLOR then
        player:AddNullCostume(costumes.tech3k_costume)
      end
    end
end

function mod:UpdateTech3k()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(tech3k) then
    if player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0  then
      if math.random(0, 10-(math.min(player.Luck, 5))) == 1 then
        local direction = Vector(player.Velocity.X, player.Velocity.Y):Rotated(180)
        player:FireTechLaser(player.Position, LaserOffset.LASER_TECH1_OFFSET , direction, false, false)
      end
    end
  end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyTech3kCostume)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.UpdateTech3k)

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
--  Sister's Heart
-------------------------------------------------------------------------------------------

function mod:SistersHeartBehaviour(sh)
  local sprite = sh:GetSprite()
  local player = Isaac.GetPlayer(0)
  local data = sh:GetData()

  local sfx = SFXManager()

  if mod:CheckRoomEnemies() >= 1 then
    if player:GetFireDirection() == Direction.NO_DIRECTION then
      sprite:Play("Shoot")
    else sprite:Play("Intense") end

    if sprite:IsEventTriggered("Shoot") then
      sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTER, 1, 0, false, 1)
      proj = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 1, sh.Position + Vector(0, 15), Vector(-3,0):Rotated(math.random(0, 360)), nil):ToTear()
    end

    if sprite:IsEventTriggered("IntenseShoot") then
      if data.Offset == nil then data.Offset = 0 end

      sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTEST, 1, 0, false, 1)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, sh.Position + Vector(0, 15), Vector(7, 0):Rotated(10 * data.Offset), nil)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, sh.Position + Vector(0, 15), Vector(-7, 0):Rotated(10 * data.Offset), nil)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, sh.Position + Vector(0, 15), Vector(0, 7):Rotated(10 * data.Offset), nil)
      Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, sh.Position + Vector(0, 15), Vector(0, -7):Rotated(10 * data.Offset), nil)
      data.Offset = data.Offset + 1
    end
  else
    sprite:Play("Idle")
  end

  if player:GetFireDirection() == Direction.NO_DIRECTION then
    sh:FollowParent()
  else sh.Velocity = Vector(0, 0) end

end

function mod:SistersHeartInit(s)
  s:AddToFollowers()
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.SistersHeartBehaviour, sisheart)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.SistersHeartInit, sisheart)

function mod:OnSistersHeartCache(player, flag)
  player:CheckFamiliar(sisheart, player:GetCollectibleNum(sistersheart) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1), RNG())
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnSistersHeartCache)

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

  local sfx = SFXManager()
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
          proj = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, sh.Position + Vector(0, 12), player:GetAimDirection()*8, nil):ToTear()
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
      entity:TakeDamage(10, 0, EntityRef(nil), 0)
      sagesCount = math.min(sagesCount + 1, 6)
    end
  end
  player:CheckFamiliar(sagesoul, sagesCount, RNG())
  mod:Save()
  player:RemoveCollectible(sage)
  player:AddCollectible(fadedsage, 0, false)
  player:EvaluateItems()
end

function mod:SageFloor()
  sagesCount = 0
  local player = Isaac.GetPlayer(0)
  if Isaac.GetPlayer(0):HasCollectible(fadedsage) then
    player:RemoveCollectible(fadedsage)
    player:AddCollectible(sage, 0, false)
  end
  player:CheckFamiliar(sagesoul, sagesCount, RNG())
  mod:Save()
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseSage, sage)
