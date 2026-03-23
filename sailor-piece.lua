script_key="aDgJnOlAuVtVVAGGAjzULYXrBcFtQyHB";
getgenv().SailorPieceConfig = {
    AutoRejoinIfHighRam = 5000,
    OpenChests       = {              -- Danh sách chest muốn mở
        "Common Chest",
        "Rare Chest",
        "Epic Chest",
        "Legendary Chest",
        "Mythical Chest",
    },
    TargetRace       = "Kitsune",     -- Race mục tiêu (dừng khi đạt)
    TargetClan       = "Monarch",     -- Clan mục tiêu (dừng khi đạt)
    WebhookURL       = "https://discord.com/api/webhooks/1484989763399323679/RdEkKYN9PC2BskfGrRYnCMLxQksGP185e_uHzdG6EolqCUZKm6grkp5jex6JWeQmjiMy",             -- Discord Webhook URL (để trống = tắt)
    FPSBoost         = true,          -- Tối ưu FPS (giảm lag)
    FPSLock          = 10,            -- Khóa FPS 
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/1169527463a6fb002d07c345110bc0aa.lua"))()
