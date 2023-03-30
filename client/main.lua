local QBCore = exports['qb-core']:GetCoreObject()
local targetBones = {'bonnet', 'boot'}

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetBone(targetBones, {
        options = {
            ["Impound"] = {
                icon = "fas fa-lock",
                label = "Impound Request",
                event = "sd-impound:client:OpenImpoundMenu",
                distance = 1.3
            }
        }
    })
end)

local menuOptions = {
    {
        header = "Vehicle Scuff",
        txt = "Vehicle in an unrecoverable state.",
        params = {
            event = "sd-impound:client:VehicleScuff",
        }
    },
    {
        header = "Parking Violation",
        txt = "Vehicle parked in a restricted or unauthorized place.",
        params = {
            event = "sd-impound:client:ParkingViolation",
        }
    },
    {
        header = "Police Impound",
        txt = "Sends vehicle to Police impound lot.",
        params = {
            event = "sd-impound:client:PDImpound",
        }
    }
}

RegisterNetEvent('sd-impound:client:OpenImpoundMenu', function()
    exports['qb-menu']:openMenu(menuOptions)
end)

local function requestImpound(eventName)
    QBCore.Functions.Progressbar("random_task", "Requesting Impound...", 7000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
     }, {
     }, {}, {}, function() -- Done
        TriggerServerEvent(eventName)
     end, function() -- Cancel
     end)
end

RegisterNetEvent('sd-impound:client:VehicleScuff', function()
    requestImpound("sd-impound:server:VehicScuff")
end)

RegisterNetEvent('sd-impound:client:ParkingViolation', function()
    requestImpound("sd-impound:server:ParkingViolation")
end)

RegisterNetEvent('sd-impound:client:PDImpound', function()
    requestImpound("sd-impound:server:PDImpound")
end)