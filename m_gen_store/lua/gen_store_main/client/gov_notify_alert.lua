local function GovtNotifyOpen()
    if GEN_STORE.GovMenu == nil or not GEN_STORE.GovMenu:IsValid() then
        local Position = net.ReadVector()
        local Notify_Time = net.ReadDouble()
        local Dist_Timer = net.ReadDouble()
        
        local Player = LocalPlayer()
        local Scr_W, Scr_H = ScrW(), ScrH()
        Player:EmitSound("m_gen_store/gov_notification_sound.wav")
        GEN_STORE.GovMenu = vgui.Create("DFrame")
        GEN_STORE.GovMenu:SetSize(Scr_W * .15, Scr_H * .07)
        local Gen_Store_Gov_Notif_H = GEN_STORE.GovMenu:GetTall()
        local Gen_Store_Gov_Notif_W = GEN_STORE.GovMenu:GetWide()
        GEN_STORE.GovMenu:SetPos(Scr_W, Scr_H * .67 - Gen_Store_Gov_Notif_H / 2)
        GEN_STORE.GovMenu:SetTitle("")
        GEN_STORE.GovMenu:ShowCloseButton(false)
        GEN_STORE.GovMenu:SetDraggable(true)
        GEN_STORE.GovMenu.Paint = function(Me, Width, Height)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor, true, false, true, false)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .35, GEN_STORE.maintopbarcolor, true, false, false, false)
            draw.SimpleText(GEN_STORE_LANG.govnotifytop, "gen_store_text_7", Height * .04, (Height * .35) / 2, GEN_STORE.govnotiftoptextcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        GEN_STORE.GovMenu:MoveTo(Scr_W - Gen_Store_Gov_Notif_W, Scr_H * .67 - Gen_Store_Gov_Notif_H / 2, GEN_STORE.animationsmallmenutime, 0, -1)

        local Cancel_Button = vgui.Create("DButton", GEN_STORE.GovMenu)
        Cancel_Button:SetSize(Gen_Store_Gov_Notif_W * .3, Gen_Store_Gov_Notif_H * .4)
        Cancel_Button:SetPos(Gen_Store_Gov_Notif_W / 2 + Gen_Store_Gov_Notif_W * .07, Gen_Store_Gov_Notif_H * .675 - Cancel_Button:GetTall() / 2)
        Cancel_Button:SetText("")
        Cancel_Button.Paint = function(Me, Width, Height)
            if Me:IsHovered() then
                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifcancelhovercolor)
            else
                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifcancelcolor)
            end
            draw.SimpleText(GEN_STORE_LANG.govnotifycancel, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifcanceltextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        Cancel_Button.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            timer.Remove("Gen_Store_Gov_Notify_Timer")
            GEN_STORE.GovMenu:MoveTo(Scr_W, Scr_H * .67 - Gen_Store_Gov_Notif_H / 2, GEN_STORE.animationsmallmenutime, 0, -1, function()
                GEN_STORE.GovMenu:Close()
            end)
        end

        local Respond_Button = vgui.Create("DButton", GEN_STORE.GovMenu)
        Respond_Button:SetSize(Gen_Store_Gov_Notif_W * .3, Gen_Store_Gov_Notif_H * .4)
        Respond_Button:SetPos(Gen_Store_Gov_Notif_W / 2 - Gen_Store_Gov_Notif_W * .07 - Respond_Button:GetWide(), Gen_Store_Gov_Notif_H * .675 - Respond_Button:GetTall() / 2)
        Respond_Button:SetText("")
        Respond_Button.Paint = function(Me, Width, Height)
            if Me:IsHovered() then
                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondhovercolor)
            else
                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifrespondcolor)
            end
            draw.SimpleText(GEN_STORE_LANG.govnotifyrespond, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifrespondtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        Respond_Button.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            timer.Remove("Gen_Store_Gov_Notify_Timer")
            Respond_Button:Remove()
            Cancel_Button:Remove()

            hook.Add("HUDPaint", "Gen_Store_Gov_Marker", function()
                local Final_Position = Position:ToScreen()
                
                draw.RoundedBox(GEN_STORE.govnotifmarkerround, Final_Position.x - 62.5, Final_Position.y - 20, 125, 40, GEN_STORE.govnotifmarker)
                draw.SimpleText(GEN_STORE_LANG.govnotifylocation, "gen_store_text_6", Final_Position.x, Final_Position.y, GEN_STORE.govnotifmarkertextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end)
            
            local On_Scene_Button = vgui.Create("DButton", GEN_STORE.GovMenu)
            On_Scene_Button:SetSize(Gen_Store_Gov_Notif_W * .4, Gen_Store_Gov_Notif_H * .3)
            On_Scene_Button:SetPos(Gen_Store_Gov_Notif_W * .55, Gen_Store_Gov_Notif_H * .675 - On_Scene_Button:GetTall() / 2)
            On_Scene_Button:SetText("")
            On_Scene_Button.Paint = function(Me, Width, Height)
                if Me:IsHovered() then
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifherehovercolor)
                else
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifherecolor)
                end
                draw.SimpleText(GEN_STORE_LANG.govnotifyhere, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.govnotifheretextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            On_Scene_Button.DoClick = function()
                Player:EmitSound(GEN_STORE.acceptsound)
                hook.Remove("HUDPaint", "Gen_Store_Gov_Marker")
                timer.Remove("Gen_Store_Gov_Notify_Dist_Timer")
                GEN_STORE.GovMenu:MoveTo(Scr_W, Scr_H * .67 - Gen_Store_Gov_Notif_H / 2, GEN_STORE.animationsmallmenutime, 0, -1, function()
                    GEN_STORE.GovMenu:Close()
                end)
            end

            local Distance_To_Scene = vgui.Create("DLabel", GEN_STORE.GovMenu)
            Distance_To_Scene:SetSize(Gen_Store_Gov_Notif_W * .5, Gen_Store_Gov_Notif_H * .3)
            Distance_To_Scene:SetPos(Gen_Store_Gov_Notif_W * .025, Gen_Store_Gov_Notif_H * .675 - Gen_Store_Gov_Notif_H * .15)
            Distance_To_Scene:SetText("")

            local Distance = 0
            timer.Create("Gen_Store_Gov_Notify_Dist_Timer", 1, Dist_Timer, function()
                if not GEN_STORE.GovMenu:IsValid() then
                    timer.Remove("Gen_Store_Gov_Notify_Dist_Timer")
                    return
                end

                Distance = math.Round(math.sqrt((Player:GetPos():DistToSqr(Position)) / 100), 2)
            end)

            Distance_To_Scene.Paint = function(Me, Width, Height)
                draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.govnotifdistboxcolor)
                draw.SimpleText(GEN_STORE_LANG.govnotifydist .. Distance .. GEN_STORE_LANG.govnotifydistamount, "gen_store_text_2", Width / 2, Height / 2, GEN_STORE.govnotifdisttextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        timer.Create("Gen_Store_Gov_Notify_Timer", Notify_Time, 1, function()
            if not GEN_STORE.GovMenu:IsValid() then
                timer.Remove("Gen_Store_Gov_Notify_Timer")
                return
            end
            
            GEN_STORE.GovMenu:MoveTo(Scr_W, Scr_H * .67 - Gen_Store_Gov_Notif_H / 2, GEN_STORE.animationsmallmenutime, 0, -1, function()
                GEN_STORE.GovMenu:Close()
            end)
        end)
    elseif GEN_STORE.GovMenu:IsValid() then 
        GEN_STORE.GovMenu:Remove()
    end
end

net.Receive("Gen_Store_Gov_Notify", GovtNotifyOpen)