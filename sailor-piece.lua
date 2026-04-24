script_key="YrMGlHVZJYWpvtBaeKtZJOAtEBmcQbkQ";
setfpscap(60)

getgenv().sailorPieceConfig = {  
    AUTO_UPDATE_RESTART = true,
    ASCEND_UNTIL_LEVEL = 10,
    WORLD = "Sea 2",
    AUTO_CELESTIAL_FAVOR_TITLE = true, -- Auto attack 5000 island bosses
    AUTO_BOSS_RUSH_AND_INFINITE_STAT_BONUS = true,
    
    -- Autofarm
    DO_REPEATABLE_QUEST = "QuestNPC23",
    -- MULTI_FARM -> Instant tp kill npc (Must have Strongest In History/Ichigo/Gryphon)
    MULTI_FARM = { "Bunny", "Quincy", "FastNinja", "StrongBandit", "StrongFighter", "Delinquent", "Bunny", "ArenaFighter", "Ninja", "Swordsman", "AcademyTeacher", "Slime", "StrongSorcerer", "Curse", "Hollow", "Sorcerer", "FrostRogue", "DesertBandit", "Monkey", "Thief" },  
    AUTO_FARM = { "Great Mage Boss", "Cosmic Being", "The World Boss", "True Manipulator Boss", "Strongest Shinobi Boss", "Corrupted Knight Boss", "Yamato"},  -- Auto farm ascend/quest/weapon bosses 
    SUMMON_BOSS = { "True Manipulator Normal" },  -- Auto summon ascend/quest/weapon bosses
    
    -- Weapons
    BUY_WEAPON = {"Katana", "Dark Blade", "Gryphon", "Ichigo", "Strongest In History", "Ice Queen", "Cosmic Being", "The World" },
    BLESS_WEAPON = { ["Cosmic Being"] = 10, ["The World"] = 10, ["Ice Queen"] = 10, ["Strongest In History"] = 10, ["Ichigo"] = 6, ["Gryphon"] = 6, ["Dark Blade"] = 3 },

    -- Reroll
    REROLL_RACE_UNTIL = { "Luckborn" },
    REROLL_CLAN_UNTIL = { "Eminence" },
    REROLL_TRAIT_UNTIL = { "Emperor" },
    REROLL_STAT_UNTIL = { 
        ["Damage"] = "Z", 
        ["Defense"] = "Z", 
        ["CooldownReduction"] = "Z", 
        ["CritChance"] = "Z", 
        ["CritDamage"] = "Z", 
        ["DamageReduction"] = "Z", 
        ["Luck"] = "Z" 
    },
    REROLL_PASSIVE_UNTIL = { 
        ["Cosmic Being"] = { "Fortune Chosen", "Executioner", "Rampage" }, 
        ["The World"] = { "Fortune Chosen", "Executioner", "Rampage" }, 
        ["Ice Queen"] = { "Fortune Chosen", "Executioner", "Rampage" }, 
        ["Strongest In History"] = { "Fortune Chosen" }, 
        ["Ichigo"] = { "Fortune Chosen", "Executioner", "Rampage", "Damage V", "Damage IV" } 
    },
    REROLL_POWER_UNTIL = { "Subjugator" },
    REROLL_BLOODLINE_UNTIL = { "Primordial" },

    -- Artifact
    DELETE_ARTIFACT_RARITY = { "Common" },
    EQUIP_ARTIFACT_SET = "Abyssal Crown",

    -- Misc
    BUILD_MODE = "Damage",  -- Damage/Luck
    USE_ITEM = { "Common Chest", "Rare Chest", "Epic Chest", "Legendary Chest", "Aura Crate (Untradeable)", "Cosmetic Crate (Untradeable)", "Secret Chest (Untradeable)" },
    BUY_MERCHANT = { "Race Reroll", "Trait Reroll", "Clan Reroll", "Passive Shard", "Boss Key", "Dungeon Key", "Rush Key", "Boss Ticket", "Haki Color Reroll", "Common Chest", "Rare Chest", "Epic Chest", "Legendary Chest", "Mythical Chest", "Secret Chest" },

    -- Autotrade
    TRADE_USERNAME = {},
    TRADE_ITEM = {},
    
    -- Discord
    WEBHOOK_ITEM_NAME = { "" },
    WEBHOOK_URL = "",
    DISCORD_ID = "",
    WEBHOOK_NOTE = "",
    SHOW_PUBLIC_DISCORD_ID = false,
    SHOW_WEBHOOK_USERNAME = false,
    SHOW_WEBHOOK_JOBID = false,
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/1c7ac2a2f86ecf894218a424a1be7667.lua"))()
