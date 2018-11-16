mod = RegisterMod("Kal-Mem", 1)
game = Game()
utils = require('scripts.utils')

-- Register mod content here --
content = {

  items = {
    sistersKey                = require 'scripts.items.sistersKey',
    sistersHeart              = require 'scripts.items.familiars.sistersHeart',
    capBrooch                 = require 'scripts.items.captainsBrooch',
    theApple                  = require 'scripts.items.theApple',
    lighter                   = require 'scripts.items.lighter',
    shrinkRay                 = require 'scripts.items.shrinkRay',
    sailorHat                 = require 'scripts.items.sailorHat'
  },

  trinkets = {
    uncertainty           = require 'scripts.trinkets.uncertainty',
    appleCore             = require 'scripts.trinkets.appleCore',
    krampusHorn           = require 'scripts.trinkets.krampusHorn',
    darkLock              = require 'scripts.trinkets.darkLock'
  },

  entities = {
    raga                  = require 'scripts.entities.monsters.raga',
    glutty                = require 'scripts.entities.monsters.glutty'
  },

  costumes = {
    noAutoload = true,
    sailorHat = Isaac.GetCostumeIdByPath("gfx/costumes/animation_costume_sailorhat.anm2")
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
