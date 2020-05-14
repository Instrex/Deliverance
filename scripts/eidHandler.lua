local this = {}

function this.init()
    __eidItemDescriptions = __eidItemDescriptions or {}
    __eidTrinketDescriptions = __eidTrinketDescriptions or {}
    __eidCardDescriptions = __eidCardDescriptions or {}
    __eidPillDescriptions = __eidPillDescriptions or {}
    __eidRusItemDescriptions = __eidRusItemDescriptions or {}
    __eidRusTrinketDescriptions = __eidRusTrinketDescriptions or {}
    __eidRusCardDescriptions = __eidRusCardDescriptions or {}
    __eidRusPillDescriptions = __eidRusPillDescriptions or {}
end

local function checkTypeName(type)
    if type == 'items' then
        return 'Item'

    elseif type == 'trinkets' then
        return 'Trinket'

    elseif type == 'cards' then 
        return 'Card'
    
    elseif type == 'pills' then
        return 'Pill'
    end

    return false
end

function this.tryAddDescription(type, class)
    if (not class) or (not class.id) or (not class.description) or (not class.rusdescription) then
        return false
    end

    local convType = checkTypeName(type)
    if convType then 
        _G['__eid'..convType..'Descriptions'][class.id] = class.description
        _G['__eidRus'..convType..'Descriptions'][class.id] = class.rusdescription
    end
end

return this