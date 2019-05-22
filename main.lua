mod = RegisterMod("tBoi: Deliverance", 1)
game = Game()
sfx = SFXManager()
vectorZero = Vector(0,0)

utils = require('scripts.utils')

-- Mod data --
deliveranceData = {

  -- Remains even after restart --
  persistent = {

  },

  -- Being cleared after restart --
  temporary = {

  }
}

deliveranceDataHandler = require('scripts.deliveranceDataHandler')
deliveranceDataHandler.init()

 -- Register mod content here --
deliveranceContent = {

  items = {
    sistersKey                = require 'scripts.items.sistersKey',
    sistersHeart              = require 'scripts.items.familiars.sistersHeart',
    specialDelivery           = require 'scripts.items.specialDelivery',
    capBrooch                 = require 'scripts.items.captainsBrooch',
    theApple                  = require 'scripts.items.theApple',
    lighter                   = require 'scripts.items.lighter',
    shrinkRay                 = require 'scripts.items.shrinkRay',
    sailorHat                 = require 'scripts.items.sailorHat',
    dheart                    = require 'scripts.items.dheart',
    saltySoup                 = require 'scripts.items.saltySoup',
    gasoline                  = require 'scripts.items.gasoline',
    luckySaucer               = require 'scripts.items.luckySaucer',
    bloodyStream              = require 'scripts.items.bloodyStream',
    theCovenant               = require 'scripts.items.theCovenant',
    adamsRib                  = require 'scripts.items.adamsRib',
    goodOldFriend             = require 'scripts.items.goodOldFriend',
    hotMilk                   = require 'scripts.items.hotMilk',
    battleRoyale              = require 'scripts.items.battleRoyale',
    sage                      = require 'scripts.items.familiars.sage',
    rottenPorkChop            = require 'scripts.items.rottenPorkChop',
    lilTummy                  = require 'scripts.items.familiars.lilTummy',
    scaredyShroom             = require 'scripts.items.familiars.scaredyShroom',
    drMedicine                = require 'scripts.items.drMedicine',
    manuscript                = require 'scripts.items.manuscript',
    roundBattery              = require 'scripts.items.familiars.roundBattery'
  },

  trinkets = {
    uncertainty               = require 'scripts.trinkets.uncertainty',
    appleCore                 = require 'scripts.trinkets.appleCore',
    krampusHorn               = require 'scripts.trinkets.krampusHorn',
    discountBrochure          = require 'scripts.trinkets.discountBrochure',
    darkLock                  = require 'scripts.trinkets.darkLock',
    specialPenny              = require 'scripts.trinkets.specialPenny'
  },

  cards = {
    mannaz                   = require 'scripts.cards.mannaz'
  },

  pills = {
    dissReaction             = require 'scripts.pills.dissReaction'
  },

  entityVariants = {
    dorkyHaunt                = require 'scripts.entities.monsters.variants.dorkyHaunt',
    dukie                     = require 'scripts.entities.monsters.variants.dukie',
    greenLevel2Fly            = require 'scripts.entities.monsters.variants.greenLevel2Fly'
  },

  entities = {
    raga                      = require 'scripts.entities.monsters.raga',
    nutcracker                = require 'scripts.entities.monsters.nutcracker',
    jester                    = require 'scripts.entities.monsters.jester',
    joker                     = require 'scripts.entities.monsters.joker',
    beamo                     = require 'scripts.entities.monsters.beamo',
    cracker                   = require 'scripts.entities.monsters.cracker',
    peabody                   = require 'scripts.entities.monsters.peabody',
    rosenberg                 = require 'scripts.entities.monsters.rosenberg',
    shroomeo                  = require 'scripts.entities.monsters.shroomeo',
    tinhorn                   = require 'scripts.entities.monsters.tinhorn',
    musk                      = require 'scripts.entities.monsters.musk',
    gelatino                  = require 'scripts.entities.monsters.gelatino',
    fathost                   = require 'scripts.entities.monsters.fathost',
    cadaver                   = require 'scripts.entities.monsters.cadaver',
    eddie                     = require 'scripts.entities.monsters.eddie',
    explosimaw                = require 'scripts.entities.monsters.explosimaw',
    seraphim                  = require 'scripts.entities.monsters.seraphim',
    fistubomb                 = require 'scripts.entities.monsters.fistubomb',
    fistulauncher             = require 'scripts.entities.monsters.fistulauncher'   
  },

  costumes = {
    noAutoload = true,
    sailorHat = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_sailorhat.anm2"),
    saltySoup = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_saltySoup.anm2"),
    gasoline = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_gasoline.anm2"),
    luckySaucer = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_luckySaucer.anm2"),
    theCovenant = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_theCovenant.anm2"),
    adamsRib = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_adamsRib.anm2"),
    hotmilk = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_hotmilk.anm2"),
    adamsRib2 = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_adamsRib2.anm2"),
    manuscript = Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_manuscript.anm2")
  }
}

 -- Content Initialization --
