local this = {
    id = Isaac.GetEntityTypeByName("Reaper"),
    variant = Isaac.GetEntityVariantByName("Reaper"),
	effect = Isaac.GetEntityVariantByName("Reaper Cape")
}
function this:updateEffect(npc)
 if npc.Variant == this.effect then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    sprite:Play("Extra")
    
    if sprite:IsFinished("Extra") then 
      npc:Remove()
    end
  end
end

function this:behaviour(npc) -- MC_NPC_UPDATE (this.id)
    if npc.Variant ~= this.variant then return end -- vibe check

    local data, sprite, target, room = npc:GetData() or {}, npc:GetSprite(), npc:GetPlayerTarget(), game:GetRoom()
    if data.RealHp == nil then data.RealHp = npc.HitPoints end
    if data.dead == nil then data.dead = false end
    if data.teleportDelay == nil then data.teleportDelay = 30 end
    if data.teleportDelay > 0 then
        data.teleportDelay = data.teleportDelay - 1
    end
    if data.dead then
            npc.State = NpcState.STATE_UNIQUE_DEATH;
            npc.Velocity = vectorZero
            sprite:Play("Death");
            if sprite:IsFinished("Death") then
				local cape = Isaac.Spawn(1000, this.effect, 0, npc.Position, vectorZero, nil)
                npc:Kill()
            end
        end

    -- AI
    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_MOVE
    
    elseif npc.State == NpcState.STATE_MOVE then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        if data.shootOffset == nil then data.shootOffset = 0 end
        data.shootOffset = math.random(180, 400)
        if data.degree == nil then data.degree = 0 end
        data.degree = Utils.choose(45, 135, 225, 315)

        if npc.StateFrame < data.shootOffset then
            npc.StateFrame = npc.StateFrame + 1
        
        else npc.State = NpcState.STATE_ATTACK end

    elseif npc.State == NpcState.STATE_ATTACK then 
        sprite:Play("Spawn")

        npc.Velocity = npc.Velocity * 0.96
        if sprite:IsEventTriggered("Spawn") then 
            npc.StateFrame = 0
            sfx:Play(104, 1.5, 0, false, 1)
            local thing = Isaac.Spawn(66, 10, 0, npc.Position, utils.vecToPos(target.Position, npc.Position) * 13, nil)
            sfx:Play(265, 0.9, 0, false, 1)
            thing.Parent = thing
        end

        if sprite:IsFinished("Spawn") then
            npc.State = NpcState.STATE_INIT
        end
    elseif npc.State == 400 then
        npc.StateFrame = npc.StateFrame + 1
        sprite:Play("TeleportStart")
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        if sprite:IsEventTriggered("TeleportStart") then
            sfx:Play(215, 1,0, false, 1)
        end
        if sprite:IsPlaying("TeleportStart") then
            npc.Velocity = Vector.FromAngle(data.degree):Resized(5)
        end
        if sprite:IsFinished("TeleportStart") then
            npc.Position = room:FindFreePickupSpawnPosition((target.Position+Vector(Utils.choose(-150, 150),Utils.choose(-150, 150))), 75, true)
            npc.State = 401
        end
    elseif npc.State == 401 then
        sprite:Play("TeleportEnd")
        if sprite:IsEventTriggered("TeleportEnd") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            sfx:Play(214, 1,0, false, 1)
        end
        if sprite:IsFinished("TeleportEnd") then
            npc.State = NpcState.STATE_MOVE
        end
    end
end

function this:onHitNPC(npc, dmgAmount, flags, source, frames)
 if npc.Variant == this.variant then
    local data = npc:GetData()
    if npc:ToNPC().State ~= NpcState.STATE_ATTACK and data.teleportDelay == 0 then
        npc:ToNPC().State = 400
        data.teleportDelay = 60
    end
  if npc.Type == this.id then
    if data.RealHp == nil then
      data.RealHp = npc.HitPoints
    end
    data.RealHp = data.RealHp - dmgAmount
    if data.RealHp <= 0 and not data.dead then
       data.dead=true
       npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
       return false
    end
  end
 end
end

function this:die(npc)
    if npc.Variant ~= this.variant then return end
    local target = npc:GetPlayerTarget()
    local dhVel = (target.Position - npc.Position):Resized(15)
    local length = dhVel:Length()
    local dh = Isaac.Spawn(212, 0, 0, npc.Position - Vector(0, 25), dhVel, npc):ToNPC()
    dh.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    local sprite = dh:GetSprite()
    sprite:Play("Idle", true)
    sprite:Update()
    dh.State = 400
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateEffect)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC,this.id)
end

return this