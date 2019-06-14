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
    specialPenny              = require 'scripts.trinkets.specialPenny',
    littleTransducer          = require 'scripts.trinkets.littleTransducer'
  },

  cards = {
    farewellStone             = require 'scripts.cards.farewellStone',
    firestorms                = require 'scripts.cards.firestorms',
    glitch                    = require 'scripts.cards.glitch',
    abyss                     = require 'scripts.cards.abyss',
  },

  pills = {
    dissReaction              = require 'scripts.pills.dissReaction'
  },

  entityVariants = {
    dukie                     = require 'scripts.entities.monsters.variants.dukie',
    greenLevel2Fly            = require 'scripts.entities.monsters.variants.greenLevel2Fly',
    greenLevel2Spider         = require 'scripts.entities.monsters.variants.greenLevel2Spider'
  },

  entities = {
    persistent = {
      chestBoy                = require 'scripts.entities.chestBoy' 
    },

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
    fistulauncher             = require 'scripts.entities.monsters.fistulauncher',
    lilbonydies               = require 'scripts.entities.monsters.lilbonydies',
    rosenbergspit             = require 'scripts.entities.monsters.rosenbergspit',
    creampile                 = require 'scripts.entities.monsters.creampile'
  },

  costumes = {
    noAutoload = true,

    sailorHat                 = utils.getCostume('sailorhat'),
    saltySoup                 = utils.getCostume('saltySoup'),
    gasoline                  = utils.getCostume('gasoline'),
    luckySaucer               = utils.getCostume('luckySaucer'),
    theCovenant               = utils.getCostume('theCovenant'),
    adamsRib                  = utils.getCostume('adamsRib'),
    hotmilk                   = utils.getCostume('hotmilk'),
    adamsRib2                 = utils.getCostume('adamsRib2'),
    manuscript                = utils.getCostume('manuscript')
  }
}

deliveranceDataHandler = require('scripts.deliveranceDataHandler')
deliveranceDataHandler.init()

npcPersistence = require 'scripts.npcPersistenceHandler'
npcPersistence.init(deliveranceContent.entities.persistent)

cardHandler = require 'scripts.cardHandler'
cardHandler.init(deliveranceContent.cards)

-- Content Initialization --
local eid = require 'scripts.eidHandler'
eid.init()

for type, r in pairs(deliveranceContent) do
  if r.noAutoload == nil then
    for name, class in pairs(r) do
      --      print("tBoI Deliverance: Loading " .. k .. " " .. q .. "...")
      eid.tryAddDescription(type, class)
      if class.Init then
        class.Init()
      end
    end
  end
end

print("tBoI Deliverance: Successfully initialized! Have a nice run :)")