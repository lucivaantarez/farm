script_key="aDgJnOlAuVtVVAGGAjzULYXrBcFtQyHB";
getgenv().SailorPieceConfig = getgenv().SailorPieceConfig or {
    OpenChests       = {
        "Common Chest",
        "Rare Chest",
        "Epic Chest",
        "Legendary Chest",
    },
    AutoAscend = true,
    AutoUpgradeAscend = true,
    Debug            = false,
    Performance = {
        AutoRejoinIfHighRam = 5000,
        WebhookURL      = "https://discord.com/api/webhooks/1489367505226170430/3W21u4vaWuzWM4Mi7vf9e_jKm_XiTWh9x3GVGAFjqkIKQhErWNd4Ex_ohmoBfE0W1M7w",
        FPSBoost        = true,
        FPSLock         = 10,
    },
    SkillTree = {
        Auto            = true,
        Priority        = {"Luck", "Damage", "CritChance", "CritDamage", "HP"},
    },
    AutoStrongestMelee = true,
    Reroll = {
        Trait = {
            Auto            = true,
            TargetRarity    = "Secret",
        },
        TargetRace      = {"Kitsune"},
        TargetClan      = {"Eminence", "Monarch"},
        },
    Artifact = {
        AutoEquip       = true,
        AutoUpgrade     = true,
        AutoDeleteTrash = true,
        UpgradeSet      = {"Celestial Rupture"},-- Ashen Chronicles, Crownless Regalia, Black Horizon, Void Reaver, Celestial Rupture, Abyssal Crown
        UpgradeStopAt   = 15,
        TrashRarities   = {"Common", "Rare", "Epic"},
    },
}
while true do
    local success = pcall(function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/1169527463a6fb002d07c345110bc0aa.lua"))()
    end)
    if success then break end
    task.wait(5)
end
