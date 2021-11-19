-- server set up
if not file.Exists("m_gen_store", "DATA") then
    file.CreateDir("m_gen_store")
end

if not file.Exists("m_gen_store/gen_store_items.txt", "DATA") then
    local Default_Items = {
        {GEN_STORE_LANG.defaultstoreitems[1][1], "weapon_glock2", GEN_STORE_LANG.defaultstoreitems[1][2], "weapon", GEN_STORE_LANG.defaultstoreitems[1][3], "models/weapons/w_pist_glock18.mdl", 1000, false},
        {GEN_STORE_LANG.defaultstoreitems[2][1], "item_ammo_pistol", GEN_STORE_LANG.defaultstoreitems[2][2], "entity", GEN_STORE_LANG.defaultstoreitems[2][3], "models/items/boxsrounds.mdl", 200, false},
        {GEN_STORE_LANG.defaultstoreitems[3][1], "50", "", "health", GEN_STORE_LANG.defaultstoreitems[3][2], "", 2000, false},
        {GEN_STORE_LANG.defaultstoreitems[4][1], "50", "", "armor", GEN_STORE_LANG.defaultstoreitems[4][2], "",  4000, false}
    }

    file.Write("m_gen_store/gen_store_items.txt", util.TableToJSON(Default_Items))
end

if not file.Exists("m_gen_store/gen_store_settings.txt", "DATA") then
    local Default_Settings = {
        Store = {true, true, true, 100, .9, .75, .5, 100},
        Robbery = {true, 30, 10, true, 5000, true, 2, 600, 200, 5000, true, 15, 30},
        Category = {
            {GEN_STORE_LANG.defaultstorecategories[1], {0,128,227}},
            {GEN_STORE_LANG.defaultstorecategories[2], {191,0,0}},
            {GEN_STORE_LANG.defaultstorecategories[3], {23,161,0}},
            {GEN_STORE_LANG.defaultstorecategories[4], {218,242,0}}
        }
    }

    file.Write("m_gen_store/gen_store_settings.txt", util.TableToJSON(Default_Settings))
end


function GEN_STORE:UpdateConfig()
    GEN_STORE.Settings = util.JSONToTable(file.Read("m_gen_store/gen_store_settings.txt", "DATA"))
    GEN_STORE.Items = util.JSONToTable(file.Read("m_gen_store/gen_store_items.txt", "DATA"))
end

hook.Add("InitPostEntity", "Gen_Store_NPC_Spawn", function()   
    if not file.Exists("m_gen_store/gen_store_spawns.txt", "DATA") then
        print(GEN_STORE_LANG.confailautospawn) 
    else
        local Saved_NPCs = util.JSONToTable(file.Read("m_gen_store/gen_store_spawns.txt", "DATA"))

        if GEN_STORE.randomspawns then
            local Amount = table.Count(Saved_NPCs)

            if Amount <= GEN_STORE.amountofrandomspawns then
                print(GEN_STORE_LANG.connotenoughsave) 
            else
                local Amount_of_Spawns = 1
                local Past_Selections = {}
                local Selection = 0
                while Amount_of_Spawns <= GEN_STORE.amountofrandomspawns do
                    Amount_of_Spawns = Amount_of_Spawns + 1
                    
                    while Past_Selections[Selection] or Selection == 0 do
                        Selection = math.random(1, Amount)
                    end
                    Past_Selections[Selection] = Selection

                    for k, v in pairs(Saved_NPCs) do
                        if Selection == k then 
                            print(GEN_STORE_LANG.conspawned .. k)
                            local NPC = ents.Create("gen_store_npc")
                            NPC:SetPos(v[1])
                            NPC:SetAngles(v[2])
                            NPC:Spawn()
                        end
                    end
                end
            end
        else
            for k, v in pairs(Saved_NPCs) do 
                print(GEN_STORE_LANG.conspawned .. k)
                local NPC = ents.Create("gen_store_npc")
                NPC:SetPos(v[1])
                NPC:SetAngles(v[2])
                NPC:Spawn()
            end
        end
    end
end)

GEN_STORE:UpdateConfig()

if GEN_STORE.autodownload then
    resource.AddWorkshop("2515922328")
end