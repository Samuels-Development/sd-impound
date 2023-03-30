local QBCore = exports['qb-core']:GetCoreObject()

local function getPlayerFullName(player)
    return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
end

local function deleteVehicle(playerSrc)
    local success = false
    TriggerClientEvent('QBCore:Command:DeleteVehicle', playerSrc, function(result)
        success = result
    end)
    return success
end

local function createLog(source, logType, logMsg)
    local player = QBCore.Functions.GetPlayer(source)
    local playerName = getPlayerFullName(player)
    TriggerEvent('qb-log:server:CreateLog', 'default', logType, "lightgreen", playerName .. ' ' .. logMsg)
end

RegisterServerEvent('sd-impound:server:VehicScuff', function()
    local playerSrc = source
    local success = deleteVehicle(playerSrc)
    if success then
        createLog(playerSrc, 'Scuff Impound', ' has scuff impounded a vehicle.')
        TriggerClientEvent('QBCore:Notify', playerSrc, 'Impound Request Accepted.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', playerSrc, 'Failed to impound vehicle.', 'error')
    end
end)

RegisterServerEvent('sd-impound:server:ParkingViolation', function()
    local playerSrc = source
    local player = QBCore.Functions.GetPlayer(playerSrc)
    if player.PlayerData.job.name ~= "police" then
        TriggerClientEvent('QBCore:Notify', playerSrc, 'You are not a police officer.', 'error')
        return
    end
    local success = deleteVehicle(playerSrc)
    if success then
        createLog(playerSrc, 'Parking Violation', ' has impounded a vehicle for a parking violation.')
        TriggerClientEvent('QBCore:Notify', playerSrc, 'Impound Request Accepted.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', playerSrc, 'Failed to impound vehicle.', 'error')
    end
end)

RegisterServerEvent('sd-impound:server:PDImpound', function()
    local playerSrc = source
    local player = QBCore.Functions.GetPlayer(playerSrc)
    if player.PlayerData.job.name ~= "police" then
        TriggerClientEvent('QBCore:Notify', playerSrc, 'You are not a police officer.', 'error')
        return
    end
    local success = TriggerClientEvent("police:client:ImpoundVehicle", playerSrc, true)
    if success then
        createLog(playerSrc, 'Police Impound', ' has sent a vehicle to police Impound.')
        TriggerClientEvent('QBCore:Notify', playerSrc, 'Impound Request Accepted.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', playerSrc, 'Failed to impound vehicle.', 'error')
    end
end)