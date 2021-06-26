local this = {}
this.id = Isaac.GetTrinketIdByName("Krampus Horn")
this.description = "Chance to teleport to the Devil Room when taking damage"
this.rusdescription ={"Krampus Horn /��� ��������", "���� ����������������� � ������� ������� ��� ��������� �����"}
function this.trigger(id,dmgAmount,flags,source,frames)
  local player = Isaac.GetPlayer(0)
  if player:HasTrinket(this.id) then
    if utils.chancep(6) and flags ~= DamageFlag.DAMAGE_NO_PENALTIES then
      local level = game:GetLevel()
      game:StartRoomTransition(level:QueryRoomTypeIndex(RoomType.ROOM_DEVIL, true, RNG()), Direction.NO_DIRECTION, "3") --�������� �� ������ ������� ����� �� ���� ���������� ������
      --player:AnimateTeleport(true)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
end

return this
