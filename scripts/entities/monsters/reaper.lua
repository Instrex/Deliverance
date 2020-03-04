local this = {
    id = Isaac.GetEntityTypeByName("Reaper"),
    variant = Isaac.GetEntityVariantByName("Reaper")
}

local function getTimerLength()
    return math.random(90, 260)
end

local function getTarget()
    return Vector.FromAngle(math.random(360))
end

function this:behaviour(npc) -- MC_NPC_UPDATE (this.id)
    if npc.Variant ~= this.variant then return end -- vibe check

    local data, sprite, target = npc:GetData() or {}, npc:GetSprite(), npc:GetPlayerTarget()

    -- AI
    if npc.State == NpcState.STATE_INIT then 
        npc.State = NpcState.STATE_IDLE
        data.shootOffset = math.random(180, 400)
    
    elseif npc.State == NpcState.STATE_IDLE then
        sprite:Play("Idle")
        if not target:IsDead() then
            npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 4.5 
        end

        if npc.StateFrame < data.shootOffset then
            npc.StateFrame = npc.StateFrame + 1
        
        else npc.State = NpcState.STATE_ATTACK end

    elseif npc.State == NpcState.STATE_ATTACK then 
        sprite:Play("Spawn")

        npc.Velocity = npc.Velocity * 0.96
        if sprite:IsEventTriggered("Spawn") then 
            Isaac.Spawn(66, 10, 0, npc.Position, utils.vecToPos(target.Position, npc.Position) * 50, nil)
        end

        if sprite:IsFinished("Spawn") then
            npc.State = NpcState.STATE_INIT
            npc.StateFrame = 0
        end
    end
end

function this:die(npc)
    if npc.Variant ~= this.variant then return end
    Isaac.Spawn(212, 0, 0, npc.Position - Vector(0, 25), npc.Velocity, npc)
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this