local function EventOpen()
    if GEN_STORE.EventMenu == nil or not GEN_STORE.EventMenu:IsValid() then
        local Player = LocalPlayer()
        local Scr_W, Scr_H = ScrW(), ScrH()
        Player:EmitSound(GEN_STORE.sorrysound)
        GEN_STORE.EventMenu = vgui.Create("DFrame")
        GEN_STORE.EventMenu:SetSize(Scr_W * .3, Scr_H * .25)
        local Gen_Store_Event_Menu_H = GEN_STORE.EventMenu:GetTall()
        local Gen_Store_Event_Menu_W = GEN_STORE.EventMenu:GetWide()
        local Gen_Store_Event_Menu_Y = GEN_STORE.EventMenu:GetTall() * .01
        GEN_STORE.EventMenu:SetPos(Scr_W / 2 - (Gen_Store_Event_Menu_W / 2), Scr_H)
        GEN_STORE.EventMenu:SetDraggable(false)
        GEN_STORE.EventMenu:SetTitle("")
        GEN_STORE.EventMenu:MakePopup(true)
        GEN_STORE.EventMenu:SetMouseInputEnabled(true)
        GEN_STORE.EventMenu:ShowCloseButton(false)
        GEN_STORE.EventMenu.Paint = function(Me, Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .1, GEN_STORE.maintopbarcolor, true, true, false, false)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, Height * .1, Width, 2, GEN_STORE.separatorcolor, true, true, false, false)
            draw.SimpleText(GEN_STORE_LANG.topbar, "gen_store_text_1", Width / 2, Height * .05, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(GEN_STORE_LANG.eventmenutext1, "gen_store_text_8", Width / 2, Height * .8, GEN_STORE.eventmenutextcolorup, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(GEN_STORE_LANG.eventmenutext2, "gen_store_text_2", Width / 2, Height * .9, GEN_STORE.eventmenutextcolorbelow , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        GEN_STORE.EventMenu:MoveTo(Scr_W / 2 - (Gen_Store_Event_Menu_W / 2), Scr_H / 2 - (Gen_Store_Event_Menu_H / 2), GEN_STORE.animationopentime, 0, -1)

        local Close_Buttonn_Event_WH = Gen_Store_Event_Menu_H * .085
        local Close_Button_Event = vgui.Create("DImageButton", GEN_STORE.EventMenu)
        Close_Button_Event:SetSize(Close_Buttonn_Event_WH, Close_Buttonn_Event_WH)
        Close_Button_Event:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
        Close_Button_Event:SetPos(Gen_Store_Event_Menu_W - Close_Buttonn_Event_WH - (Gen_Store_Event_Menu_Y / 2), Gen_Store_Event_Menu_Y * 1.2) 

        Close_Button_Event.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            GEN_STORE.EventMenu:MoveTo(Scr_W / 2 - (Gen_Store_Event_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                GEN_STORE.EventMenu:Close()
            end)
        end

        local Event_Menu_Lock_Icon = vgui.Create("DImage", GEN_STORE.EventMenu)
        Event_Menu_Lock_Icon:SetSize(Gen_Store_Event_Menu_H * .55, Gen_Store_Event_Menu_H * .55)
        Event_Menu_Lock_Icon:SetImage("eventlockicon/" .. GEN_STORE.eventlockicon .. ".png")
        Event_Menu_Lock_Icon:SetPos(Gen_Store_Event_Menu_W / 2 - (Event_Menu_Lock_Icon:GetWide() / 2), Gen_Store_Event_Menu_H * .17)

        if GEN_STORE.EventAdmins[Player:GetUserGroup()] then
            local Con_Button = vgui.Create("DButton", GEN_STORE.EventMenu)
            Con_Button:SetSize(Gen_Store_Event_Menu_W * .3, Gen_Store_Event_Menu_H * .08 + 1)
            Con_Button:SetPos(Gen_Store_Event_Menu_Y, Gen_Store_Event_Menu_Y + 1)
            Con_Button:SetText("")

            Con_Button.Paint = function(Me, Width, Height)
                if Me:IsHovered() then
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminbuttonhovercolor)
                else
                    draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.adminbuttoncolor)
                end
                draw.SimpleText(GEN_STORE_LANG.admineventmenuremove, "gen_store_text_7", Width / 2, Height / 2, GEN_STORE.adminbuttontextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            Con_Button.DoClick = function()
                Player:EmitSound(GEN_STORE.acceptsound)
                GEN_STORE.EventMenu:MoveTo(Scr_W / 2 - (Gen_Store_Event_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                    GEN_STORE.EventMenu:Close()
                end)

                Player:ConCommand(GEN_STORE_LANG.adminmenuconbutton[8])
            end
        end
    elseif GEN_STORE.EventMenu:IsValid() then 
        GEN_STORE.EventMenu:Remove()
    end
end

net.Receive("Gen_Store_Used_Event_Start", EventOpen)