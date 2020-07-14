RegisterCommand("save", function(source)
  
  MySQL.Async.fetchAll("INSERT INTO main (id, name, inventory, cash, dirtycash, faction) VALUES (@source, @name, @inventory, @cash, @dirtycash, @faction)",
  {
    ["@source"] = source,
    ["@name"] = GetPlayerName(source),
    ["@inventory"] = "{}",
    ["@cash"] = 500,
    ["@dirtycash"] = 0,
    ["@faction"] = "default"
  },
  function(result)
    TriggerClientEvent("output", source)
  end)
end)