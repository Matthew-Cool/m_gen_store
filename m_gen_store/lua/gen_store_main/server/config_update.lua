net.Receive("Gen_Store_Config_Update", function(L, Player)
    if not GEN_STORE.Admins[Player:GetUserGroup()] then
        return
    end

    if not Player.Gen_Store_Config_Change_Cooldown then
		Player.Gen_Store_Config_Change_Cooldown = 0
	end

	if Player.Gen_Store_Config_Change_Cooldown > CurTime() then
		DarkRP.notify(Player, 1, 5, GEN_STORE_LANG.conadmindonotspam)
		return
	else
		Player.Gen_Store_Config_Change_Cooldown = CurTime() + 3
	end

    local Update_Type = net.ReadUInt(4)  

    if Update_Type == 1 then
        local Number = net.ReadDouble()
        local Changer = nil

        local How_To_Change = net.ReadUInt(4)
        if How_To_Change == 1 then
            Changer = net.ReadBool()
        elseif How_To_Change == 2 then
            Changer = net.ReadInt(32)
        else 
            Changer = net.ReadString()
        end

        local Current_Items = GEN_STORE.Items

        if table.IsEmpty(Current_Items) then
            Current_Items[1] = {}
        end
        
        for k, v in ipairs(Current_Items) do
            if How_To_Change == 5 and k == Number then
                table.remove(Current_Items, Number)

                if table.IsEmpty(Current_Items) then
                    Current_Items[1] = {GEN_STORE_LANG.adminconfigitemeditthis, "", "", "", "", "", 0, false}
                end

                file.Write("m_gen_store/gen_store_items.txt", util.TableToJSON(Current_Items))

                net.Start("Gen_Store_Get_Config")
                    net.WriteUInt(0, 4)
                    net.WriteTable(util.JSONToTable(file.Read("m_gen_store/gen_store_items.txt", "DATA")))
                net.Send(Player)

                break
            elseif k == math.Round(Number) then
                local Being_Changed = Current_Items[k]
                local Change = (Number - k) * 100

                table.insert(Being_Changed, Change, Changer)
                table.remove(Being_Changed, Change + 1)

                table.insert(Current_Items, k, Being_Changed)
                table.remove(Current_Items, k + 1)

                file.Write("m_gen_store/gen_store_items.txt", util.TableToJSON(Current_Items))

                break
            elseif Number == -1 then
                Current_Items[table.Count(Current_Items) + 1] = {Changer, "", "", "", "", "", 0, false}

                file.Write("m_gen_store/gen_store_items.txt", util.TableToJSON(Current_Items))

                net.Start("Gen_Store_Get_Config")
                    net.WriteUInt(0, 4)
                    net.WriteTable(util.JSONToTable(file.Read("m_gen_store/gen_store_items.txt", "DATA")))
                net.Send(Player)

                break
            end
        end
    elseif Update_Type == 2 then
        local What_Being_Changed = net.ReadUInt(4)
        local Being_Changed = net.ReadDouble()
        local Changed_To = net.ReadDouble()

        local Whole_Table = nil
        local Table = nil
        local Write = nil
        local Number = 0
        if What_Being_Changed == 1 then
            Whole_Table = GEN_STORE.Items
            Table = Whole_Table
            Write = "items"
            Number = 0
        else
            Whole_Table = util.JSONToTable(file.Read("m_gen_store/gen_store_settings.txt", "DATA"))
            Table = Whole_Table.Category
            Write = "settings"
            Number = 4
        end

        if Being_Changed < Changed_To then
            local Change = Table[Being_Changed]
            table.remove(Table, Being_Changed)
            table.insert(Table, Changed_To, Change)
        elseif Being_Changed > Changed_To then
            table.insert(Table, Changed_To, Table[Being_Changed])
            table.remove(Table, Being_Changed + 1)
        elseif Being_Changed == Changed_To then
            return
        end

        file.Write("m_gen_store/gen_store_" .. Write .. ".txt", util.TableToJSON(Whole_Table))

        local Write_Table = nil
        if Number == 0 then
            Write_Table = util.JSONToTable(file.Read("m_gen_store/gen_store_" .. Write .. ".txt", "DATA"))
        elseif Number == 4 then
            Write_Table = Table
        end

        net.Start("Gen_Store_Get_Config")
            net.WriteUInt(Number, 4)
            net.WriteTable(Write_Table)
        net.Send(Player)
    elseif Update_Type == 5 then
        local Being_Changed = net.ReadUInt(4)
        local Change = nil
        local Settings = util.JSONToTable(file.Read("m_gen_store/gen_store_settings.txt", "DATA"))
        local Table = Settings.Category[Being_Changed]
        local Number = net.ReadUInt(4)

        if Being_Changed > table.Count(Settings.Category) then
            Change = {net.ReadString(), {0,0,0}}
            table.insert(Settings.Category, Being_Changed, Change)
            Number = nil
        end

        if Number == 1 then
            Change = net.ReadString()
        elseif Number == 2 then
            Change = {net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)}
        elseif Number == 3 then
            table.remove(Settings.Category, Being_Changed)

            if table.IsEmpty(Settings.Category) then
                Settings.Category[1] = {GEN_STORE_LANG.adminconfigitemeditthis, {0,0,0}}
            end
        end

        if Number == 1 or Number == 2 then
            table.insert(Table, Number, Change)
            table.remove(Table, Number + 1)
        end

        file.Write("m_gen_store/gen_store_settings.txt", util.TableToJSON(Settings))

        if Number == 3 or Number == nil then
            net.Start("Gen_Store_Get_Config")
                net.WriteUInt(3, 4)
                net.WriteTable(util.JSONToTable(file.Read("m_gen_store/gen_store_settings.txt", "DATA")))
            net.Send(Player)
        end
    elseif Update_Type == 6 then
        net.Start("Gen_Store_Get_Config")
            net.WriteUInt(2, 4)
            net.WriteTable(GEN_STORE.Items)
            net.WriteTable(GEN_STORE.Settings)
        net.Send(Player)
    else
        local Being_Changed = net.ReadDouble()
        local Change = nil
        local Settings = util.JSONToTable(file.Read("m_gen_store/gen_store_settings.txt", "DATA"))

        local Table = nil
        if Update_Type == 3 then
            Table = Settings.Store
            if Being_Changed < 4 then
                local Bool = net.ReadBool()
                Change = Bool
            else
                local Number = net.ReadDouble()
                Change = Number
            end
        else
            Table = Settings.Robbery
            if Being_Changed == 1 or Being_Changed == 4 or Being_Changed == 6 or Being_Changed == 11 then
                local Bool = net.ReadBool()
                Change = Bool
            else
                local Number = net.ReadDouble()
                Change = Number
            end
        end
            
        table.insert(Table, Being_Changed, Change)
        table.remove(Table, Being_Changed + 1)

        file.Write("m_gen_store/gen_store_settings.txt", util.TableToJSON(Settings))
    end

    GEN_STORE:UpdateConfig()

    DarkRP.notify(Player, 0, 4, GEN_STORE_LANG.coneventdone)
end)