-- English Config (m_gen_store)
-- Translation made by: Matthew (Creator)

GEN_STORE_LANG.robstoreremove = "Store removed, robbery failed."
GEN_STORE_LANG.robstorekilled = "You have been killed, robbery failed."
GEN_STORE_LANG.robstorekilledgov = "You have killed the robber and have been rewarded: "
GEN_STORE_LANG.robstoredc = "Robber disconnected, robbery failed."
GEN_STORE_LANG.robstoredist = "You have traveled to far from the robbery, robbery failed."
GEN_STORE_LANG.robstorejobchange = "Robber changed jobs, robbery failed."
GEN_STORE_LANG.robstoresuccess = "You have robbed the general store for "
GEN_STORE_LANG.robstoreevent = "An event is starting, robbery stopped."

GEN_STORE_LANG.concannotuse = "[GEN STORE] You can not use this command!"
GEN_STORE_LANG.constoresaved = "[GEN STORE] Stores have been saved! Amount saved: "
GEN_STORE_LANG.conspawnstorefail = "[GEN STORE] The save command must be run before using this command!"
GEN_STORE_LANG.conspawnremoveall = "[GEN STORE] Remove all Gen Store NPCs before using this command. (HINT: Use 'gen_store_clear' then use 'gen_store_spawn')"
GEN_STORE_LANG.conspawned = "[GEN STORE] NPC Spawned "
GEN_STORE_LANG.confailautospawn = "[GEN STORE] No NPCs have been saved, use the save command to save the NPCs to the map!"
GEN_STORE_LANG.conspawnsuccess = "[GEN STORE] All NPCs under saved data has been spawned. (HINT: You must restart the server for random spawns!)"
GEN_STORE_LANG.conclearsuccess = "[GEN STORE] All Gen Stores have been removed! (HINT: Now you may use the spawn command 'gen_store_spawn')"
GEN_STORE_LANG.conadmindonotspam = "[GEN STORE] Cooldown"
GEN_STORE_LANG.coneventdone = "[GEN STORE] Complete!"
GEN_STORE_LANG.concomplete = "[GEN STORE] COMPLETE"
GEN_STORE_LANG.conloading = "[GEN STORE] LOADING"
GEN_STORE_LANG.connotenoughsave = "[GEN STORE] The amount of saved NPC's is less than or equal to the amount of random spawned NPC's, so random spawns has been stopped to prevent server from not loading."

GEN_STORE_LANG.eventmenutext1 = "General Store has been locked for an event."
GEN_STORE_LANG.eventmenutext2 = "Contact server staff if you believe this is not correct!"

GEN_STORE_LANG.govnotifytop = "Robbery Alert"
GEN_STORE_LANG.govnotifycancel = "Cancel"
GEN_STORE_LANG.govnotifyrespond = "Respond"
GEN_STORE_LANG.govnotifylocation = "ROBBERY"
GEN_STORE_LANG.govnotifyhere = "On Scene"
GEN_STORE_LANG.govnotifydist = "Distance: "
GEN_STORE_LANG.govnotifydistamount = " ft"

GEN_STORE_LANG.notifbuyfail = "Purchase failed!"
GEN_STORE_LANG.notifbuycomplete = "Purchase Complete!"
GEN_STORE_LANG.notifspam = "Buy Cooldown"
GEN_STORE_LANG.notifinvalid = "Invalid Entity"

GEN_STORE_LANG.inspecttop = "Inspect"
GEN_STORE_LANG.inspectmodel = "Click to view the Model! You can drag to move the model!"

GEN_STORE_LANG.robmenumain = "ROBBERY IN PROGRESS"

GEN_STORE_LANG.adminmenubutton = "Admin Panel"
GEN_STORE_LANG.adminmenutop = "Admin Controls"
GEN_STORE_LANG.adminmenuhint = "These commands can also be used in console!"
GEN_STORE_LANG.admineventmenuremove = "Remove Event Lock"
GEN_STORE_LANG.adminconfigmenu = "Config Menu"
GEN_STORE_LANG.admincofigmenuapply = "Apply Change"
GEN_STORE_LANG.adminconfigmenuremove = "Remove Item"
GEN_STORE_LANG.adminmenuconbutton = {
    "Save all General Stores",
    "Spawn all General Stores",
    "Delete all General Stores",
    "Lock all General Stores for an Event",
    "gen_store_save", -- do not edit
    "gen_store_spawn", -- do not edit
    "gen_store_clear", -- do not edit
    "gen_store_event_lock" -- do not edit
}

