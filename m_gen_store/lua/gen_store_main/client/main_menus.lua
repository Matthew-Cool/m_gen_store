----------------------------------------------------------------------------------------------------------------------------------------------
-- Admin Config Menu
local function ConfigOpen()
    if GEN_STORE.ConfigMenu == nil or not GEN_STORE.ConfigMenu:IsValid() then
        local Player = LocalPlayer()
        local Scr_W, Scr_H = ScrW(), ScrH()
        GEN_STORE.ConfigMenu = vgui.Create("DFrame")
        GEN_STORE.ConfigMenu:SetSize(Scr_W * .6, Scr_H * .5)
        GEN_STORE.ConfigMenu:Center()
        local Gen_Store_Config_Menu_H = GEN_STORE.ConfigMenu:GetTall()
        local Gen_Store_Config_Menu_W = GEN_STORE.ConfigMenu:GetWide()
        local Gen_Store_Config_Menu_Y = GEN_STORE.ConfigMenu:GetTall() * .01
        GEN_STORE.ConfigMenu:SetDraggable(true)
        GEN_STORE.ConfigMenu:SetTitle("")
        GEN_STORE.ConfigMenu:MakePopup(true)
        GEN_STORE.ConfigMenu:SetMouseInputEnabled(true)
        GEN_STORE.ConfigMenu:ShowCloseButton(false)
        GEN_STORE.ConfigMenu.Paint = function(Me, Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor)
            draw.RoundedBox(GEN_STORE.roundboxamount, Width * .13, Height * .05, 2, Height * .95, GEN_STORE.separatorcolor)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .05, GEN_STORE.maintopbarcolor, true, true, false, false)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, Height * .05, Width, 2, GEN_STORE.separatorcolor, true, true, false, false)
            draw.SimpleText(GEN_STORE_LANG.adminconfigmenu, "gen_store_text_1", Width / 2, Height * .025, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local Close_Buttonn_Config_WH = Gen_Store_Config_Menu_H * .044
        local Close_Button_Config = vgui.Create("DImageButton", GEN_STORE.ConfigMenu)
        Close_Button_Config:SetSize(Close_Buttonn_Config_WH, Close_Buttonn_Config_WH)
        Close_Button_Config:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
        Close_Button_Config:SetPos(Gen_Store_Config_Menu_W - Close_Buttonn_Config_WH - (Gen_Store_Config_Menu_Y / 4), Gen_Store_Config_Menu_Y / 2) 

        Close_Button_Config.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            GEN_STORE.ConfigMenu:MoveTo(Scr_W / 2 - (Gen_Store_Config_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                GEN_STORE.ConfigMenu:Close()
            end)

            -- to update the rest of the config settings for admin that don't update after applying (robbery/store settings)
            net.Start("Gen_Store_Config_Update")
                net.WriteUInt(6, 4)
            net.SendToServer()
        end

        local Config_Menu_Nav = vgui.Create("DPanel", GEN_STORE.ConfigMenu)
        Config_Menu_Nav:SetSize(Gen_Store_Config_Menu_W * .13, Gen_Store_Config_Menu_H * .95 - 2)
        Config_Menu_Nav:SetPos(0, Gen_Store_Config_Menu_H * .05 + 2)
        Config_Menu_Nav.Paint = function(Me, Width, Height)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.navbarmaincolor, false, false, true, false)
        end

        local Nav_Bar_Selection = GEN_STORE_LANG.adminconfigmenunav[1]
        local Selection_Color = Color(0,128,227)
        for k, v in ipairs(GEN_STORE_LANG.adminconfigmenunav) do 
            local Nav_Button = vgui.Create("DButton", Config_Menu_Nav)
            Nav_Button:DockMargin(0, 0, 0, Gen_Store_Config_Menu_Y)
            Nav_Button:Dock(TOP)
            Nav_Button:SetText("")
            Nav_Button:SetTall(Gen_Store_Config_Menu_H * .08)
            Nav_Button.Paint = function(Me, Width, Height)
                if Nav_Bar_Selection == v then
                    draw.RoundedBoxEx(GEN_STORE.roundboxamount, Width * .98, 0, Height, Height, Selection_Color, true, false, true, false)
                    draw.SimpleText(v, "gen_store_text_1", Width / 2, Height / 2, Selection_Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(v, "gen_store_text_1", Width / 2, Height / 2, GEN_STORE.navbartextunselec, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            Nav_Button.DoClick = function()
                Nav_Bar_Selection = v
                GEN_STORE:ConfigSettings(v)
            end
        end

        local Selection_Panel = vgui.Create("DPanel", GEN_STORE.ConfigMenu)
        Selection_Panel:SetSize(Gen_Store_Config_Menu_W * .85, Gen_Store_Config_Menu_H * .93 - 2)
        Selection_Panel:SetPos(Gen_Store_Config_Menu_W * .14 + 2, Gen_Store_Config_Menu_H * .06 + 2)
        Selection_Panel.Paint = function(Me, Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.inspectmenubackcolor)
        end
        local Selection_Panel_W = Selection_Panel:GetWide()
        local Selection_Panel_H = Selection_Panel:GetTall()

        local Items_Selection = vgui.Create("DComboBox", GEN_STORE.ConfigMenu)
        Items_Selection:SetSize(Gen_Store_Config_Menu_W * .175, Gen_Store_Config_Menu_H * .05)
        Items_Selection:SetPos(Gen_Store_Config_Menu_W * .14 + 8, Gen_Store_Config_Menu_H * .06 + 8)
        
        local function Reset()
            Items_Selection:Clear()
            Items_Selection:SetValue(GEN_STORE_LANG.adminconfigmenuselect)
            Selection_Panel:Clear()
        end

        function GEN_STORE:ConfigSettings(Selection)
            if Selection == GEN_STORE_LANG.adminconfigmenunav[1] then
                Reset()

                Items_Selection:SetSortItems(true)

                local Current_Items = GEN_STORE.Items

                for k, v in ipairs(Current_Items) do
                    Items_Selection:AddChoice(v[1])

                    Items_Selection.OnSelect = function(Self, Index, Value)
                        Selection_Panel:Clear()

                        local Selected = Current_Items[Index]
                        local New = false
                        if table.Count(Current_Items) + 1 == Index then
                            Selected = {GEN_STORE_LANG.adminconfigitemaddnewhint}
                            New = true
                        end

                        if not New then
                            local Sort_Order = vgui.Create("DComboBox", Selection_Panel)
                            Sort_Order:SetSize(Gen_Store_Config_Menu_W * .175, Gen_Store_Config_Menu_H * .05)
                            Sort_Order:SetPos(6, Selection_Panel_H * .2)
                            Sort_Order:SetValue(GEN_STORE_LANG.adminconfigitemsortorder .. Index)

                            for k2, v2 in ipairs(table.GetKeys(Current_Items)) do
                                Sort_Order:AddChoice(k2)
                            end

                            Sort_Order.OnSelect = function(Self2, Index2, Value2)
                                net.Start("Gen_Store_Config_Update")
                                    net.WriteUInt(2, 4)
                                    net.WriteUInt(1, 4)
                                    net.WriteDouble(Index)
                                    net.WriteDouble(Index2)
                                net.SendToServer()

                                timer.Simple(.5, function()
                                    GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[1])
                                end)
                            end
                        end

                        local Hint = vgui.Create("DLabel", Selection_Panel)
                        Hint:SetSize(Selection_Panel_W * .8, Selection_Panel_H * .15)
                        Hint:SetPos(8, Selection_Panel_H * .4)
                        Hint:SetText("")
                        Hint.Paint = function(Me, Width, Height)
                            draw.SimpleText(GEN_STORE_LANG.adminconfigitemhints[1], "gen_store_text_2", 8, Height * .1, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            draw.SimpleText(GEN_STORE_LANG.adminconfigitemhints[2], "gen_store_text_2", 8, Height * .5, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            draw.SimpleText(GEN_STORE_LANG.adminconfigitemhints[3], "gen_store_text_2", 8, Height * .9, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end
                        
                        for k2, v2 in ipairs(Selected) do
                            local Change = nil
                            local Selected_Panel = vgui.Create("DPanel", Selection_Panel)
                            Selected_Panel:DockMargin(Gen_Store_Config_Menu_W * .6, Gen_Store_Config_Menu_H * .01, 8, 0)
                            Selected_Panel:Dock(TOP)
                            Selected_Panel:SetTall(Selection_Panel_H * .11)
                            Selected_Panel.Paint = function(Me, Width, Height)
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmaincolor)
                                draw.SimpleText(GEN_STORE_LANG.adminconfigitemchangers[k2], "gen_store_text_7", Width * .01, Height * .175, GEN_STORE.itempaneltitletextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end
                            local Selected_Panel_W = Selected_Panel:GetWide()
                            local Selected_Panel_H = Selected_Panel:GetTall()

                            if k2 == 5 or k2 == 4 then
                                local Select_Category = vgui.Create("DComboBox", Selected_Panel)
                                Select_Category:DockMargin(1, 0, 1, 1)
                                Select_Category:Dock(BOTTOM)
                                Select_Category:SetValue(v2)

                                if k2 == 5 then
                                    for k3, v3 in ipairs(GEN_STORE.Settings.Category) do
                                        Select_Category:AddChoice(v3[1])
                                    end
                                elseif k2 == 4 then
                                    for k3, v3 in ipairs(GEN_STORE_LANG.adminconfigtypes) do
                                        Select_Category:AddChoice(v3)
                                    end
                                    Select_Category:SetSortItems(false)
                                end

                                local Types = {"weapon", "entity", "health", "armor"}
                                Select_Category.OnSelect = function(Self, Index, Value)
                                    if k2 == 4 then
                                        Change = Types[Index]
                                    else
                                        Change = Value
                                    end
                                end
                            elseif not isbool(v2) then
                                local Text_Entry = vgui.Create("DTextEntry", Selected_Panel)
                                Text_Entry:DockMargin(1, 0, 1, 1)
                                Text_Entry:Dock(BOTTOM)
                                Text_Entry:SetValue(v2)
                                Text_Entry:SetUpdateOnType(true)
                                Text_Entry.OnValueChange = function(Self, String)
                                    Change = String
                                    if k2 == 7 then
                                        Change = tonumber(Change)
                                    end
                                end
                            else
                                local Check_Box = vgui.Create("DCheckBox", Selected_Panel)
                                Check_Box:SetSize(Selected_Panel_H * .4, Selected_Panel_H * .4)
                                Check_Box:SetPos(1, Selected_Panel_H - Check_Box:GetTall() - 1)
                                Check_Box:SetValue(v2)
                                Check_Box.OnChange = function(Self, Bool)
                                    Change = Bool
                                end
                            end

                            if not New then
                                local Remove_Item = vgui.Create("DButton", Selection_Panel)
                                Remove_Item:SetSize(Selection_Panel_W * .2, Selection_Panel_H * .05)
                                Remove_Item:SetPos(8, Selection_Panel_H * .95 - 8)
                                Remove_Item:SetText("")
                                Remove_Item.Paint = function(Me, Width, Height)
                                    if Me:IsHovered() then
                                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifcancelhovercolor)
                                    else
                                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifcancelcolor)
                                    end
                                    draw.SimpleText(GEN_STORE_LANG.adminconfigmenuremove, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                                end

                                Remove_Item.DoClick = function()
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(1, 4)
                                        net.WriteDouble(Index)
                                        net.WriteUInt(5, 4)
                                    net.SendToServer()

                                    timer.Simple(.5, function()
                                        GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[1])
                                    end)
                                end
                            end

                            local Apply_Change = vgui.Create("DButton", Selected_Panel)
                            Apply_Change:SetSize(Selected_Panel_W * 1.875, Selected_Panel_H * .4)
                            Apply_Change:SetPos(Selected_Panel_W * 2.475, 2)
                            Apply_Change:SetText("")
                            Apply_Change.Paint = function(Me, Width, Height)
                                if Me:IsHovered() then
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondhovercolor)
                                else
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondcolor)
                                end
                                draw.SimpleText(GEN_STORE_LANG.admincofigmenuapply, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end

                            Apply_Change.DoClick = function()
                                if Change == nil then
                                    -- to not break
                                    return
                                else
                                    local Double = Index + (k2 / 100)
                                    if not k2 == 7 or not k2 == 8 then
                                        tostring(Change)
                                    end
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(1, 4)
                                        if New then
                                            net.WriteDouble(-1)
                                            net.WriteUInt(4, 4)
                                            net.WriteString(Change)
                                            timer.Simple(.5, function()
                                                GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[1])
                                            end)
                                        elseif isbool(Change) then
                                            net.WriteDouble(Double)
                                            net.WriteUInt(1, 4)
                                            net.WriteBool(Change)
                                        elseif isnumber(Change) then
                                            net.WriteDouble(Double)
                                            net.WriteUInt(2, 4)
                                            net.WriteInt(Change, 32)
                                        else
                                            net.WriteDouble(Double)
                                            net.WriteUInt(3, 4)
                                            net.WriteString(Change)
                                        end    
                                    net.SendToServer()
                                end
                            end
                        end
                    end
                end

                Items_Selection:AddChoice(GEN_STORE_LANG.adminconfigitemaddnew)

            elseif Selection == GEN_STORE_LANG.adminconfigmenunav[2] then
                Reset()

                local Store_Settings = GEN_STORE.Settings.Store

                for k, v in ipairs(GEN_STORE_LANG.adminconfigstoreitems) do
                    Items_Selection:AddChoice(v)
                end

                Items_Selection:SetSortItems(false)
                Items_Selection.OnSelect = function(Self, Index, Value)
                    Selection_Panel:Clear()
                    
                    local Hint = vgui.Create("DLabel", Selection_Panel)
                    Hint:SetSize(Selection_Panel_W * .8, Selection_Panel_H * .15)
                    Hint:SetPos(8, Selection_Panel_H * .4)
                    Hint:SetText("")
                    Hint.Paint = function(Me, Width, Height)
                        draw.SimpleText(GEN_STORE_LANG.adminconfigstorehints[1], "gen_store_text_2", 8, Height * .1, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(GEN_STORE_LANG.adminconfigstorehints[2], "gen_store_text_2", 8, Height * .5, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(GEN_STORE_LANG.adminconfigstorehints[3], "gen_store_text_2", 8, Height * .9, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    
                    for k, v in ipairs(Store_Settings) do
                        if k == Index or k == Index + 4 then
                            local Change = nil
                            local Selected_Panel = vgui.Create("DPanel", Selection_Panel)
                            Selected_Panel:DockMargin(Gen_Store_Config_Menu_W * .6, Gen_Store_Config_Menu_H * .15, 8, 0)
                            Selected_Panel:Dock(TOP)
                            Selected_Panel:SetTall(Selection_Panel_H * .2)
                            Selected_Panel.Paint = function(Me, Width, Height)
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmaincolor)
                                draw.SimpleText(GEN_STORE_LANG.adminconfigstorechangers[k], "gen_store_text_7", Width * .01, Height * .125, GEN_STORE.itempaneltitletextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end
                            local Selected_Panel_W = Selected_Panel:GetWide()
                            local Selected_Panel_H = Selected_Panel:GetTall()

                            if isbool(v) then
                                local Check_Box = vgui.Create("DCheckBox", Selected_Panel)
                                Check_Box:SetSize(Selected_Panel_H * .25, Selected_Panel_H * .25)
                                Check_Box:SetPos(1, Selected_Panel_H - Check_Box:GetTall() - 1)
                                Check_Box:SetValue(v)
                                Check_Box.OnChange = function(Self, Bool)
                                    Change = Bool
                                end
                            elseif k == 4 or k == 8 then
                                local Text_Entry = vgui.Create("DTextEntry", Selected_Panel)
                                Text_Entry:DockMargin(1, 0, 1, 1)
                                Text_Entry:Dock(BOTTOM)
                                Text_Entry:SetValue(v)
                                Text_Entry:SetUpdateOnType(true)
                                Text_Entry.OnValueChange = function(Self, String)
                                    Change = tonumber(String)
                                end
                            else
                                local Slider = vgui.Create("DNumSlider", Selected_Panel)
                                Slider:DockMargin(-Slider:GetWide() * 2.2, 0, 1, 1)
                                Slider:Dock(BOTTOM)
                                Slider:SetMinMax(0, 1)
                                Slider:SetDecimals(2)
                                Slider:SetValue(v)
                                Slider:SetDark(false)
                                Slider.OnValueChanged = function(Self, Number)
                                    Change = Number
                                end
                            end

                            local Apply_Change = vgui.Create("DButton", Selected_Panel)
                            Apply_Change:SetSize(Selected_Panel_W * 1.875, Selected_Panel_H * .22)
                            Apply_Change:SetPos(4, Selected_Panel_H * .39)
                            Apply_Change:SetText("")
                            Apply_Change.Paint = function(Me, Width, Height)
                                if Me:IsHovered() then
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondhovercolor)
                                else
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondcolor)
                                end
                                draw.SimpleText(GEN_STORE_LANG.admincofigmenuapply, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end

                            Apply_Change.DoClick = function()
                                if Change == nil then
                                    -- to not break
                                    return
                                else
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(3, 4)
                                        net.WriteDouble(k)
                                        if isbool(v) then
                                            net.WriteBool(Change)
                                        elseif isnumber(v) then
                                            net.WriteDouble(Change)
                                        end
                                    net.SendToServer()
                                end
                            end
                        end
                    end
                end

            elseif Selection == GEN_STORE_LANG.adminconfigmenunav[3] then
                Reset()

                local Robbery_Settings = GEN_STORE.Settings.Robbery

                for k, v in ipairs(GEN_STORE_LANG.adminconfigrobchangers) do
                    Items_Selection:AddChoice(v)
                end

                Items_Selection:SetSortItems(false)
                Items_Selection.OnSelect = function(Self, Index, Value)
                    Selection_Panel:Clear()

                    local Hint = vgui.Create("DLabel", Selection_Panel)
                    Hint:SetSize(Selection_Panel_W * .8, Selection_Panel_H * .15)
                    Hint:SetPos(8, Selection_Panel_H * .4)
                    Hint:SetText("")
                    Hint.Paint = function(Me, Width, Height)
                        draw.SimpleText(GEN_STORE_LANG.adminconfigrobhints[1], "gen_store_text_2", 8, Height * .25, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(GEN_STORE_LANG.adminconfigrobhints[2], "gen_store_text_2", 8, Height * .75, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end

                    for k, v in ipairs(Robbery_Settings) do 
                        if k == Index then
                            local Change = nil
                            local Selected_Panel = vgui.Create("DPanel", Selection_Panel)
                            Selected_Panel:DockMargin(Gen_Store_Config_Menu_W * .6, Gen_Store_Config_Menu_H * .35, 8, 0)
                            Selected_Panel:Dock(TOP)
                            Selected_Panel:SetTall(Selection_Panel_H * .2)
                            Selected_Panel.Paint = function(Me, Width, Height)
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmaincolor)
                                draw.SimpleText(GEN_STORE_LANG.adminconfigrobchangers[k], "gen_store_text_7", Width * .01, Height * .125, GEN_STORE.itempaneltitletextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end
                            local Selected_Panel_W = Selected_Panel:GetWide()
                            local Selected_Panel_H = Selected_Panel:GetTall()

                            if isbool(v) then
                                local Check_Box = vgui.Create("DCheckBox", Selected_Panel)
                                Check_Box:SetSize(Selected_Panel_H * .25, Selected_Panel_H * .25)
                                Check_Box:SetPos(1, Selected_Panel_H - Check_Box:GetTall() - 1)
                                Check_Box:SetValue(v)
                                Check_Box.OnChange = function(Self, Bool)
                                    Change = Bool
                                end
                            else
                                local Text_Entry = vgui.Create("DTextEntry", Selected_Panel)
                                Text_Entry:DockMargin(1, 0, 1, 1)
                                Text_Entry:Dock(BOTTOM)
                                Text_Entry:SetValue(v)
                                Text_Entry:SetUpdateOnType(true)
                                Text_Entry.OnValueChange = function(Self, String)
                                    Change = tonumber(String)
                                end
                            end

                            local Apply_Change = vgui.Create("DButton", Selected_Panel)
                            Apply_Change:SetSize(Selected_Panel_W * 1.875, Selected_Panel_H * .22)
                            Apply_Change:SetPos(4, Selected_Panel_H * .39)
                            Apply_Change:SetText("")
                            Apply_Change.Paint = function(Me, Width, Height)
                                if Me:IsHovered() then
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondhovercolor)
                                else
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondcolor)
                                end
                                draw.SimpleText(GEN_STORE_LANG.admincofigmenuapply, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end

                            Apply_Change.DoClick = function()
                                if Change == nil then
                                    -- to not break
                                    return
                                else
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(4, 4)
                                        net.WriteDouble(k)
                                        if isbool(v) then
                                            net.WriteBool(Change)
                                        elseif isnumber(v) then
                                            net.WriteDouble(Change)
                                        end
                                    net.SendToServer()
                                end
                            end
                        end
                    end
                end
            elseif Selection == GEN_STORE_LANG.adminconfigmenunav[4] then
                Reset()

                local Category_Settings = GEN_STORE.Settings.Category

                Items_Selection:SetSortItems(true)
                for k, v in ipairs(Category_Settings) do
                    Items_Selection:AddChoice(v[1])

                    Items_Selection.OnSelect = function(Self, Index, Value)
                        Selection_Panel:Clear()

                        local Selected = Category_Settings[Index]
                        local New = false
                        if table.Count(Category_Settings) + 1 == Index then
                            Selected = {GEN_STORE_LANG.adminconfigitemaddnewhint}
                            New = true
                        end

                        local Hint = vgui.Create("DLabel", Selection_Panel)
                        Hint:SetSize(Selection_Panel_W * .8, Selection_Panel_H * .15)
                        Hint:SetPos(8, Selection_Panel_H * .4)
                        Hint:SetText("")
                        Hint.Paint = function(Me, Width, Height)
                            draw.SimpleText(GEN_STORE_LANG.adminconfigcategoryhint, "gen_store_text_2", 8, Height * .5, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end

                        for k2, v2 in ipairs(Selected) do
                            local Change = nil
                            local Selected_Panel = vgui.Create("DPanel", Selection_Panel)
                            local New = false
                            if table.Count(Category_Settings) + 1 == Index then
                                Selected = {GEN_STORE_LANG.adminconfigitemaddnewhint}
                                New = true
                            end

                            local Dock_Margin = {Gen_Store_Config_Menu_W * .6, 8, 8, 0}
                            if k2 == 2 then
                                Dock_Margin = {Gen_Store_Config_Menu_W * .45, Gen_Store_Config_Menu_H * .1, 8, 0}
                            end

                            Selected_Panel:DockMargin(Dock_Margin[1], Dock_Margin[2], Dock_Margin[3], Dock_Margin[4])
                            Selected_Panel:Dock(TOP)

                            local Height = Selection_Panel_H * .2
                            if k2 == 2 then
                                Height = Selection_Panel_H * .6
                            end

                            Selected_Panel:SetTall(Height)
                            local Text_Height = .125 - ((k2 - 1) * .09)
                            Selected_Panel.Paint = function(Me, Width, Height)
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmaincolor)
                                draw.SimpleText(GEN_STORE_LANG.adminconfigcategorychangers[k2], "gen_store_text_7", Width * .01, Height * Text_Height, GEN_STORE.itempaneltitletextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end
                            local Selected_Panel_W = Selected_Panel:GetWide()
                            local Selected_Panel_H = Selected_Panel:GetTall()

                            if not New then
                                local Remove_Item = vgui.Create("DButton", Selection_Panel)
                                Remove_Item:SetSize(Selection_Panel_W * .2, Selection_Panel_H * .05)
                                Remove_Item:SetPos(8, Selection_Panel_H * .95 - 8)
                                Remove_Item:SetText("")
                                Remove_Item.Paint = function(Me, Width, Height)
                                    if Me:IsHovered() then
                                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifcancelhovercolor)
                                    else
                                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifcancelcolor)
                                    end
                                    draw.SimpleText(GEN_STORE_LANG.adminconfigremovecategory, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                                end

                                Remove_Item.DoClick = function()
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(5, 4)
                                        net.WriteUInt(Index, 4)
                                        net.WriteUInt(3, 4)
                                    net.SendToServer()

                                    timer.Simple(.5, function()
                                        GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[4])
                                    end)
                                end

                                local Sort_Order = vgui.Create("DComboBox", Selection_Panel)
                                Sort_Order:SetSize(Gen_Store_Config_Menu_W * .175, Gen_Store_Config_Menu_H * .05)
                                Sort_Order:SetPos(6, Selection_Panel_H * .2)
                                Sort_Order:SetValue(GEN_STORE_LANG.adminconfigitemsortorder .. Index)

                                for k2, v2 in ipairs(table.GetKeys(Category_Settings)) do
                                    Sort_Order:AddChoice(k2)
                                end

                                Sort_Order.OnSelect = function(Self2, Index2, Value2)
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(2, 4)
                                        net.WriteUInt(2, 4)
                                        net.WriteDouble(Index)
                                        net.WriteDouble(Index2)
                                    net.SendToServer()

                                    timer.Simple(.5, function()
                                        GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[4])
                                    end)
                                end
                            end

                            if k2 == 1 then
                                local Text_Entry = vgui.Create("DTextEntry", Selected_Panel)
                                Text_Entry:DockMargin(1, 0, 1, 1)
                                Text_Entry:Dock(BOTTOM)
                                Text_Entry:SetValue(v2)
                                Text_Entry:SetUpdateOnType(true)
                                Text_Entry.OnValueChange = function(Self, String)
                                    Change = String
                                end
                            else
                                local Color_Mixer = vgui.Create("DColorMixer", Selected_Panel)
                                Color_Mixer:DockMargin(1, 0, 1, 1)
                                Color_Mixer:Dock(BOTTOM)
                                Color_Mixer:SetPalette(true)
                                Color_Mixer:SetAlphaBar(false)
                                Color_Mixer:SetWangs(true)
                                local Set_Color = Color(v2[1], v2[2], v2[3])
                                Color_Mixer:SetColor(Set_Color)
                                Color_Mixer.ValueChanged = function(Self, New_Color)
                                    Change = New_Color
                                end
                            end

                            local Apply_Change = vgui.Create("DButton", Selected_Panel)
                            local Height_Size = .22 - ((k2 - 1) * .14)
                            Apply_Change:SetSize(Selected_Panel_W * 1.875, Selected_Panel_H * Height_Size)
                            local Height_Pos = .39 - ((k2 - 1) * .29)
                            Apply_Change:SetPos(4, Selected_Panel_H * Height_Pos)
                            Apply_Change:SetText("")
                            Apply_Change.Paint = function(Me, Width, Height)
                                if Me:IsHovered() then
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondhovercolor)
                                else
                                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondcolor)
                                end
                                draw.SimpleText(GEN_STORE_LANG.admincofigmenuapply, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end

                            Apply_Change.DoClick = function()
                                if Change == nil then
                                    -- to not break
                                    return
                                else
                                    net.Start("Gen_Store_Config_Update")
                                        net.WriteUInt(5, 4)
                                        net.WriteUInt(Index, 4)
                                        net.WriteUInt(k2, 4)
                                        if k2 == 1 then
                                            net.WriteString(Change)
                                            if New then
                                                timer.Simple(.5, function()
                                                    GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[4])
                                                end)
                                            end
                                        else
                                            net.WriteUInt(Change.r, 8)
                                            net.WriteUInt(Change.g, 8)
                                            net.WriteUInt(Change.b, 8)
                                        end
                                    net.SendToServer()
                                end
                            end
                        end
                    end
                end

                Items_Selection:AddChoice(GEN_STORE_LANG.adminconfigitemaddnew)
            end
        end

        GEN_STORE:ConfigSettings(GEN_STORE_LANG.adminconfigmenunav[1])
    elseif GEN_STORE.ConfigMenu:IsValid() then 
        GEN_STORE.ConfigMenu:Remove()
    end
