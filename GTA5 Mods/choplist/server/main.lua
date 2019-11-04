ESX = nil
local xPlayers = 0
local xPlayer = 0
local playerName = ""
local s = source
local amount = 0
local getBank = 0
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('choplistjob')
AddEventHandler('choplistjob', function(payout) --receive payout/amount from client script
  xPlayers = ESX.GetPlayers()
  for i = 1, #xPlayers, 1 do
    xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    playerName = xPlayer.name
    if xPlayer.job.name == 'unemployed' then
      --amount = 5000
      payout = math.floor(payout)
      getBank = xPlayer.getBank()
      xPlayer.setBankBalance(getBank + payout)
      Citizen.Wait(1)
      TriggerClientEvent('pNotify:SendNotification', -1, {text = 'You have been paid <font color="#50b64e">$' .. payout .. '</font> for your delivery. Speak to Vinny for another order.', type = "info", timeout = 5000, layout = "centerRight"})
    end
  end
end)