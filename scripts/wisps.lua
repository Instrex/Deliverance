local this = {
    appleId = deliveranceContent.items.theApple.id,
    airStrikeId = deliveranceContent.items.airStrike.id
}

--using for test purpose
function this:wispsCheck(familiar)
    if familiar.SubType == this.airStrikeId then
        print("hello")
    end
end

function this:wispsDeath(ent)
    if ent.Variant == FamiliarVariant.WISP then
        print("death")
    end
end


function this.Init()
    mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT,this.wispsCheck, FamiliarVariant.WISP)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH,this.wispsDeath, EntityType.ENTITY_FAMILIAR)
end
return this