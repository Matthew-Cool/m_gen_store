-- Spawn/Save/Clear/Event Commands
local function ConCooldownCheck(Player)
	if not Player.Gen_Store_Con_Cooldown then
		Player.Gen_Store_Con_Cooldown = 0
	end

	if Player.Gen_Store_Con_Cooldown > CurTime() then
		DarkRP.notify(Player, 1, 5, GEN_STORE_LANG.conadmindonotspam)
		return true
	else
		Player.Gen_Store_Con_Cooldown = CurTime() + 5
	end
end

concommand.Add("gen_store_save", function(Player)
	if not GEN_STORE.Admins[Player:GetUserGroup()] then
        DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.concannotuse)
        return
    end

	local Cooldown = ConCooldownCheck(Player)

	if Cooldown then 
		return
	end

    if not file.Exists("m_gen_store/gen_store_spawns.txt", "DATA") then
		file.Write("m_gen_store/gen_store_spawns.txt", util.TableToJSON())
    end

	local Amount_Saved = 0
    local Saved_NPCs = {}
    for k, v in pairs(ents.FindByClass("gen_store_npc")) do
        Saved_NPCs[k] = {v:GetPos(), v:GetAngles()}
        file.Write("m_gen_store/gen_store_spawns.txt", util.TableToJSON(Saved_NPCs))
		Amount_Saved = Amount_Saved + 1
    end

	DarkRP.notify(Player, 0, 7, GEN_STORE_LANG.constoresaved .. Amount_Saved)
end)

concommand.Add("gen_store_spawn", function(Player)
	if not GEN_STORE.Admins[Player:GetUserGroup()] then
        DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.concannotuse)
        return
    end

	local Cooldown = ConCooldownCheck(Player)

	if Cooldown then 
		return
	end

	if not file.Exists("m_gen_store/gen_store_spawns.txt", "DATA") then
		DarkRP.notify(Player, 0, 7, GEN_STORE_LANG.conspawnstorefail)
		return
	end

	for k, v in pairs(ents.FindByClass("gen_store_npc")) do 
		if k >= 1 then
			DarkRP.notify(Player, 0, 12, GEN_STORE_LANG.conspawnremoveall)
			return
		end
	end

	local Saved_NPCs = util.JSONToTable(file.Read("m_gen_store/gen_store_spawns.txt", "DATA"))
	for k, v in pairs(Saved_NPCs) do 
		local NPC = ents.Create("gen_store_npc")
		NPC:SetPos(v[1])
		NPC:SetAngles(v[2])
		NPC:Spawn()
    end

	DarkRP.notify(Player, 0, 10, GEN_STORE_LANG.conspawnsuccess)
end)

concommand.Add("gen_store_clear", function(Player) 
	if not GEN_STORE.Admins[Player:GetUserGroup()] then
        DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.concannotuse)
        return
    end

	local Cooldown = ConCooldownCheck(Player)

	if Cooldown then 
		return
	end

	for k, v in pairs(ents.FindByClass("gen_store_npc")) do
		v:Remove()
	end

	DarkRP.notify(Player, 0, 10, GEN_STORE_LANG.conclearsuccess)
end)

concommand.Add("gen_store_event_lock", function(Player)
	if not GEN_STORE.EventAdmins[Player:GetUserGroup()] then
        DarkRP.notify(Player, 1, 7, GEN_STORE_LANG.concannotuse)
        return
    end

	local Cooldown = ConCooldownCheck(Player)

	if Cooldown then 
		return
	end
	
	for k, v in pairs(ents.FindByClass("gen_store_npc")) do
		local x = v.info
		if not x.Event_Lock then
			x.Event_Lock = true
			if x.Being_Robbed then
				v:StopRobbery(x.Robber, GEN_STORE_LANG.robstoreevent, 0)
			end
		else
			x.Event_Lock = false
		end
	end

	DarkRP.notify(Player, 0, 7, GEN_STORE_LANG.coneventdone)
end)