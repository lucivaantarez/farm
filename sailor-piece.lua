script_key="aDgJnOlAuVtVVAGGAjzULYXrBcFtQyHB";
getgenv().SailorPieceConfig = {
    ---------- [ FARMING ] ----------
    AutoRejoinIfHighRam = 5000,
    AutoFarm         = true,          -- Auto đánh mob + làm quest
    AutoQuest        = true,          -- Auto nhận/hoàn thành quest
    AutoStats        = true,          -- Auto nâng stat (Melee -> Sword/Power/Defense)
    AutoBuyWeapons   = true,          -- Auto mua Katana & Dark Blade khi đủ tiền
    AutoSaber        = true,          -- Auto farm Saber Boss khi lv3000+ có Boss Key + đủ tiền
    AutoIchigo       = true,          -- Auto exchange Ichigo khi đủ 500 Boss Ticket
    AutoHaki         = true,          -- Auto farm quest Haki 
    AutoHogyoku      = true,          -- Auto làm Hogyoku quest unlock Soul Society (lv8500+)
    AutoDungeon      = true,          -- Auto làm Dungeon quest unlock (lv5000+)
    AutoAscend       = true,          -- Auto ascend khi đủ điều kiện
    AutoRedeemCodes  = true,          -- Auto nhập code
    DisablePvP       = true,          -- Tắt PvP trong settings
    AutoOpenChest    = true,          -- Auto mở chest
    OpenChests       = {              -- Danh sách chest muốn mở
        "Common Chest",
        "Rare Chest",
        "Epic Chest",
        "Legendary Chest",
    },
    AutoBlessing     = true,          -- Auto bless vũ khí đang cầm (tự detect)
    AutoReroll       = true,          -- Auto dùng Race/Clan Reroll
    TargetRace       = "Kitsune",     -- Race mục tiêu (dừng khi đạt)
    TargetClan       = "Monarch",     -- Clan mục tiêu (dừng khi đạt)
    AutoTraitReroll  = true,          -- Auto reroll trait đến khi đạt rarity mục tiêu
    TargetTraitRarity = "Secret",     -- Rarity mục tiêu: Secret/Mythical/Legendary/Epic
    AutoMerchant     = true,          -- Auto mua item từ Merchant
    AutoEquipTitle   = true,          -- Auto equip title cao nhất
    AutoEquipAccessory = true,        -- Auto equip accessory mạnh nhất
    AutoEquipArtifact = true,         -- Auto equip artifact rarity cao nhất per slot
    AutoSkillTree    = true,          -- Auto unlock & upgrade skill tree
    SkillTreePriority = {"Luck", "Damage", "CritChance", "CritDamage", "HP"},
    WebhookURL       = "https://discord.com/api/webhooks/1484989763399323679/RdEkKYN9PC2BskfGrRYnCMLxQksGP185e_uHzdG6EolqCUZKm6grkp5jex6JWeQmjiMy",
    FPSBoost         = true,          -- Tối ưu FPS (giảm lag)
    FPSLock          = 10,            -- Khóa FPS 
    HideMobVFX       = true,           -- Ẩn hiệu ứng chiêu thức/vũ khí của mob & boss
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/1169527463a6fb002d07c345110bc0aa.lua"))()
