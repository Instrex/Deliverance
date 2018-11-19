mod = RegisterMod("Kal-Mem", 1)
game = Game()

utils = require('scripts.utils')

-- Mod data --
data = {

  -- Remains even after restart --
  persistent = {

  },

  -- Being cleared after restart --
  temporary = {

  }
}

dataHandler = require('scripts.dataHandler')
dataHandler.init()

-- Register mod content here --
content = {

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
    bloodyStream              = require 'scripts.items.bloodyStream',
    breathOfDevil             = require 'scripts.items.breathOfDevil'
  },

  trinkets = {
    uncertainty               = require 'scripts.trinkets.uncertainty',
    appleCore                 = require 'scripts.trinkets.appleCore',
    krampusHorn               = require 'scripts.trinkets.krampusHorn',
    darkLock                  = require 'scripts.trinkets.darkLock'
  },

  entities = {
    raga                      = require 'scripts.entities.monsters.raga',
    nutcracker                = require 'scripts.entities.monsters.nutcracker',
    jester                    = require 'scripts.entities.monsters.jester',
    joker                     = require 'scripts.entities.monsters.joker',
    beamo                     = require 'scripts.entities.monsters.beamo',
    cracker                   = require 'scripts.entities.monsters.cracker'
  },

  costumes = {
    noAutoload = true,
    sailorHat = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_sailorhat.anm2"),
    saltySoup = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_saltySoup.anm2")
  }
}

-- Content Initialization --
print("Kalmem: Loading content... ! ")
for q, r in pairs(content) do
  if r.noAutoload == nil then
    for k, v in pairs(r) do
      print("Kalmem: Loading " .. k .. " " .. q .. "...")
      v.Init()
    end
  end
end
