local this = {}

if CustomGameOver then -- 
        local EnemyFrames = CustomGameOver.Entity.EnemyFrames
        local BossFrames = CustomGameOver.Entity.BossFrames
        local CustomSprites = CustomGameOver.Entity.CustomSprites
        local Offsets = CustomGameOver.Entity.Offsets
        local GetVariantID = CustomGameOver.Functions.GetVariantID
        local GetSubTypeID = CustomGameOver.Functions.GetSubTypeID
    
        -- This function is used to make sure that definitions set by other mods are not overwritten.
        local function setIfNotExists(tbl, id, val)
            if tbl[id] == nil then
                tbl[id] = val
            end
        end

        -- Raga
        setIfNotExists(CustomSprites, GetVariantID(741,4000), "deliverance/cracker.png") -- Cracker
        -- Jester
        -- Joker
        setIfNotExists(CustomSprites, GetVariantID(744,4000), "deliverance/nutcracker.png") -- Nutcracker
        -- Beamo
        -- Peabody
        -- Peabody X
        -- Peamonger
        -- Rosenberg
        -- Shroomeo
        -- Tinhorn
        -- Musk
        -- Dusk
        setIfNotExists(CustomSprites, GetVariantID(751,4000), "deliverance/fat_host.png") -- Fat Host
        -- Red Fat Host
        setIfNotExists(CustomSprites, GetVariantID(752,4000), "deliverance/gelatino.png") -- Gelatino
        setIfNotExists(CustomSprites, GetVariantID(752,4001), "deliverance/mini_gelatino.png") -- Mini Gelatino
        -- Cadaver 
        -- Wicked Cadaver
        -- Sluggish Cadaver
        setIfNotExists(CustomSprites, GetVariantID(754,4000), "deliverance/eddie.png") -- Eddie
        -- Explosimaw
        -- Seraphim
        -- Fistubomb
        -- Fistulauncher
        -- lvl2.5 Fly
        -- lvl2.5 Spider
        -- Mother Of Many
        -- Pale Mother Of Many
        setIfNotExists(CustomSprites, GetVariantID(762,4000), "deliverance/creampile.png") -- Creampile
        -- Gappy
        -- Reaper
        setIfNotExists(CustomSprites, GetVariantID(765,4000), "deliverance/stonelet.png") -- Stonelet
        -- Grilly
        -- Bloodmind
        -- Slider
end

return this