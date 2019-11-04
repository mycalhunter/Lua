local minerals = { -- change in client also
    {name = "Iron", clow = 0.0, chigh = 0.7, profit = 105, procname = "Iron Bar(s)", type = 1}, -- old 165
    {name = "Gold", clow = 0.71, chigh = 0.95, profit = 190, procname = "Gold Bar(s)", type = 2}, -- old 260
}
local ctf = {low = 0.1, high = 1.0}
local rentalCost = 2500
local rentalDeposit = 1000

RegisterServerEvent("bms:jobs:shipwreck:finishSalvaging")
AddEventHandler("bms:jobs:shipwreck:finishSalvaging", function()
    local src = source
    math.randomseed(os.time())
    local rnd = math.random()
    local match
    for _, v in pairs(minerals) do
        if (rnd > v.clow and rnd < v.chigh) then
            match = v
        end
    end
    if (not match) then -- fallback
        match = minerals[math.random(1, #minerals)]
    end
    if (match) then
        local rc = math.random()
        -- print(string.format("mining chance: %s, item: %s, low: %s, high: %s", rc, match.name, ctf.low, ctf.high))
        local success = rc > ctf.low
        local randAmt = math.random(2, 4)
        if (success) then
            TriggerEvent("bms:mining:checkMaxCap", src, function(allow)
                if (allow) then
                    TriggerEvent("bms:addCharacterInvItemWithCallback", src, match.name, randAmt, "bms:jobs:shipwreck:salvageComplete")
                    TriggerEvent("bms:crafting:increaseSkill", src, 2, true)
                    TriggerClientEvent("pNotify:SendNotification", src, {text = string.format("You have found " .. randAmt .. " <font color='limegreen'>%s</font> scraps.", match.name), timeout = 7000})
                    TriggerEvent("bms:management:updateAnalytics", match.name .. " mined", randAmt)
                else
                    TriggerClientEvent("pNotify:SendNotification", src, {text = "You can not carry any more scraps."})
                    TriggerClientEvent("bms:jobs:shipwreck:salvageComplete", src)
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", src, {text = "You did not find any valuable scraps."})
            TriggerClientEvent("bms:jobs:shipwreck:salvageComplete", src)
        end
    end
end)

RegisterServerEvent("bms:jobs:shipwreck:rentvehicle")
AddEventHandler("bms:jobs:shipwreck:rentvehicle", function()
    local src = source
    local user
    TriggerEvent("es:getPlayerFromId", src, function(user)
        if (user) then
            local money = user.get("charMoney")
            if (money >= rentalCost) then
                exports.characters:takeMoneyFromChar(user, rentalCost, string.format("Player %s (%s) has paid %s for a submersible rental.", user.get("activeChar"), user.getIdentifier(), rentalCost))
                TriggerClientEvent("bms:jobs:shipwreck:rentvehiclecomplete", src, rentalCost, true)
            else
                TriggerClientEvent("bms:jobs:shipwreck:rentvehiclecomplete", src, rentalCost, false)
            end
        end
    end)
end)

RegisterServerEvent("bms:jobs:shipwreck:returnvehicle")
AddEventHandler("bms:jobs:shipwreck:returnvehicle", function()
    local src = source
    local user
    TriggerEvent("es:getPlayerFromId", src, function(user)
        if (user) then
            local money = user.get("charMoney")
            exports.characters:giveMoneyToChar(user, rentalDeposit, string.format("Player %s (%s) has received %s for a submersible deposit.", user.get("activeChar"), user.getIdentifier(), rentalDeposit))
            TriggerClientEvent("bms:jobs:shipwreck:returnvehiclecomplete", src, rentalDeposit, true)
        end
    end)
end)