AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(GEN_STORE.npcmodel)
    self:SetHullType(HULL_HUMAN) 
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX) 
	self:CapabilitiesAdd(CAP_ANIMATEDFACE) 
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE) 
	self:DropToFloor()


	self.info = {
		Robber = nil,
		Being_Robbed = false,
		Can_Rob = true,
		Event_Lock = false,
		Index = self:EntIndex()
	}
end

function ENT:OnRemove()
	if self.info.Being_Robbed then
		self:StopGenRobbery(self.info.Robber, GEN_STORE_LANG.robstoreremove, 0)
	end
end

function ENT:Use(Activator, Caller)	
	if Caller:IsPlayer() then
		if not Caller.Gen_Store_Use_Cooldown then
			Caller.Gen_Store_Use_Cooldown = 0
		end
	
		if Caller.Gen_Store_Use_Cooldown > CurTime() then
			return
		else
			Caller.Gen_Store_Use_Cooldown = CurTime() + 1
		end
		
		local x = self.info

		if x.Event_Lock then
			net.Start("Gen_Store_Used_Event_Start")
			net.Send(Caller)
			return
		end
		
		if not x.Being_Robbed then
			if not Caller.Gen_Store_Get_Config_Cooldown then
				Caller.Gen_Store_Get_Config_Cooldown = 0
			end
		
			if Caller.Gen_Store_Get_Config_Cooldown < CurTime() then
				net.Start("Gen_Store_Get_Config")
					if not GEN_STORE.Admins[Caller:GetUserGroup()] then
						net.WriteUInt(1, 4)
						
						net.WriteTable(GEN_STORE.Items)

						net.WriteBool(GEN_STORE.Settings.Robbery[1])
						net.WriteDouble(GEN_STORE.Settings.Robbery[2])
						net.WriteBool(GEN_STORE.Settings.Robbery[6])
						
						net.WriteBool(GEN_STORE.Settings.Store[1])
						net.WriteBool(GEN_STORE.Settings.Store[2])
						net.WriteDouble(GEN_STORE.Settings.Store[5])
						net.WriteDouble(GEN_STORE.Settings.Store[6])

						net.WriteTable(GEN_STORE.Settings.Category)
					else
						net.WriteUInt(2, 4)
						net.WriteTable(GEN_STORE.Items)
						net.WriteTable(GEN_STORE.Settings)
					end
				net.Send(Caller)

				Caller.Gen_Store_Get_Config_Cooldown = CurTime() + 300
			end

			local Amount_CP = 0
			local Amount_Being_Robbed = false
			if not timer.Exists("Gen_Store_Rob_Cool_Down" .. x.Index) then
				for k, v in pairs(player.GetAll()) do
					if v:isCP() then
						Amount_CP = Amount_CP + 1

						if Amount_CP >= GEN_STORE.Settings.Robbery[7] then
							break
						end
					end
				end

				if Amount_CP < GEN_STORE.Settings.Robbery[7] then
					x.Can_Rob = false
				else 
					x.Can_Rob = true
				end

				if GEN_STORE.Settings.Robbery[4] then
					for k, v in pairs(ents.FindByClass("gen_store_npc")) do
						if v.info.Being_Robbed then
							Amount_Being_Robbed = true
							break
						end
					end
				end

				if Amount_Being_Robbed then
					x.Can_Rob = false
				end
			end

			net.Start("Gen_Store_Used_Start")
				net.WriteBool(x.Can_Rob)
				net.WriteInt(x.Index, 16)
				if not x.Can_Rob and Amount_CP < GEN_STORE.Settings.Robbery[7] and not timer.Exists("Gen_Store_Rob_Cool_Down" .. x.Index) then
					net.WriteInt(-1, 16)
				elseif not x.Can_Rob and Amount_Being_Robbed and not timer.Exists("Gen_Store_Rob_Cool_Down" .. x.Index) then
					net.WriteInt(-2, 16)
				elseif not x.Can_Rob then
					net.WriteInt(math.Round(timer.TimeLeft("Gen_Store_Rob_Cool_Down" .. x.Index), 0), 16)
				else
					self:SetupGenRobberyNet()
				end
			net.Send(Caller)
		elseif x.Being_Robbed then
			local Rob_Time_Round = math.Round(timer.TimeLeft("Gen_Store_Rob_S_Time" .. x.Index), 0)
			net.Start("Gen_Store_Used_Fail_Rob")
				net.WriteDouble(Rob_Time_Round)
				net.WriteDouble(GEN_STORE.Settings.Robbery[2])
			net.Send(Caller)
		end
	end
end

