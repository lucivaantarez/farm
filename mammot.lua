script_key="";
setfpscap(10)

getgenv().sailorPieceConfig = {  
    AUTO_UPDATE_RESTART = true,
    
    MULTI_FARM = { "ArenaFighter", "Ninja", "Swordsman", "AcademyTeacher", "Slime", "Curse", "StrongSorcerer", "Hollow" },  -- Instant tp kill npc

    DO_REPEATABLE_QUEST = "QuestNPC19",
    AUTO_FARM = { "Jinwoo Boss", "Alucard Boss", "Yuji Boss", "Gojo Boss", "Sukuna Boss", "Anos Boss", "Aizen Boss", "Strongest of Today Boss", "Strongest in History Boss", "Rimuru Boss", "Saber Boss", "QinShi Boss", "Ichigo Boss" },  
    SUMMON_BOSS = { "Ichigo", "Qin Shi", "Saber" },

    EQUIP_SWORD = { "Ichigo", "Gryphon", "Dark Blade", "Katana" },
    BLESS_WEAPON = { ["Ichigo"] = 10, ["Gryphon"] = 6, ["Dark Blade"] = 3 },

    STAT_POINT_PERCENTAGE = { ["Sword"] = 90, ["Defense"] = 10, ["Melee"] = 0, ["Power"] = 0 },
    USE_ITEM = { "Common Chest", "Rare Chest", "Epic Chest", "Legendary Chest", "Mythical Chest", "Aura Crate (Untradeable)", "Cosmetic Crate (Untradeable)", "Secret Chest (Untradeable)" },
    BUY_MERCHANT = { "Clan Reroll" },

    REROLL_RACE_UNTIL = "Kitsune",
    REROLL_CLAN_UNTIL = { "Monarch", "Eminence" },
    REROLL_TRAIT_UNTIL = { "Overlord", "Cataclysm", "Singularity", "Celestial", "Emperor" },
    REROLL_STAT_UNTIL = { ["Damage"] = "S", ["Defense"] = "S", ["CooldownReduction"] = "S", ["CritChance"] = "S", ["CritDamage"] = "S", ["DamageReduction"] = "S", ["Luck"] = "SSS" },
    REROLL_PASSIVE_UNTIL = { ["Gryphon"] = { "Fortune Chosen", "Executioner", "Damage V" }, ["Ichigo"] = { "Fortune Chosen", "Executioner", "Damage V" } },
    REROLL_POWER_UNTIL = { "Cursebrand", "Colossus", "Eternal", "Abyssal", "Apex" },

    DELETE_ARTIFACT_RARITY = { "Common", "Rare" },
    EQUIP_ARTIFACT_SET = "Celestial Rupture",

    -- Autotrade
    TRADE_USERNAME = "FinnIsabellaYT789",
    TRADE_ITEM = {},

    -- Discord
    WEBHOOK_ITEM_NAME = { "Aura Crate", "Cosmetic Crate" },
    WEBHOOK_URL = "",
    DISCORD_ID = "",
    WEBHOOK_NOTE = "",
    SHOW_PUBLIC_DISCORD_ID = false,
    SHOW_WEBHOOK_USERNAME = true,
    SHOW_WEBHOOK_JOBID = false,
}   

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/1c7ac2a2f86ecf894218a424a1be7667.lua"))()
