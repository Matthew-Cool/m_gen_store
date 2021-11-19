-- Version: 1.0.00


-- Should the content for this script be downloaded automatically? (Default: true)
GEN_STORE.autodownload = true


--***TABLE CONFIG***
-- This part of the config is confusing sometimes, if you need help, figure it out. Maybe message the creator, be he's inactive...
-- WARNING: Don't forget commas and make sure they match up and etc. Read below for help.
-- If you need help, paste the WHOLE config in this link: https://fptje.github.io/glualint-web/

-- Define what VIP user groups there is. (true = vip , false = not vip)
GEN_STORE.VIP = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["vip"] = true
}

-- Who can use the spawn/save/clear commands on the server? (Also has access config menu)
GEN_STORE.Admins = {
    ["superadmin"] = true,
    ["admin"] = false,
    ["eventteam"] = false
}

-- Who can use the event lock command on the server?
GEN_STORE.EventAdmins = {
    ["superadmin"] = false,
    ["admin"] = false,
    ["eventteam"] = true
}



--***MISC CONFIG***
-- Config settings where I don't know where to put it in, so here! ;)

-- Do you want random spawns to happen? (Default: false) (Note: Repeats will not occur!)
GEN_STORE.randomspawns = false

-- The amount of random spawns you want? (Default: 3) (Above option must be true for this to work!)
-- (WARNING: The amount of random spawns should be ATLEAST 5 less than the amount of saved spawns.) (<-- mainly for efficiency and etc, BUT amount of random spawns SHOULD NEVER be equal or more than amount of saved NPC's)
GEN_STORE.amountofrandomspawns = 3

-- What should the model be for the NPC? (Default: models/Humans/Group01/male_09.mdl)
GEN_STORE.npcmodel = "models/Humans/Group01/male_09.mdl"

-- Should the robbery alarm sound play if the store is being robbed? (Default: true) (~30 seconds)
GEN_STORE.robsound = true



--***LANG CONFIG***
-- What lang you want? Possible: "english" (more to come...hopefully)
GEN_STORE.lang = "english"