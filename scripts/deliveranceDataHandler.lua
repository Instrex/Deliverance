local json = require 'json'
local this = {}

this.unsaved = false
this.loaded = false


function this:load(fromSave)
--print(fromSave)
  if fromSave then
    deliveranceData.temporary = {}
    deliveranceData = json.decode(mod:LoadData())
  else
    deliveranceData.temporary = {}
    this.directSave()
  end
  npcPersistence._reload()
--  this.loaded = true
--
--  if not data.temporary or not fromSave then
--    data.temporary = {}
--  end
--
--  local meta = {
--    __index = function(t, k, v)
--     rawset(t, k, v)
--      if type(v) == 'table' then
--        setmetatable(t[k], meta)
--      end
--
--      this.unsaved = true
--    end
--  }
--
--  setmetatable(data.temporary, meta)
end

function this.directSave()
  mod:SaveData(json.encode(deliveranceData))
end

function this.save()
  this.directSave()
end

function this.leave()
  this.directSave()
end

function this.finalize()
  deliveranceData.temporary = {}

  this.directSave()
  this.loaded = false
end

function this.init()
  mod:AddCallback(ModCallbacks.MC_POST_GAME_END, this.finalize)
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, this.leave)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, this.load)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.save)
end

return this