print("tBoI Deliverance: Loading content... ! ")
for q, r in pairs(deliveranceContent) do
  if r.noAutoload == nil then
    for k, v in pairs(r) do
      print("tBoI Deliverance: Loading " .. k .. " " .. q .. "...")
      v.Init()
    end
  end
end

if not __eidItemDescriptions then         
  __eidItemDescriptions = {}
end	

__eidItemDescriptions[Isaac.GetItemIdByName("Captain's Brooch")] = "Creates a treasure chest nearby";
__eidItemDescriptions[Isaac.GetItemIdByName("Sister's Key")] = "Opens all chests in the room";
__eidItemDescriptions[Isaac.GetItemIdByName("D<3")] = "Turns all pickups into different kinds of hearts";
__eidItemDescriptions[Isaac.GetItemIdByName("Special Delivery")] = "Summons a box with random things";
__eidItemDescriptions[Isaac.GetItemIdByName("Golden Apple")] = "Fully restores health, then turning into Apple core";
__eidItemDescriptions[Isaac.GetItemIdByName("Lighter")] = "Ignites all enemies in the room";
__eidItemDescriptions[Isaac.GetItemIdByName("Shrink Ray")] = "Shrinks all enemies in the room";
__eidItemDescriptions[Isaac.GetItemIdByName("Bloody Stream")] = "Summons huge brimstone pillars destroying everything in its path";
__eidItemDescriptions[Isaac.GetItemIdByName("Battle Royale")] = "Summons a friendly copy of every enemy in the room, making them fight each other";
__eidItemDescriptions[Isaac.GetItemIdByName("The Covenant")] = "Devil room contain more things, but all hearts are replaced by other pickups";
__eidItemDescriptions[Isaac.GetItemIdByName("Good Old Friend")] = "Revives you once, dealing damage to all enemies in the room";
__eidItemDescriptions[Isaac.GetItemIdByName("Adam's Rib")] = "Enemies with full health take extra damage";
__eidItemDescriptions[Isaac.GetItemIdByName("Sailor Hat")] = "Creates large puddles when tear hits the enemy";
__eidItemDescriptions[Isaac.GetItemIdByName("Gasoline")] = "Kindles damaging fires when enemy's dies";
__eidItemDescriptions[Isaac.GetItemIdByName("Salty Soup")] = "Increases firerate and movement speed, but gives a chance to miss";
__eidItemDescriptions[Isaac.GetItemIdByName("Lucky Saucer")] = "Increases luck by 3";
__eidItemDescriptions[Isaac.GetItemIdByName("Hot Milk")] = "Tears get random increases and decreases in damage";
__eidItemDescriptions[Isaac.GetItemIdByName("Rotten Pork Chop")] = "Chance to powerfully fart during shot";
__eidItemDescriptions[Isaac.GetItemIdByName("Dr. Medicine")] = "Restores half heart each time you swallow a pill";
__eidItemDescriptions[Isaac.GetItemIdByName("The Manuscript")] = "Gives half of soul heart each time you use a card/rune";
__eidItemDescriptions[Isaac.GetItemIdByName("Sister's Heart")] = "Shoots tear in different directions, increases the firerate when you have little health";
__eidItemDescriptions[Isaac.GetItemIdByName("Sage")] = "Shoots tears at enemies, increasing number of tears fired when damage taken";
__eidItemDescriptions[Isaac.GetItemIdByName("Lil Tummy")] = "Shoots six tears in different directions";
__eidItemDescriptions[Isaac.GetItemIdByName("Scaredy-shroom")] = "Shoots tears, but hides when enemies near";
__eidItemDescriptions[Isaac.GetItemIdByName("Edgeless Cube Battery")] = "Shoots lasers every time enemy's projectile hit it";

if not __eidTrinketDescriptions then
  __eidTrinketDescriptions = {}
end	

__eidTrinketDescriptions[Isaac.GetTrinketIdByName("Discount Brochure")] = "Teleports you to a shop after reaching next floor.";
__eidTrinketDescriptions[Isaac.GetTrinketIdByName("Uncertainty")] = "Changes your stats every time you taking damage";
__eidTrinketDescriptions[Isaac.GetTrinketIdByName("Dark Lock")] = "Adds more items in red chests";
__eidTrinketDescriptions[Isaac.GetTrinketIdByName("Krampus' Horn")] = "Chance to teleport to devil room when taking damage";
__eidTrinketDescriptions[Isaac.GetTrinketIdByName("Apple Core")] = "Chance to swallow apple core when taking damage and restore all health";
__eidTrinketDescriptions[Isaac.GetTrinketIdByName("Special Penny")] = "Shopkeepers now always spawns with coins in eyes";

if not __eidCardDescriptions  then
  __eidCardDescriptions  = {}
end

__eidCardDescriptions[Isaac.GetCardIdByName("Mannaz")] = "Replaces all of yours red hearts with twice amount of soul hearts"

if not __eidPillDescriptions  then
  __eidPillDescriptions  = {}
end

__eidPillDescriptions[Isaac.GetPillEffectByName("Dissociative Reaction")] = "Drops all of your soul hearts on floor"
