net.Receive("Gen_Store_Start_Purchase", function(L, Player)
	if not Player.Gen_Store_Buy_Cooldown then
		Player.Gen_Store_Buy_Cooldown = 0
	end

	if Player.Gen_Store_Buy_Cooldown > CurTime() then
		DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.notifspam)
		return
	else
		Player.Gen_Store_Buy_Cooldown = CurTime() + 1
	end

	local NPC = net.ReadInt(16)
	for k, v in pairs(ents.FindByClass("gen_store_npc")) do
		if v.info.Index == NPC then
			if Player:GetPos():DistToSqr(v:GetPos()) <= 90000 and not v.info.Being_Robbed and not v.info.Event_Lock then
				break
			else
				return
			end
		end
	end

	local Id = net.ReadInt(8)
	local Items = GEN_STORE.Items
	local Item_Data = Items[Id]
	if not Item_Data then 
		return
	end

	local function FailPurchase()
		DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.notifbuyfail)
	end

	if Item_Data[8] then
		if GEN_STORE.VIP[Player:GetUserGroup()] then
			if not Player:canAfford(Item_Data[7]) then
				FailPurchase()
				return
			end
		else
			FailPurchase()
			return
		end
	elseif GEN_STORE.Settings.Store[2] and GEN_STORE.VIP[Player:GetUserGroup()] then
		if not Player:canAfford(Item_Data[7] * GEN_STORE.Settings.Store[6]) then
			FailPurchase()
			return
		end
	elseif GEN_STORE.Settings.Store[1] and Player:isCP() then
		if not Player:canAfford(Item_Data[7] * GEN_STORE.Settings.Store[5]) then
			FailPurchase()
			return
		end
	else 
		if not Player:canAfford(Item_Data[7]) then
			FailPurchase()
			return
		end
	end

	if Item_Data[4] == "weapon" then
		if not Player:HasWeapon(Item_Data[2]) then
			Player:Give(Item_Data[2])
		else
			FailPurchase()
			return
		end
	elseif Item_Data[4] == "entity" then
		local Item_Entity = ents.Create(Item_Data[2])

		if not Item_Entity:IsValid() then
			DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.notifinvalid)
			return
		end

		local Player_Pos = Player:GetPos()
		Item_Entity:SetPos(Player_Pos + (Player:GetUp() * 100) + (Player:GetRight() * 40))
		Item_Entity:Spawn()
	elseif Item_Data[4] == "health" then
		if Player:Health() >= GEN_STORE.Settings.Store[4] then
			FailPurchase()
			return
		end

		Player:SetHealth(Player:Health() + tonumber(Item_Data[2]))
		if Player:Health() > GEN_STORE.Settings.Store[4] then
			Player:SetHealth(GEN_STORE.Settings.Store[4])
		end
	elseif Item_Data[4] == "armor" then
		if Player:Armor() >= GEN_STORE.Settings.Store[8] then
			FailPurchase()
			return
		end
		
		Player:SetArmor(Player:Armor() + tonumber(Item_Data[2]))
		if Player:Armor() > GEN_STORE.Settings.Store[8] then 
			Player:SetArmor(GEN_STORE.Settings.Store[8])
		end
	else
		FailPurchase()
		return
	end

	if Item_Data[8] then
		Player:addMoney(-Item_Data[7])
	elseif GEN_STORE.Settings.Store[2] and GEN_STORE.VIP[Player:GetUserGroup()] then
		Player:addMoney(-Item_Data[7] * GEN_STORE.Settings.Store[6])
	elseif GEN_STORE.Settings.Store[1] and Player:isCP() then
		Player:addMoney(-Item_Data[7] * GEN_STORE.Settings.Store[5])
	else 
		Player:addMoney(-Item_Data[7])
	end
	
	DarkRP.notify(Player, 0, 7, GEN_STORE_LANG.notifbuycomplete)
end)