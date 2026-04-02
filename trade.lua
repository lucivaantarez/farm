script_key="";
getgenv().AutoTradeConfig = {
    -- Danh sách acc main (display name hoặc username) - hỗ trợ nhiều acc
    MainAccounts = {
        "mimabau1904",
        -- thêm acc main ở đây, ví dụ:
        -- "AccMain2",
        -- "AccMain3",
    },

    -- Danh sách tên item muốn trade (chỉ cần tên, tự detect category + max quantity)
    Items = {
        "Race Reroll",
        "Clan Reroll",
        "Mythical Chest",
        "Aura Crate",
        "Cosmetic Crate",
        "Trait Reroll",
    },
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/75c7fe88bf77410a404199a69629aae3.lua"))()
