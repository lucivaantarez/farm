--[[
    Auto Trade (Gom Item) - Sailor Piece
    Chạy trên CẢ 2 acc: clone gửi trade + add item, main tự accept + ready + confirm
]]
script_key="aDgJnOlAuVtVVAGGAjzULYXrBcFtQyHB";
getgenv().AutoTradeConfig = {
    -- Tên acc main
    MainAccount = "mimabau1904",

    -- Danh sách tên item muốn trade 
    Items = {
        "Race Reroll",
        "Clan Reroll",
        "Mythical Chest",
        "Aura Crate",
        "Cosmetic Crate",
        "Trait Reroll",
        "Abyss Sigil",
        "Broken Sword",
        "Passive Shard",
    },
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/75c7fe88bf77410a404199a69629aae3.lua"))()