GEN_STORE_LANG.adminconfigmenuselect = "Select"
GEN_STORE_LANG.adminconfigitemaddnew = "*** Add New ***"
GEN_STORE_LANG.adminconfigitemaddnewhint = "Enter Name, then find the new name in the drop box"
GEN_STORE_LANG.adminconfigitemeditthis = "Edit This"
GEN_STORE_LANG.adminconfigitemsortorder = "Sort Order: "
GEN_STORE_LANG.adminconfigmenunav = {
    "Items",
    "Store",
    "Robbery",
    "Categories"
}
GEN_STORE_LANG.adminconfigitemhints = {
    "Classname depends on item type, if its weapon/entity put the code of the item in the text box.",
    "If it's health or armor, then place the amount you want to give the player. Modelpath will not",
    "effect the item if item is health or armor."
}
GEN_STORE_LANG.adminconfigitemchangers = {
    "Name",
    "Classname",
    "Description",
    "Item Type",
    "Category",
    "Model Path",
    "Price",
    "VIP Only?",
    "Order"
}
GEN_STORE_LANG.adminconfigtypes = {
    "weapon",
    "entity",
    "health",
    "armor"
}
GEN_STORE_LANG.adminconfigstorehints = {
    "Values in sliders are the % of the price that will be shown!!!",
    "Example: .90 is ONLY 10% off the price",
    "Or in rob bonus, .50 is 50% more money for the robber."
}
GEN_STORE_LANG.adminconfigstoreitems = {
    "CP Discount",
    "VIP Discount",
    "VIP Rob Bonus",
    "HP/Armor Max"
}
GEN_STORE_LANG.adminconfigstorechangers = {
    "CP Discount",
    "VIP Discount",
    "VIP Rob Bonus",
    "Health Max",
    "CP Discount Amount",
    "VIP Discount Amount",
    "VIP Rob Bonus Amount",
    "Armor Max"
}
GEN_STORE_LANG.adminconfigrobhints = {
    "Make sure not to add any letters to any text boxes!",
    "If you don't want something, set to 0, unless there is a true/false for it."
}
GEN_STORE_LANG.adminconfigrobchangers = {
    "Rob Button",
    "Rob Time",
    "Rob Cooldown",
    "Rob Only One",
    "Rob Money Amount",
    "Robber Progress Bar",
    "Amount of CP To Rob",
    "Max Rob Distance",
    "Rob Distance Warn",
    "CP Kill Reward",
    "CP Notify",
    "CP Notify Timer",
    "CP Notify Distance Timer"
}
GEN_STORE_LANG.adminconfigcategoryhint = "The first category in the sort order will show all items."
GEN_STORE_LANG.adminconfigremovecategory = "Remove Category"
GEN_STORE_LANG.adminconfigcategorychangers = {
    "Name",
    "Color"
}
GEN_STORE_LANG.defaultstoreitems = {
    {"Pistol", "This is a 9mm pistol. The is made by Glock.", "Weapons"},
    {"Pistol Ammo", "Gives you 20 rounds of pistol ammo.", "Ammo"},
    {"50 Health", "Health & Armor"},
    {"50 Armor", "Health & Armor"}
}
GEN_STORE_LANG.defaultstorecategories = {
    "All Items",
    "Weapons",
    "Ammo",
    "Health & Armor"
}


GEN_STORE_LANG.mainmenurob = "START ROBBERY"
GEN_STORE_LANG.mainmenucooldown = "Robbery Cooldown"
GEN_STORE_LANG.mainmenunotenoughgov = "Not Enough CP"
GEN_STORE_LANG.mainmenuanotherstore = "Another Robbery"
GEN_STORE_LANG.mainmneuseconds = " seconds left"

GEN_STORE_LANG.mainmenubuy = "Purchase"
GEN_STORE_LANG.mainmenucantbuy = "Can't Afford"
GEN_STORE_LANG.mainmenuviponly = "VIP Only"

GEN_STORE_LANG.robberbartop = "Robbery Progress"
GEN_STORE_LANG.robberdistwarn = "DISTANCE WARNING"

GEN_STORE_LANG.overhead = "General Store"
GEN_STORE_LANG.overheadboxsize = 180
-- ^^ Might need to change based on lang

-- To Downloader Dude/Lady: You can change this obviously, I suggest something like your community name or etc. :)
GEN_STORE_LANG.topbar = "General Store"