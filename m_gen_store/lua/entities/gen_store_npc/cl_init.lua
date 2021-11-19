include("shared.lua")

local Distance = GEN_STORE.overheaddist * GEN_STORE.overheaddist
local Picture = Material("overheadicon/" .. GEN_STORE.overheadimageselect .. ".png")
function ENT:Draw()
    self:DrawModel()
    local Player = LocalPlayer()

    if (Player:GetPos():DistToSqr(self:GetPos()) <= Distance) then
        local Player_Angle = Player:EyeAngles()
	    cam.Start3D2D(self:GetPos() + self:GetUp() * 76, Angle(0, Player_Angle.y - 90, 90), .1)
            draw.RoundedBox(GEN_STORE.overheadboxround, -GEN_STORE_LANG.overheadboxsize / 2 - 10, -20, GEN_STORE_LANG.overheadboxsize, 40, GEN_STORE.overheadboxcolor)
            draw.SimpleText(GEN_STORE_LANG.overhead, "gen_store_text_6", -10, 0, GEN_STORE.overheadtextcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if GEN_STORE.overheadimage then
                if GEN_STORE.overheadback then
                    draw.RoundedBoxEx(GEN_STORE.overheadboxround, -40, -80, 60, 60, GEN_STORE.overheadboxcolor, true, true, false, false)
                end
                
                surface.SetDrawColor(GEN_STORE.overheadimagecolor)
                surface.SetMaterial(Picture)
                surface.DrawTexturedRect(-37, -75, 54, 54)
            end
        cam.End3D2D()
    end
end
