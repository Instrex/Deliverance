local this = {}
function this.init(classes) 
    this.objects = {}
    for name, class in pairs(classes) do 
        class.Init()

        table.insert(this.objects, {class.id, class.variant})
    end

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.onNewRoom)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.onNewLevel)
end

function this._reload()
    register = deliveranceData.temporary._persistent or {}
end

function this.update(entity)
    for i = 1, #register do
        if register[i].type == entity.Type and
        register[i].variant == entity.Variant and
        register[i].room == game:GetLevel():GetCurrentRoomIndex() and
        register[i].index == entity:GetData()._index then
            table.remove(register, i)
            this._add(entity)

            break
        end
    end

    this._save() 
end

function this.remove(entity)
    for i = 1, #register do
        if register[i].type == entity.Type and
        register[i].variant == entity.Variant and
        register[i].room == game:GetLevel():GetCurrentRoomIndex() and
        register[i].index == entity:GetData()._index then
            table.remove(register, i)

            break
        end
    end

    this._save() 
end

function this.initEntity(entity)
    return this._add(entity)
end

function this._save() 
    deliveranceData.temporary._persistent = register
    deliveranceDataHandler.directSave()
end

-- Register control --
local register = {}
local function restore()
    for i = 1, #register do
        if register[i].room == game:GetLevel():GetCurrentRoomIndex() then
            local entity = Isaac.Spawn(register[i].type, register[i].variant, 0, Vector(register[i].x, register[i].y), vectorZero, nil)
            local data = entity:GetData()
            data.persistent = register[i].data
            data._index = register[i].index
        end
    end
end

function this._add(entity)
    local registryData = {
        type = entity.Type,
        variant = entity.Variant,
        x = entity.Position.X,
        y = entity.Position.Y,
        room = game:GetLevel():GetCurrentRoomIndex()
    }

    local data = entity:GetData()
    registryData.data = data.persistent
    registryData.index = data._index or math.random(-10000, 10000)

    -- print('npcPersistence: Assigned ID '..tostring(registryData.index)..' to obj with type '..entity.Type)
    table.insert(register, registryData)

    this._save()
    
    return registryData.index
end

-- Callbacks --
function this.onNewRoom()
    restore()
    this._save()
end

function this.onNewLevel()
    register = {}
    this._save()  
end

return this