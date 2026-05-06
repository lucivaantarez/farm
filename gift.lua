script_key="YrMGlHVZJYWpvtBaeKtZJOAtEBmcQbkQ";
setfpscap(10)

getgenv().sailorPieceConfig = {  
    OPTIMIZATION = true,  -- true = optimize + show ui, false = disable ui
    AUTO_KICK = true,  -- Autokick if no TRADE_ITEM items left
    KICK_IF_NO_TRADE_USERNAME = true,
    TRADE_SEA_1 = true,
    TRADE_USERNAME = { "aduhhhbrisik" },  -- "Username"
    TRADE_ITEM = {        
        "Ancient Fragment",
        "Ancient Shard",
        "Atomic Core",
        "Aura Crate",
        "Azure Heart",
        "Blood Ring",
        "Bloodline Stone",
        "Broken Sword",
        "Clan Reroll",
        "Cosmetic Crate",
        "Cosmic Essence",
        "Crystal Key",
        "Dominion Brand",
        "Dungeon Ticket",
        "Easter Egg",
        "Easter Key",
        "Galaxy Shard",
        "Infinity Essence",
        "Magic Essence",
        "Magic Shard",
        "Mana Core",
        "Monster Pulse",
        "Mythical Chest",
        "Passive Shard",
        "Power Shard",
        "Relic Part #1",
        "Relic Part #2",
        "Relic Part #3",
        "Relic Part #4",
        "Relic Part #5",
        "Relic Part #6",
        "Relic Part #7",
        "Relic Part #8",
        "Secret Chest",
        "Soul Flame",
        "Spell Echo",
        "Star Mark",
        "Time Remnant",
        "Vampire Omen",
        "Void Fragment",
        "World Core",
    },

    WEBHOOK_URL = "https://discord.com/api/webhooks/1498122446732001282/V24aQC79oRA5-Dff2gYXyk3S6O5f79xDBojoxu_g3p0gnV8rijSzoaw6vgY5Yac6TKvu",
    DISCORD_ID = "285071154300059648",
    WEBHOOK_NOTE = "",
    SHOW_WEBHOOK_USERNAME = true,
    SHOW_WEBHOOK_JOBID = false,
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/eb9a467b35fe098d20677eb16ec559a4.lua"))()
