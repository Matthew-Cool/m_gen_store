-- robbery fail hooks 
hook.Add("PlayerDeath", "Gen_Store_Robber_Killed", function(Killed, Item, Killer)
	for k, v in pairs(ents.FindByClass("gen_store_npc")) do 
		if v.info.Robber == Killed then
			v:StopGenRobbery(v.info.Robber, GEN_STORE_LANG.robstorekilled, 0)
			if GEN_STORE.Settings.Robbery[10] > 0 and Killer:isCP() then
				Killer:addMoney(GEN_STORE.Settings.Robbery[10])
				DarkRP.notify(Killer, 0, 7, GEN_STORE_LANG.robstorekilledgov .. DarkRP.formatMoney(GEN_STORE.Settings.Robbery[10]))
			end
			break
		end
	end
end)

hook.Add("PlayerDisconnected", "Gen_Store_Robber_Disconnected", function(Disconnector)
	for k, v in pairs(ents.FindByClass("gen_store_npc")) do
		if v.info.Robber == Disconnector then 
			v:StopGenRobbery(v.info.Robber, GEN_STORE_LANG.robstoredc, 1)
			break
		end
	end
end)

hook.Add("OnPlayerChangedTeam", "Gen_Store_Robber_Changed_Job", function(Player)
	for k, v in pairs(ents.FindByClass("gen_store_npc")) do
		if v.info.Robber == Player then
			v:StopGenRobbery(v.info.Robber, GEN_STORE_LANG.robstorejobchange, 1)
			break
		end
	end
end)