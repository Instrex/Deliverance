local json = require 'json'
local this = {}

this.unsaved = false
this.loaded = false

function this.load()
  if mod:HasData() then
    data = json.decode(mod:LoadData())
  end

  this.loaded = true

  if not data.temporary then
    data.temporary = {}
  end

  local meta = {
    __newindex = function(t, k, v)
      rawset(t, k, v)
      if type(v) == 'table' then
        setmetatable(t[k], meta)
      end

      this.unsaved = true
    end
  }

  setmetatable(data.temporary, meta)
end

function this.directSave()
  mod:SaveData(json.encode(data))
end

function this.save()
  if this.unsaved and this.loaded then
    this.directSave()
    this.unsaved = false
  end
end

function this.leave()
  this.save()
  this.loaded = false
end

function this.finalize()
  data.temporary = {}

  this.directSave()
  this.loaded = false
end

function this.init()
  mod:AddCallback(ModCallbacks.MC_POST_GAME_END, this.finalize)
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, this.leave)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED , this.load)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.save)
end

return this
