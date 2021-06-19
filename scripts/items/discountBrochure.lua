local this = {}
this.id = Isaac.GetItemIdByName("Discount Brochure")
this.description = "Makes the shop your starting room#\3Will teleport into the random room if location has no shops#Gives 10 coins after moving to the next floor."
this.rusdescription ={"Discount Brochure /��������� �������", "������������� � ������� � ������ ������� �����#������������� � ��������� ������� ���� � ����� ��� ���������#��� 10 ����� ����� �������� �� ��������� ����."}

function this.onNewFloor()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(this.id) then 
        game:ChangeRoom(game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG()))
		player:AddCoins(10)
    end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.onNewFloor)
end

return this
