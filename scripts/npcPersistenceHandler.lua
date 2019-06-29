local this = {}
local register = {}

function this.init(classes) 
    this.objects = {}
    for name, class in pairs(classes) do 
        class.Init()
        table.insert(this.objects, {class.id, class.variant})
    end

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.onNewRoom)
end

-- Save & Load --
function this.loadData(data)
    --print('------------- load')
    deliveranceData.temporary.currentStage = Game():GetLevel():GetStage()
    register = data or {}
    this.restore()
end

function this.getSaveData()
    return register
end

function this.clear()
    deliveranceData.temporary.currentStage = nil
    register = {}
end

-- Register management --
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
end

function this.initEntity(entity)
    return this._add(entity)
end

-- Register control --
function this.restore()
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
    
    return registryData.index
end

-- Callbacks --
function this.onNewRoom()
    
    if deliveranceData.temporary.currentStage ~= Game():GetLevel():GetStage() then 
        --print('------------- clear')
        deliveranceData.temporary.currentStage = Game():GetLevel():GetStage()
        register = {}

    else 
        this.restore()
    end
end

return this