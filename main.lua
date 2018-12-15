mod = RegisterMod("tBoi: Deliverance", 1)
game = Game()

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
    scaredyShroom             = require 'scripts.items.familiars.scaredyShroom'
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
    seraphim                  = require 'scripts.entities.monsters.seraphim'
  },

  costumes = {
    noAutoload = true,
    sailorHat = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_sailorhat.anm2"),
    saltySoup = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_saltySoup.anm2"),
    gasoline = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_gasoline.anm2"),
    luckySaucer = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_luckySaucer.anm2"),
    theCovenant = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_theCovenant.anm2"),
    adamsRib = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_adamsRib.anm2"),
    hotmilk = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_hotmilk.anm2"),
    adamsRib2 = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_adamsRib2.anm2")
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
