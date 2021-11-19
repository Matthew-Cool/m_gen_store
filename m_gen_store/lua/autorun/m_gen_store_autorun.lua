GEN_STORE = {} or GEN_STORE
GEN_STORE_LANG = {} or GEN_STORE_LANG

if SERVER then
    
    include("gen_store_config/config.lua")
    include("gen_store_config/theme/theme.lua")
    include("gen_store_config/lang/" .. GEN_STORE.lang .. ".lua")

    print(GEN_STORE_LANG.conloading)

    include("gen_store_main/server/net.lua")
    include("gen_store_main/server/buy.lua")
    include("gen_store_main/server/con_commands.lua")
    include("gen_store_main/server/config_update.lua")
    include("gen_store_main/server/hooks.lua")
    include("gen_store_main/server/server_start.lua")

    AddCSLuaFile("gen_store_config/config.lua")
    AddCSLuaFile("gen_store_config/theme/theme.lua")
    AddCSLuaFile("gen_store_config/lang/" .. GEN_STORE.lang .. ".lua")
    AddCSLuaFile("gen_store_main/client/fonts.lua")
    AddCSLuaFile("gen_store_main/client/main_menus.lua")
    AddCSLuaFile("gen_store_main/client/rob_menu.lua")
    AddCSLuaFile("gen_store_main/client/event_lock_menu.lua")
    AddCSLuaFile("gen_store_main/client/gov_notify_alert.lua")
    AddCSLuaFile("gen_store_main/client/get_config.lua")

    print(GEN_STORE_LANG.concomplete)
    
elseif CLIENT then

    include("gen_store_config/config.lua")
    include("gen_store_config/theme/theme.lua")
    include("gen_store_config/lang/" .. GEN_STORE.lang .. ".lua")
    
    print(GEN_STORE_LANG.conloading)
    
    include("gen_store_main/client/fonts.lua")
    include("gen_store_main/client/main_menus.lua")
    include("gen_store_main/client/rob_menu.lua")
    include("gen_store_main/client/event_lock_menu.lua")
    include("gen_store_main/client/gov_notify_alert.lua")
    include("gen_store_main/client/get_config.lua")
    
    print(GEN_STORE_LANG.concomplete)

end
