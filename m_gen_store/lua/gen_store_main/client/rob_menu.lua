local function RobOpen()
    if GEN_STORE.FailMenu == nil or not GEN_STORE.FailMenu:IsValid() then
        local Time_Left = net.ReadDouble()
        local Robbery_Time = net.ReadDouble()
        
        local Player = LocalPlayer()
        local Scr_W, Scr_H = ScrW(), ScrH()
        Player:EmitSound(GEN_STORE.sorrysound)
        GEN_STORE.FailMenu = vgui.Create("DFrame")
        GEN_STORE.FailMenu:SetSize(Scr_W * .3, Scr_H * .35)
        local Gen_Store_Fail_Menu_H = GEN_STORE.FailMenu:GetTall()
        local Gen_Store_Fail_Menu_W = GEN_STORE.FailMenu:GetWide()
        local Gen_Store_Fail_Menu_Y = GEN_STORE.FailMenu:GetTall() * .01
        GEN_STORE.FailMenu:SetPos(Scr_W / 2 - (Gen_Store_Fail_Menu_W / 2), Scr_H)
        GEN_STORE.FailMenu:SetDraggable(false)
        GEN_STORE.FailMenu:SetTitle("")
        GEN_STORE.FailMenu:MakePopup(true)
        GEN_STORE.FailMenu:SetMouseInputEnabled(true)
        GEN_STORE.FailMenu:ShowCloseButton(false)
        GEN_STORE.FailMenu.Paint = function(Me, Width, Height)
            draw.RoundedBox(GEN_STORE.roundboxamount, 0, 0, Width, Height, GEN_STORE.mainbackgroundcolor)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, 0, Width, Height * .08, GEN_STORE.maintopbarcolor, true, true, false, false)
            draw.RoundedBoxEx(GEN_STORE.roundboxamount, 0, Height * .08, Width, 2, GEN_STORE.separatorcolor, true, true, false, false)
            draw.SimpleText(GEN_STORE_LANG.topbar, "gen_store_text_1", Width / 2, Height * .04, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(GEN_STORE_LANG.robmenumain, "gen_store_text_5", Width / 2, Height * .65, GEN_STORE.maintoptextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        GEN_STORE.FailMenu:MoveTo(Scr_W / 2 - (Gen_Store_Fail_Menu_W / 2), Scr_H / 2 - (Gen_Store_Fail_Menu_H / 2), GEN_STORE.animationopentime, 0, -1)
    
        -- For fast escape in rob menu
        function GEN_STORE.FailMenu:OnKeyCodePressed( ... )
            Player:EmitSound(GEN_STORE.acceptsound)
            timer.Remove("Gen_Store_Rob_DProgress_Time")
            GEN_STORE.FailMenu:MoveTo(Scr_W / 2 - (Gen_Store_Fail_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                GEN_STORE.FailMenu:Close()
            end)
        end
    
        local Close_Button_Fail_WH = Gen_Store_Fail_Menu_H * .064
        local Close_Button_Fail = vgui.Create("DImageButton", GEN_STORE.FailMenu)
        Close_Button_Fail:SetSize(Close_Button_Fail_WH, Close_Button_Fail_WH)
        Close_Button_Fail:SetImage("closebuttonicon/" .. GEN_STORE.closebutton .. ".png")
        Close_Button_Fail:SetPos(Gen_Store_Fail_Menu_W - Close_Button_Fail_WH - (Gen_Store_Fail_Menu_Y / 2), Gen_Store_Fail_Menu_Y) 
    
        Close_Button_Fail.DoClick = function()
            Player:EmitSound(GEN_STORE.acceptsound)
            timer.Remove("Gen_Store_Rob_DProgress_Time")
            GEN_STORE.FailMenu:MoveTo(Scr_W / 2 - (Gen_Store_Fail_Menu_W / 2), Scr_H, GEN_STORE.animationclosetime, 0, -1, function()
                GEN_STORE.FailMenu:Close()
            end)
        end
    
        local Fail_Menu_Lock_Icon = vgui.Create("DImage", GEN_STORE.FailMenu)
        Fail_Menu_Lock_Icon:SetSize(Gen_Store_Fail_Menu_H * .4, Gen_Store_Fail_Menu_H * .4)
        Fail_Menu_Lock_Icon:SetImage("robpanelicon/" .. GEN_STORE.robpanelicon .. ".png")
        Fail_Menu_Lock_Icon:SetPos(Gen_Store_Fail_Menu_W / 2 - (Gen_Store_Fail_Menu_H * .2), Gen_Store_Fail_Menu_H / 2 - (Gen_Store_Fail_Menu_H * .375))
        Fail_Menu_Lock_Icon:SetImageColor(GEN_STORE.robpaneliconcolor)
    
        local Rob_Progress_Bar = vgui.Create("DProgress", GEN_STORE.FailMenu)
        Rob_Progress_Bar:SetSize(Gen_Store_Fail_Menu_W * .5, Gen_Store_Fail_Menu_H * .1)
        Rob_Progress_Bar:SetPos(Gen_Store_Fail_Menu_W / 2 - (Rob_Progress_Bar:GetWide() / 2), Gen_Store_Fail_Menu_H * .775)
    
        local One_Percent = Robbery_Time / 100
        Rob_Progress_Bar:SetFraction(((Time_Left - Robbery_Time) * -1) / Robbery_Time)
        timer.Create("Gen_Store_Rob_DProgress_Time", One_Percent, Time_Left / One_Percent, function()
            if not GEN_STORE.FailMenu:IsValid() then
                timer.Remove("Gen_Store_Rob_DProgress_Time")
                return
            end
            
            Rob_Progress_Bar:SetFraction(Rob_Progress_Bar:GetFraction() + .01)
        end)
    elseif GEN_STORE.FailMenu:IsValid() then 
        GEN_STORE.FailMenu:Remove()
    end
end

net.Receive("Gen_Store_Used_Fail_Rob", RobOpen)