function ENT:SetupGenRobberyNet()
	net.Receive("Gen_Store_Rob_Start", function(L, Player)
		if not Player.Gen_Store_Rob_Cooldown then
			Player.Gen_Store_Rob_Cooldown = 0
		end
	
		if Player.Gen_Store_Rob_Cooldown > CurTime() then
			return
		else
			Player.Gen_Store_Rob_Cooldown = CurTime() + 5
		end

		local x = self.info

		if not GEN_STORE.Settings.Robbery[1] or not x.Can_Rob or timer.Exists("Gen_Store_Rob_Cool_Down" .. x.Index) then
			return
		end

		x.Robber = Player
		x.Being_Robbed = true

		if GEN_STORE.robsound then
			self:EmitSound("m_gen_store/robbery_alarm_sound.wav")
		end

		if GEN_STORE.Settings.Robbery[11] then
			for k, v in pairs(player.GetAll()) do
				if v:isCP() then
					net.Start("Gen_Store_Gov_Notify")
						net.WriteVector(Vector(self:GetPos()))
						net.WriteDouble(GEN_STORE.Settings.Robbery[12])
						net.WriteDouble(GEN_STORE.Settings.Robbery[13])
					net.Send(v)
				end
			end
		end
	
		timer.Create("Gen_Store_Rob_Distance_Check_Time" .. x.Index, 1, GEN_STORE.Settings.Robbery[2], function()
			if not self:IsValid() then
				timer.Remove("Gen_Store_Rob_Distance_Check_Time" .. x.Index)
				return
			end
			
			if ((x.Robber:GetPos():DistToSqr(self:GetPos())) > ((GEN_STORE.Settings.Robbery[8] - GEN_STORE.Settings.Robbery[9]) *  (GEN_STORE.Settings.Robbery[8] - GEN_STORE.Settings.Robbery[9]))) and not (x.Robber:GetPos():DistToSqr(self:GetPos()) > (GEN_STORE.Settings.Robbery[8] * GEN_STORE.Settings.Robbery[8])) then
				net.Start("Gen_Store_Distance_Warning")
					net.WriteBool(true)
				net.Send(x.Robber)
			else
				net.Start("Gen_Store_Distance_Warning")
					net.WriteBool(false)
				net.Send(x.Robber)
			end

			if (x.Robber:GetPos():DistToSqr(self:GetPos()) > (GEN_STORE.Settings.Robbery[8] * GEN_STORE.Settings.Robbery[8])) then
				self:StopGenRobbery(x.Robber, GEN_STORE_LANG.robstoredist, 0)
			end
		end)
	
		timer.Create("Gen_Store_Rob_S_Time" .. x.Index, GEN_STORE.Settings.Robbery[2], 1, function()
			if not self:IsValid() then
				timer.Remove("Gen_Store_Rob_S_Time" .. x.Index)
				return
			end

			if GEN_STORE.robsound then
				self:StopSound("m_gen_store/robbery_alarm_sound.wav")
			end

			x.Being_Robbed = false
			x.Robber = nil
	
			if GEN_STORE.Settings.Store[3] and GEN_STORE.VIP[Player:GetUserGroup()] then
				Player:addMoney(GEN_STORE.Settings.Robbery[5] + (GEN_STORE.Settings.Robbery[5] * GEN_STORE.Settings.Store[7]))
				DarkRP.notify(Player, 0, 7, GEN_STORE_LANG.robstoresuccess .. DarkRP.formatMoney(GEN_STORE.Settings.Robbery[5] + (GEN_STORE.Settings.Robbery[5] * GEN_STORE.Settings.Store[7])))
			else
				Player:addMoney(GEN_STORE.Settings.Robbery[5])
				DarkRP.notify(Player, 0, 7, GEN_STORE_LANG.robstoresuccess .. DarkRP.formatMoney(GEN_STORE.Settings.Robbery[5]))
			end

			self:GenRobberyCoolDown()
		end)
	end)
end

function ENT:StopGenRobbery(Person, Text, Value)
	local x = self.info
	if Value == 1 then 
		DarkRP.notifyAll(0, 7, Text)
	else
		DarkRP.notify(Person, 0, 7, Text)
	end
	
	self:GenRobberyCoolDown()
		
	if GEN_STORE.robsound then
		self:StopSound("m_gen_store/robbery_alarm_sound.wav")
	end

	timer.Remove("Gen_Store_Rob_Distance_Check_Time" .. x.Index)
	timer.Remove("Gen_Store_Rob_S_Time" .. x.Index)

	if GEN_STORE.Settings.Robbery[6] then
		net.Start("Gen_Store_Rob_Failed")
		net.Send(x.Robber)
	end
	
	x.Being_Robbed = false
	x.Robber = nil
end

function ENT:GenRobberyCoolDown()
	if GEN_STORE.Settings.Robbery[3] <= 0 then
		return
	end
	
	local x = self.info
	x.Can_Rob = false
	timer.Create("Gen_Store_Rob_Cool_Down" .. x.Index, GEN_STORE.Settings.Robbery[3], 1, function()
		if not self:IsValid() then
			timer.Remove("Gen_Store_Rob_Cool_Down" .. x.Index)
			return
		end
		
		x.Can_Rob = true
	end)
end