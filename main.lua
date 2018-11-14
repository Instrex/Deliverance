mod = RegisterMod("Kal-Mem", 1)
game = Game()
utils = require('scripts.utils')

-- Register mod content here --
content = {

  items = {
    sisKey                = require 'scripts.items.sistersKey',
    capBrooch             = require 'scripts.items.captainsBrooch'
  },

  trinkets = {
    uncertainty           = require 'scripts.trinkets.uncertainty',
    krampusHorn           = require 'scripts.trinkets.krampusHorn'
  },

  entities = {
    raga                  = require 'scripts.entities.monsters.raga'
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