end



----------------------------------------------------------------------------------------------------------------------------------------------
-- Admin Con Command Menu
local function AdminOpen()
    if GEN_STORE.AdminMenu == nil or not GEN_STORE.AdminMenu:IsValid() then
        local Player = LocalPlayer()
        local Scr_W, Scr_H = ScrW(), ScrH()
        GEN_STORE.AdminMenu = vgui.Create("DFrame")
        GEN_STORE.AdminMenu:SetSize(Scr_W * .3, Scr_H * .25)
        local Gen_Store_Admin_Menu_H = GEN_STORE.AdminMenu:GetTall()
        local Gen_Store_Admin_Menu_W = GEN_STORE.AdminMenu:GetWide()
        local Gen_Store_Admin_Menu_Y = GEN_STORE.AdminMenu:GetTall() * .01
        GEN_STORE.AdminMenu:Center()
        GEN_STORE.AdminMenu:SetDraggable(false)
        GEN_STORE.AdminMenu:SetTitle("")
        GEN_STORE.AdminMenu:MakePopup(true)
        GEN_STORE.AdminMenu:SetMouseInputEnabled(true)
        GEN_STORE.AdminMenu:ShowCloseButton(false)
        GEN_STORE.AdminMenu.Paint = function(Me, Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .1, GEN_STORE.maintopbarcolor, true, true, false, false)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, Height * .1, Width, 2, GEN_STORE.separatorcolor, true, true, false, false)
            draw.SimpleText(GEN_STORE_LANG.adminmenutop, "gen_store_text_1", Width / 2, Height * .05, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(GEN_STORE_LANG.adminmenuhint, "gen_store_text_7", Width / 2, Height * .9, GEN_STORE.adminmenuhinttextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local Close_Buttonn_Admin_WH = Gen_Store_Admin_Menu_H * .085
        local Close_Button_Admin = vgui.Create("DImageButton", GEN_STORE.AdminMenu)
        Close_Button_Admin:SetSize(Close_Buttonn_Admin_WH, Close_Buttonn_Admin_WH)
        Close_Button_Admin:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
        Close_Button_Admin:SetPos(Gen_Store_Admin_Menu_W - Close_Buttonn_Admin_WH - (Gen_Store_Admin_Menu_Y / 2), Gen_Store_Admin_Menu_Y * 1.2) 

        Close_Button_Admin.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            GEN_STORE.AdminMenu:MoveTo(Scr_W / 2 - (Gen_Store_Admin_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                GEN_STORE.AdminMenu:Close()
            end)
        end

        if GEN_STORE.Admins[Player:GetUserGroup()] then
            local Config_Menu_Button = vgui.Create("DButton", GEN_STORE.AdminMenu)
            Config_Menu_Button:SetSize(Gen_Store_Admin_Menu_W * .3, Gen_Store_Admin_Menu_H * .08 + 1)
            Config_Menu_Button:SetPos(Gen_Store_Admin_Menu_Y, Gen_Store_Admin_Menu_Y + 1)
            Config_Menu_Button:SetText("")
            Config_Menu_Button.Paint = function(Me, Width, Height)
                if Me:IsHovered() then
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminbuttonhovercolor)
                else
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminbuttoncolor)
                end
                draw.SimpleText(GEN_STORE_LANG.adminconfigmenu, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.adminbuttontextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            Config_Menu_Button.DoClick = function()
                Player:EmitSound(GEN_STORE.acceptsound)
                GEN_STORE.AdminMenu:Close()

                ConfigOpen()
            end
        end

        for i = 1, 4 do
            local Dock_Top = 0
            if i == 1 then
                Dock_Top = Gen_Store_Admin_Menu_H * .01 + 4
            else
                Dock_Top = Gen_Store_Admin_Menu_H * .03
            end

            local Con_Button = vgui.Create("DButton", GEN_STORE.AdminMenu)
            Con_Button:DockMargin(0, Dock_Top, 0, 0)
            Con_Button:Dock(TOP)
            Con_Button:SetTall(Gen_Store_Admin_Menu_H * .15)
            Con_Button:SetText("")

            local Paint_Text = GEN_STORE_LANG.adminmenuconbutton[i]
            local Hovered_Text = GEN_STORE_LANG.adminmenuconbutton[i + 4]
            local Paint_Hovered_Color = GEN_STORE.adminmenubuttonhovercolor
            if i <= 3 and not GEN_STORE.Admins[Player:GetUserGroup()] then
                Paint_Hovered_Color = GEN_STORE.adminmenubuttoncantusecolor
            elseif i == 4 and not GEN_STORE.EventAdmins[Player:GetUserGroup()] then
                Paint_Hovered_Color = GEN_STORE.adminmenubuttoncantusecolor
            end

            Con_Button.Paint = function(Me, Width, Height)
                if Me:IsHovered() then
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, Paint_Hovered_Color)
                    draw.SimpleText(Hovered_Text, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.adminmenubuttontextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminmenubuttoncolor)
                    draw.SimpleText(Paint_Text, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.adminmenubuttontextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            Con_Button.DoClick = function()
                Player:EmitSound(GEN_STORE.acceptsound)
                GEN_STORE.AdminMenu:MoveTo(Scr_W / 2 - (Gen_Store_Admin_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                    GEN_STORE.AdminMenu:Close()
                end)

                Player:ConCommand(Hovered_Text)
            end
        end
    elseif GEN_STORE.AdminMenu:IsValid() then 
        GEN_STORE.AdminMenu:Remove()
    end
end



----------------------------------------------------------------------------------------------------------------------------------------------
-- Store Menu
local function StoreOpen()
    if GEN_STORE.Menu == nil or not GEN_STORE.Menu:IsValid() then
        local Rob = net.ReadBool()
        local NPC = net.ReadInt(16)
        local Number = net.ReadInt(16)
        
        local Player = LocalPlayer()
        local Player_CP = Player:isCP()
        local Scr_W, Scr_H = ScrW(), ScrH()
        Player:EmitSound(GEN_STORE.welcomesound)
        GEN_STORE.Menu = vgui.Create("DFrame")
        GEN_STORE.Menu:SetSize(Scr_W * .7, Scr_H * .86)
        local Gen_Store_Menu_H = GEN_STORE.Menu:GetTall()
        local Gen_Store_Menu_W = GEN_STORE.Menu:GetWide()
        local Gen_Store_Menu_Y = GEN_STORE.Menu:GetTall() * .01
        GEN_STORE.Menu:SetPos(Scr_W / 2 - (Gen_Store_Menu_W / 2), Scr_H)
        GEN_STORE.Menu:SetDraggable(false)
        GEN_STORE.Menu:SetTitle("")
        GEN_STORE.Menu:MakePopup(true)
        GEN_STORE.Menu:SetMouseInputEnabled(true)
        GEN_STORE.Menu:ShowCloseButton(false)
        GEN_STORE.Menu.Paint = function(Me, Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .035, GEN_STORE.maintopbarcolor, true, true, false, false)
            draw.RoundedBox(GEN_STORE.roundboxamount, Width * .14, Height * .035, 2, Height, GEN_STORE.separatorcolor)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, Height * .035, Width, 2, GEN_STORE.separatorcolor)
            draw.SimpleText(GEN_STORE_LANG.topbar, "gen_store_text_1", Gen_Store_Menu_W / 2, Gen_Store_Menu_H * .018, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        GEN_STORE.Menu:MoveTo(Scr_W / 2 - (Gen_Store_Menu_W / 2), Scr_H / 2 - (Gen_Store_Menu_H / 2), GEN_STORE.animationopentime, 0, -1)

        local Scroll_Bar = vgui.Create("DScrollPanel", GEN_STORE.Menu)
        Scroll_Bar:SetPos(0, Gen_Store_Menu_H * .043)
        Scroll_Bar:SetSize(Gen_Store_Menu_W, Gen_Store_Menu_H * .95)

        local Scroll_Bar_Paint = Scroll_Bar:GetVBar()
        Scroll_Bar_Paint:SetHideButtons(true)
        function Scroll_Bar_Paint.btnGrip:Paint(Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width * .5, Height, GEN_STORE.scrollbarcolor)
        end

        function Scroll_Bar_Paint:Paint(Width, Height) 
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width * .5, Height, GEN_STORE.scrollbarbackcolor)
        end

        local Close_Button_WH = Gen_Store_Menu_H * .026
        local Close_Button = vgui.Create("DImageButton", GEN_STORE.Menu)
        Close_Button:SetSize(Close_Button_WH, Close_Button_WH)
        Close_Button:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
        Close_Button:SetPos(Gen_Store_Menu_W - Close_Button:GetWide() - (Gen_Store_Menu_Y / 2), (Gen_Store_Menu_Y  * 2) * .3) 

        Close_Button.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            GEN_STORE.Menu:MoveTo(Scr_W / 2 - (Gen_Store_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                GEN_STORE.Menu:Close()
            end)
        end   

        local Nav_Bar_Panel = vgui.Create("DPanel", GEN_STORE.Menu)
        Nav_Bar_Panel:SetSize(Gen_Store_Menu_W * .14, Gen_Store_Menu_H * .965)
        Nav_Bar_Panel:SetPos(0, Gen_Store_Menu_H * .035 + 2)
        Nav_Bar_Panel.Paint = function(Me, Width, Height) 
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.navbarmaincolor, false, false, true, false)
        end

        -- small admin menu to enter con commands, nothing really important. (con commands check if player is actually valid and etc :)
        if GEN_STORE.Admins[Player:GetUserGroup()] or GEN_STORE.EventAdmins[Player:GetUserGroup()] then
            local Admin_Button = vgui.Create("DButton", GEN_STORE.Menu)
            Admin_Button:SetSize(Gen_Store_Menu_W * .13, Gen_Store_Menu_H * .026)
            Admin_Button:SetPos(Gen_Store_Menu_W * .006, (Gen_Store_Menu_Y  * 2) * .3)
            Admin_Button:SetText("")
            Admin_Button.Paint = function(Me, Width, Height)
                if Me:IsHovered() then
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminbuttonhovercolor)
                else
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminbuttoncolor)
                end
                draw.SimpleText(GEN_STORE_LANG.adminmenubutton, "gen_store_text_2", Width / 2, Height / 2, GEN_STORE.adminbuttontextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            Admin_Button.DoClick = function()
                Player:EmitSound(GEN_STORE.acceptsound)
                GEN_STORE.Menu:Close()

                AdminOpen()
            end
        end

        if GEN_STORE.Settings.Robbery[1] then
            if not Player_CP and Rob then
                local Rob_Button = vgui.Create("DButton", Nav_Bar_Panel)
                Rob_Button:SetSize(Nav_Bar_Panel:GetWide() * .9, Nav_Bar_Panel:GetTall() * .025)
                Rob_Button:SetPos(Nav_Bar_Panel:GetWide() * .05, Nav_Bar_Panel:GetTall() * .97)
                Rob_Button:SetText("")
                Rob_Button.Paint = function(Me, Width, Height)
                    if Me:IsHovered() then
                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.robbuttonhovercolor)
                    else
                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.robbuttoncolor)
                    end
                    draw.SimpleText(GEN_STORE_LANG.mainmenurob, "gen_store_text_2", Width / 2, Height / 2, GEN_STORE.robbuttontextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                Rob_Button.DoClick = function()
                    net.Start("Gen_Store_Rob_Start")
                    net.SendToServer()
                    GEN_STORE.Menu:SetMouseInputEnabled(false)
                    GEN_STORE.Menu:MoveTo(Scr_W / 2 - (Gen_Store_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                        GEN_STORE.Menu:Close()
                    end)
                    Player:EmitSound(GEN_STORE.acceptsound)

                    if GEN_STORE.Settings.Robbery[6] then
                        if GEN_STORE.Rob_Progress_Ply == nil or not GEN_STORE.Rob_Progress_Ply:IsValid() then
                            GEN_STORE.Rob_Progress_Ply = vgui.Create("DFrame")
                            GEN_STORE.Rob_Progress_Ply:SetSize(Scr_W * .15, Scr_H * .07)
                            local Rob_Progress_Ply_W = GEN_STORE.Rob_Progress_Ply:GetWide()
                            local Rob_Progress_Ply_H = GEN_STORE.Rob_Progress_Ply:GetTall()
                            local Rob_Progress_Ply_Y = GEN_STORE.Rob_Progress_Ply:GetTall() * .04
                            GEN_STORE.Rob_Progress_Ply:SetPos(Scr_W, Scr_H / 2 - (Rob_Progress_Ply_H / 2))
                            GEN_STORE.Rob_Progress_Ply:SetTitle("")
                            GEN_STORE.Rob_Progress_Ply:ShowCloseButton(false)
                            GEN_STORE.Rob_Progress_Ply:SetDraggable(false)
                            GEN_STORE.Rob_Progress_Ply.Paint = function(Me, Width, Height)
                                draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor, true, false, true, false)
                                draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .35, GEN_STORE.maintopbarcolor, true, false, false, false)
                                draw.SimpleText(GEN_STORE_LANG.robberbartop, "gen_store_text_7", Height * .04, (Height * .35) / 2, GEN_STORE.robprogresstoptextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                                draw.SimpleText(GEN_STORE_LANG.robberdistwarn, "gen_store_text_7", Width / 2, Height * .6, GEN_STORE.robprogressdistwarncolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end
                            GEN_STORE.Rob_Progress_Ply:MoveTo(Scr_W - Rob_Progress_Ply_W, Scr_H / 2 - (Rob_Progress_Ply_H / 2), GEN_STORE.animationsmallmenutime, 0, -1)

                            local Close_Button_Robber = vgui.Create("DImageButton", GEN_STORE.Rob_Progress_Ply)
                            Close_Button_Robber:SetSize(Rob_Progress_Ply_H * .29, Rob_Progress_Ply_H * .29)
                            Close_Button_Robber:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
                            Close_Button_Robber:SetPos(Rob_Progress_Ply_W - Close_Button_Robber:GetWide() - Rob_Progress_Ply_Y, Rob_Progress_Ply_Y) 

                            local Rob_Progress_Ply_DProgress = vgui.Create("DProgress", GEN_STORE.Rob_Progress_Ply)
                            Rob_Progress_Ply_DProgress:SetSize(Rob_Progress_Ply_W * .8, Rob_Progress_Ply_H * .325)
                            Rob_Progress_Ply_DProgress:SetPos(Rob_Progress_Ply_W * .1, Rob_Progress_Ply_H * .5125)

                            local function DistanceWarning(Bool)
                                if Bool then
                                    Rob_Progress_Ply_DProgress:MoveTo(Rob_Progress_Ply_W * .1, Rob_Progress_Ply_H * .8125, GEN_STORE.robprogressanimtime, 0, -1)
                                    Rob_Progress_Ply_DProgress:SizeTo(Rob_Progress_Ply_W * .8, Rob_Progress_Ply_H * .125, GEN_STORE.robprogressanimtime, 0, -1)
                                else
                                    Rob_Progress_Ply_DProgress:MoveTo(Rob_Progress_Ply_W * .1, Rob_Progress_Ply_H * .5125, GEN_STORE.robprogressanimtime, 0, -1)
                                    Rob_Progress_Ply_DProgress:SizeTo(Rob_Progress_Ply_W * .8, Rob_Progress_Ply_H * .325, GEN_STORE.robprogressanimtime, 0, -1)
                                end
                            end

                            net.Receive("Gen_Store_Distance_Warning", function()
                                if GEN_STORE.Rob_Progress_Ply:IsValid() then
                                    DistanceWarning(net.ReadBool())
                                end
                            end)

                            local function CloseRobProgress(Timer)
                                if GEN_STORE.Rob_Progress_Ply:IsValid() then
                                    timer.Remove("Gen_Store_cl_Rob_Time_Left")
                                    if Timer then
                                        timer.Simple(3, function()
                                            GEN_STORE.Rob_Progress_Ply:MoveTo(Scr_W, Scr_H / 2 - (Rob_Progress_Ply_H / 2), GEN_STORE.animationsmallmenutime, 0, -1, function()
                                                GEN_STORE.Rob_Progress_Ply:Close()
                                            end)
                                        end)
                                    else
                                        GEN_STORE.Rob_Progress_Ply:MoveTo(Scr_W, Scr_H / 2 - (Rob_Progress_Ply_H / 2), GEN_STORE.animationsmallmenutime, 0, -1, function()
                                            GEN_STORE.Rob_Progress_Ply:Close()
                                        end)
                                    end
                                end
                            end

                            Close_Button_Robber.DoClick = function()
                                Player:EmitSound(GEN_STORE.acceptsound)
                                timer.Remove("Gen_Store_cl_Rob_Time_Left")
                                CloseRobProgress(false)
                            end

                            local One_Percent = GEN_STORE.Settings.Robbery[2] / 100
                            timer.Create("Gen_Store_cl_Rob_Time_Left", One_Percent, 100, function()
                                if not GEN_STORE.Rob_Progress_Ply:IsValid() then
                                    timer.Remove("Gen_Store_cl_Rob_Time_Left")
                                    return
                                end
                                
                                Rob_Progress_Ply_DProgress:SetFraction(Rob_Progress_Ply_DProgress:GetFraction() + .01)

                                if Rob_Progress_Ply_DProgress:GetFraction() > 1 then
                                    CloseRobProgress(true)
                                end
                            end)

                            net.Receive("Gen_Store_Rob_Failed", function()
                                CloseRobProgress(true)
                            end)
                        end
                    end
                end
            elseif not Player_CP and not Rob then
                local Reason_Text = ""
                if Number == -1 then
                    Reason_Text = GEN_STORE_LANG.mainmenunotenoughgov
                    Number = ""
                elseif Number == -2 then
                    Reason_Text = GEN_STORE_LANG.mainmenuanotherstore
                    Number = ""
                else
                    Reason_Text = GEN_STORE_LANG.mainmneuseconds
                end

                local Can_Not_Rob_Text = vgui.Create("DLabel", Nav_Bar_Panel)
                Can_Not_Rob_Text:SetSize(Nav_Bar_Panel:GetWide() * .9, Nav_Bar_Panel:GetTall() * .05)
                Can_Not_Rob_Text:SetPos(Nav_Bar_Panel:GetWide() * .05, Nav_Bar_Panel:GetTall() * .95)
                Can_Not_Rob_Text:SetText("")
                Can_Not_Rob_Text.Paint = function(Me, Width, Height)
                    draw.SimpleText(GEN_STORE_LANG.mainmenucooldown, "gen_store_text_2", Width / 2, Height * .3, GEN_STORE.robcooldowntextcolortop, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(Number .. Reason_Text, "gen_store_text_9", Width / 2, Height * .7, GEN_STORE.robcooldowntextcolorbelow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end
        end

        local function ItemChecker(Selection)
            Scroll_Bar:Clear()
            Player:EmitSound(GEN_STORE.acceptsound)
            local Start_Selection = GEN_STORE.Settings.Category[1][1]
            for k, item in ipairs(GEN_STORE.Items) do 
                if item[2] == "" or item[4] == "" then
                    -- to not produce errors and keep making items
                    continue
                elseif Selection == item[5] or Selection == Start_Selection then
                    local Item_Panel = vgui.Create("DPanel", Scroll_Bar)
                    Item_Panel:DockMargin(Gen_Store_Menu_W * .15, 0, Gen_Store_Menu_Y, Gen_Store_Menu_Y)
                    Item_Panel:Dock(TOP)
                    Item_Panel:SetTall(Gen_Store_Menu_H * .08)
                    local Item_Panel_W = Item_Panel:GetWide()
                    local Item_Panel_H = Item_Panel:GetTall()
                    
                    local Desc_Empty = item[3] == ""
                    local Title_Text_Color = nil
                    if item[8] then
                        Title_Text_Color = GEN_STORE.itempanelviptitletextcolor
                    else
                        Title_Text_Color = GEN_STORE.itempaneltitletextcolor
                    end

                    local Pos_Height = 0
                    if not Desc_Empty then
                        Pos_Height = Item_Panel_H * .3
                    else
                        Pos_Height = Item_Panel_H / 2
                    end
                    
                    Item_Panel.Paint = function(Me, Width, Height)
                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmaincolor)
                        draw.SimpleText(item[1], "gen_store_text_1", Width * .08, Pos_Height, Title_Text_Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(item[3], "gen_store_text_2", Width * .08, Height * .7, GEN_STORE.itempaneldesccolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    
                    local Item_Buy_Button = vgui.Create("DButton", Item_Panel)
                    Item_Buy_Button:DockMargin(0, Gen_Store_Menu_Y * 2, Gen_Store_Menu_Y, Gen_Store_Menu_Y * 2)
                    Item_Buy_Button:Dock(RIGHT)
                    Item_Buy_Button:SetText("")
                    Item_Buy_Button:SetWide(Item_Panel_W * 1.5)

                    local Price = 0
                    local Color, Text = GEN_STORE.itempanelcantbuycolor, GEN_STORE_LANG.mainmenucantbuy
                    if item[8] then
                        Price = item[7]
                        if GEN_STORE.VIP[Player:GetUserGroup()] and Player:canAfford(Price) then
                            Color, Text = GEN_STORE.itempanelbuycolor, GEN_STORE_LANG.mainmenubuy
                        elseif not GEN_STORE.VIP[Player:GetUserGroup()] then
                            Color, Text = GEN_STORE.itempanelcantbuycolor, GEN_STORE_LANG.mainmenuviponly
                        end
                    elseif GEN_STORE.Settings.Store[2] and GEN_STORE.VIP[Player:GetUserGroup()] then
                        Price = item[7] * GEN_STORE.Settings.Store[6]
                        if Player:canAfford(Price) then
                            Color, Text = GEN_STORE.itempanelbuycolor, GEN_STORE_LANG.mainmenubuy
                        end
                    elseif GEN_STORE.Settings.Store[1] and Player_CP then
                        Price = item[7] * GEN_STORE.Settings.Store[5]
                        if Player:canAfford(Price) then
                            Color, Text = GEN_STORE.itempanelbuycolor, GEN_STORE_LANG.mainmenubuy
                        end
                    else
                        Price = item[7]
                        if Player:canAfford(Price) then
                            Color, Text = GEN_STORE.itempanelbuycolor, GEN_STORE_LANG.mainmenubuy
                        end
                    end

                    Item_Buy_Button.Paint = function(Me, Width, Height)
                        if Me:IsHovered() then
                            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, Color)
                            draw.SimpleText(Text, "gen_store_text_3", Width / 2, Height / 2, GEN_STORE.itempanelbuytext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        else
                            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelbuybuttoncolor)
                            draw.SimpleText(DarkRP.formatMoney(Price), "gen_store_text_4", Width / 2, Height / 2, GEN_STORE.itempanelbuytext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end
                    end

                    Item_Buy_Button.DoClick = function()
                        net.Start("Gen_Store_Start_Purchase")
                            net.WriteInt(NPC, 16)
                            net.WriteInt(k, 8)
                        net.SendToServer()

                        -- To reload items so the UI can do correct "cant afford" or "purchase" drawings and etc with buyers now less money.
                        -- Should be more efficient instead of checking can afford and math in draw :O
                        timer.Simple(.1, function()
                            if Selection == Start_Selection then
                                ItemChecker(Start_Selection)
                            else
                                ItemChecker(item[5])
                            end
                        end)
                    end

                    local Item_Icon_Back = vgui.Create("DLabel", Item_Panel)
                    Item_Icon_Back:DockMargin(Gen_Store_Menu_Y, Gen_Store_Menu_Y, 0, Gen_Store_Menu_Y)
                    Item_Icon_Back:Dock(LEFT)
                    Item_Icon_Back:SetText("")
                    Item_Icon_Back:SetWide(Item_Panel_H * .8)
                    Item_Icon_Back.Paint = function(Me, Width, Height)
                        draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmodelbackcolor)
                    end

                    if item[4] == "weapon" or item[4] == "entity" then
                        if item[6] == "" then
                            -- to not produce error
                            continue
                        end
                        
                        local Item_Icon = vgui.Create("DModelPanel", Item_Icon_Back)
                        Item_Icon:Dock(FILL)
                        Item_Icon:SetModel(item[6])

                        local mn, mx = Item_Icon.Entity:GetRenderBounds()
                        local size = 0
                        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                        Item_Icon:SetFOV(30)
                        Item_Icon:SetCamPos(Vector(size + 20, size + 20, size - 10))
                        Item_Icon:SetLookAt((mn + mx) * 0.5)

                        local Item_Icon_View_Button = vgui.Create("DButton", Item_Panel)
                        Item_Icon_View_Button:DockMargin(-Item_Icon_Back:GetWide(), Gen_Store_Menu_Y, 0, Gen_Store_Menu_Y)
                        Item_Icon_View_Button:Dock(LEFT)
                        Item_Icon_View_Button:SetText("")
                        Item_Icon_View_Button:SetWide(Item_Panel_H * .8)
                        Item_Icon_View_Button.Paint = function(Me, Width, Height)
                            if Me:IsHovered() then
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.itempanelmodelhovercolor)
                            end
                        end
                            
                        Item_Icon_View_Button.DoClick = function()
                            Player:EmitSound(GEN_STORE.acceptsound)
                            local Item_Icon_View_Menu = vgui.Create("DFrame")
                            Item_Icon_View_Menu:SetSize(Scr_W * .5, Scr_H * .65)
                            local Item_Icon_View_Menu_W = Item_Icon_View_Menu:GetWide()
                            local Item_Icon_View_Menu_H = Item_Icon_View_Menu:GetTall()
                            local Item_Icon_View_Menu_Y = Item_Icon_View_Menu:GetTall() * .01
                            Item_Icon_View_Menu:Center()
                            Item_Icon_View_Menu:SetDraggable(false)
                            Item_Icon_View_Menu:SetTitle("")
                            Item_Icon_View_Menu:MakePopup(true)
                            Item_Icon_View_Menu:SetMouseInputEnabled(true)
                            Item_Icon_View_Menu:ShowCloseButton(false)
                            Item_Icon_View_Menu.Paint = function(Me, Width, Height)
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.inspectmenubackcolor)
                                draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .045, GEN_STORE.maintopbarcolor, true, true, false, false)
                                draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, Height * .045, Width, 2, GEN_STORE.separatorcolor, true, true, false, false)
                                draw.SimpleText(GEN_STORE_LANG.inspecttop, "gen_store_text_1", Width / 2, Height * .0225, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end

                            local Item_Icon_View_Back = vgui.Create("DLabel", Item_Icon_View_Menu)
                            Item_Icon_View_Back:DockMargin(0, Item_Icon_View_Menu_H * .0045 + 5, 0, 0)
                            Item_Icon_View_Back:Dock(FILL)
                            Item_Icon_View_Back:SetText("")
                            Item_Icon_View_Back.Paint = function(Me, Width, Height)
                                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.inspectmenumodelbackcolor)
                                draw.SimpleText(GEN_STORE_LANG.inspectmodel, "gen_store_text_5", Width / 2, Height / 2, GEN_STORE.inspectmenuhowtotextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end


                            local Item_Icon_View_MDL_Big = vgui.Create("DAdjustableModelPanel", Item_Icon_View_Menu)
                            Item_Icon_View_MDL_Big:DockMargin(0, Item_Icon_View_Menu_H * .0045 + 5, 0, 0)
                            Item_Icon_View_MDL_Big:Dock(FILL)
                            Item_Icon_View_MDL_Big:SetModel(item[6])
                            
                            local mn, mx = Item_Icon_View_MDL_Big.Entity:GetRenderBounds()
                            local size = 0
                            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                            Item_Icon_View_MDL_Big:SetFOV(20)
                            Item_Icon_View_MDL_Big:SetCamPos(Vector(size + 20, size + 20, size - 10))
                            Item_Icon_View_MDL_Big:SetLookAt((mn + mx) * 0.5)

                            local Close_Button_WH_2 = Item_Icon_View_Menu_H * .038
                            local Close_Button_View_MDL_Big = vgui.Create("DImageButton", Item_Icon_View_Menu)
                            Close_Button_View_MDL_Big:SetSize(Close_Button_WH_2, Close_Button_WH_2)
                            Close_Button_View_MDL_Big:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
                            Close_Button_View_MDL_Big:SetPos(Item_Icon_View_Menu_W - Close_Button_WH_2 - Item_Icon_View_Menu_Y / 3, Item_Icon_View_Menu_Y / 2) 
                            
                            Close_Button_View_MDL_Big.DoClick = function()
                                Item_Icon_View_Menu:Close()
                                Player:EmitSound(GEN_STORE.acceptsound)
                            end
                        end
                    elseif item[4] == "health" or item[4] == "armor" then
                        local Item_Image = vgui.Create("DImage", Item_Icon_Back)
                        Item_Image:DockMargin(5,5,5,5)
                        Item_Image:Dock(FILL)
                        Item_Image:SetImage("itemicon/" .. item[4] .. ".png")
                    end
                end
            end
        end

        local Nav_Bar_Selection = GEN_STORE.Settings.Category[1][1]
        for k, category in ipairs(GEN_STORE.Settings.Category) do
            local Nav_Bar = vgui.Create("DButton", Nav_Bar_Panel)
            Nav_Bar:DockMargin(0, 1, 0, Nav_Bar_Panel:GetTall() * .005)
            Nav_Bar:Dock(TOP)
            Nav_Bar:SetTall(Nav_Bar_Panel:GetTall() * .06)
            Nav_Bar:SetText("")
            local Category_Color = Color(category[2][1], category[2][2], category[2][3])
            Nav_Bar.Paint = function(Me, Width, Height)
                if Nav_Bar_Selection == category[1] then
                    draw.RoundedBoxEx(GEN_STORE.roundboxamount, Width * .98, 0, Height, Height, Category_Color, true, false, true, false)
                    draw.SimpleText(category[1], "gen_store_text_1", Width / 2, Height / 2, Category_Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(category[1], "gen_store_text_1", Width / 2, Height / 2, GEN_STORE.navbartextunselec, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            Nav_Bar.DoClick = function()
                Nav_Bar_Selection = category[1]
                ItemChecker(Nav_Bar_Selection)
            end
        end

        ItemChecker(GEN_STORE.Settings.Category[1][1])
    elseif GEN_STORE.Menu:IsValid() then 
        GEN_STORE.Menu:Remove()
    end
end

net.Receive("Gen_Store_Used_Start", StoreOpen)