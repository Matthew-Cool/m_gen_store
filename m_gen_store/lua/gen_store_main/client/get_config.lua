net.Receive("Gen_Store_Get_Config", function()
    local Number = net.ReadUInt(4)
    
    if Number <= 2 then
        GEN_STORE.Items = net.ReadTable()
    end

    if Number == 1 then
        GEN_STORE.Settings = {}
        GEN_STORE.Settings.Robbery = {}
        GEN_STORE.Settings.Store = {}

        GEN_STORE.Settings.Robbery[1] = net.ReadBool()
        GEN_STORE.Settings.Robbery[2] = net.ReadDouble()
        GEN_STORE.Settings.Robbery[6] = net.ReadBool()

        GEN_STORE.Settings.Store[1] = net.ReadBool()
        GEN_STORE.Settings.Store[2] = net.ReadBool()
        GEN_STORE.Settings.Store[5] = net.ReadDouble()
        GEN_STORE.Settings.Store[6] = net.ReadDouble()

        GEN_STORE.Settings.Category = net.ReadTable()
    elseif Number == 2 or Number == 3 then
        GEN_STORE.Settings = net.ReadTable()
    elseif Number == 4 then
        GEN_STORE.Settings.Category = net.ReadTable()
    end
end)