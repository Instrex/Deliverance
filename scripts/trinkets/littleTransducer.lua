local this = {}
this.id = Isaac.GetTrinketIdByName("Lil Transducer")
this.description = "Charges active item even if room doesn't contain any enemies"
this.rusdescription ={"Lil Transducer /��������� ���������������", "�������� �������� ������� ���� ���� � ������� �� ���� ������"}

function this.onNewRoom()
    for _, player in pairs (Utils.GetPlayers()) do
      if player:HasTrinket(this.id) and player:NeedsCharge() then
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_DEFAULT and room:IsFirstVisit() and room:IsClear() then
          Isaac.Spawn(1000, 48, 0, Vector(player.Position.X, player.Position.Y - 64), vectorZero, nil)
          player:SetActiveCharge(player:GetActiveCharge() + 1)
        end
      end
    end
  end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.onNewRoom)
end

return this