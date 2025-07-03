local lastHealth = nil
local lastArmor = nil

CreateThread(function()
    while true do
        Wait(100)

        local playerPed = cache.ped
        local currentHealth = GetEntityHealth(playerPed)
        local currentArmor = GetPedArmour(playerPed)

        if lastHealth and lastArmor then
            local healthLost = lastHealth - currentHealth
            local armorLost = lastArmor - currentArmor

            if healthLost > 0 or armorLost > 0 then
                debugprint("DEBUG: Health lost:", healthLost, "Armor lost:", armorLost, "Searching for attacker...")

                local closestAttacker = nil
                local closestDistance = 5.0

                for _, player in ipairs(GetActivePlayers()) do
                    if player ~= PlayerId() then
                        local ped = GetPlayerPed(player)
                        local dist = #(GetEntityCoords(ped) - GetEntityCoords(playerPed))

                        if dist < closestDistance then
                            if IsPedDoingMeleeAttack(ped) or IsPlayerAimingAtMe(playerPed, ped) then
                                closestAttacker = player
                                closestDistance = dist
                            end
                        end
                    end
                end

                if closestAttacker then
                    local attackerServerId = GetPlayerServerId(closestAttacker)
                    local victimServerId = GetPlayerServerId(PlayerId())

                    debugprint("DEBUG: Confirmed attacker found! Sending to server. Attacker:", attackerServerId, "Victim:", victimServerId, "Health Lost:", healthLost, "Armor Lost:", armorLost)
                    TriggerServerEvent('fsg_misclick:processDamage', attackerServerId, victimServerId, healthLost, armorLost)
                else
                    debugprint("DEBUG: No confirmed attacker found nearby.")
                end
            end
        end

        lastHealth = currentHealth 
        lastArmor = currentArmor
    end
end)

function IsPedDoingMeleeAttack(ped)
    return IsPedInMeleeCombat(ped) or IsPedArmed(ped, 1)
end

function IsPlayerAimingAtMe(victimPed, attackerPed)
    return HasEntityClearLosToEntity(victimPed, attackerPed, 17) and IsPlayerFreeAimingAtEntity(NetworkGetPlayerIndexFromPed(attackerPed), victimPed)
end

RegisterNetEvent('fsg_misclick:restorePartialHealth', function(healthAmount)
    local playerPed = cache.ped
    local currentHealth = GetEntityHealth(playerPed)
    local maxHealth = GetEntityMaxHealth(playerPed)

    local newHealth = math.min(currentHealth + healthAmount, maxHealth)
    SetEntityHealth(playerPed, newHealth)

    debugprint("DEBUG: Restored", healthAmount, "health. New health:", newHealth)
end)

RegisterNetEvent('fsg_misclick:restorePartialArmor', function(armorAmount)
    local playerPed = cache.ped
    local currentArmor = GetPedArmour(playerPed)

    local newArmor = math.min(currentArmor + armorAmount, 100)
    SetPedArmour(playerPed, newArmor)

    debugprint("DEBUG: Restored", armorAmount, "armor. New armor:", newArmor)
end)
