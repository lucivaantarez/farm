script_key="YrMGlHVZJYWpvtBaeKtZJOAtEBmcQbkQ";
setfpscap(10)

getgenv().sailorPieceConfig = {  
    AUTO_UPDATE_RESTART = true,
    
    MULTI_FARM = { "ArenaFighter", "Ninja", "Swordsman", "AcademyTeacher", "Slime", "Curse", "StrongSorcerer", "Hollow" },  -- Instant tp kill npc

    DO_REPEATABLE_QUEST = "QuestNPC19",
    AUTO_FARM = { "Jinwoo Boss", "Alucard Boss", "Yuji Boss", "Gojo Boss", "Sukuna Boss", "Anos Boss", "Aizen Boss", "Strongest of Today Boss", "Strongest in History Boss", "Rimuru Boss", "Saber Boss", "QinShi Boss", "Ichigo Boss" },  
    SUMMON_BOSS = { "Ichigo", "Qin Shi", "Saber" },

    EQUIP_WEAPON = { "Strongest in History", "Ichigo", "Gryphon", "Dark Blade", "Katana" },
    BLESS_WEAPON = { ["Strongest in History"] = 10, ["Ichigo"] = 10, ["Gryphon"] = 6, ["Dark Blade"] = 3 },

    STAT_POINT_PERCENTAGE = { ["Sword"] = 90, ["Defense"] = 10, ["Melee"] = 0, ["Power"] = 0 },
    USE_ITEM = { "Common Chest", "Rare Chest", "Epic Chest", "Legendary Chest", "Aura Crate (Untradeable)", "Cosmetic Crate (Untradeable)", "Secret Chest (Untradeable)" },
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
    TRADE_USERNAME = { "FinnIsabellaYT789" },
    TRADE_ITEM = { "Race Reroll", "Clan Reroll", "Trait Reroll", "Haki Color Reroll", "Mythical Chest", "Secret Chest", "Aura Crate", "Cosmetic Crate", "Infinity Essence", "Blue Singularity", "Reversal Pulse", "Cursed Flesh", "Divine Grail", "Throne Remnant", "Ancient Shard", "Golden Essence", "Phantasm Core", "Broken Sword", "Azure Heart", "Silent Storm", "Yamato Essence", "Frozen Will", "Chrysalis Sigil", "Evolution Fragment", "Transcendent Core", "Fusion Ring", "Worthiness Fragment", "Hogyoku Frag", "Mirage Pendant", "Illusion Prism", "Reiatsu Core", "Boss Ticket", "Upper Seal", "Moon Crest", "Crescent Shard", "Lunar Essence", "Demon Remnant", "Abyss Sigil", "Atomic Core", "Atomic Omen", "Eminence Essence", "Shadow Remnant", "Magic Shard", "Void Seed", "Rush Key", "Umbral Capsule", "Dungeon Ticket", "Monarch Core", "Monarch Essence", "Kamish Dagger", "Shadow Crystal", "Abyss Edge", "Dark Ring", "Shadow Heart", "Dark Grail", "Corrupt Crown", "Corruption Core", "Alter Essence", "Morgan Remnant", "Cursed Finger", "Dismantle Fang", "Crimson Heart", "Battle Sigil", "Path Fragment", "Eternal Core", "Power Remnant", "Tempest Relic", "Sage Pulse", "Tempest Seal", "Slime Remnant", "Slime Core", "Calamity Seal", "Boss Rush Ticket", "Dungeon Key", "Tower Key", "Boss Key", "Passive Shard", "Power Shard", "Imperial Seal", "Jade Tablet", "Tide Remnant", "Gale Essence" },

    -- Discord
    WEBHOOK_ITEM_NAME = { "Aura Crate", "Cosmetic Crate" },
    WEBHOOK_URL = "https://discord.com/api/webhooks/1489367505226170430/3W21u4vaWuzWM4Mi7vf9e_jKm_XiTWh9x3GVGAFjqkIKQhErWNd4Ex_ohmoBfE0W1M7w",
    DISCORD_ID = "",
    WEBHOOK_NOTE = "",
    SHOW_PUBLIC_DISCORD_ID = false,
    SHOW_WEBHOOK_USERNAME = true,
    SHOW_WEBHOOK_JOBID = false,
}   

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/1c7ac2a2f86ecf894218a424a1be7667.lua"))()
