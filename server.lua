local lastDamageData = {}

RegisterServerEvent('fsg_misclick:processDamage', function(attackerId, victimId, healthLost, armorLost)
    debugprint("DEBUG: Received damage event. Attacker:", attackerId, "Victim:", victimId, "Health Lost:", healthLost, "Armor Lost:", armorLost)

    lastDamageData[attackerId] = {
        victimId = victimId,
        healthLost = healthLost,
        armorLost = armorLost
    }
    debugprint("DEBUG: Stored damage. Attacker:", attackerId, "Victim:", victimId, "Health Lost:", healthLost, "Armor Lost:", armorLost)
end)

RegisterCommand(Config.Command, function(source, args, rawCommand)
    local src = source
    local damageInfo = lastDamageData[src]

    if not damageInfo then
        TriggerClientEvent('chat:addMessage', src, { args = { '^1You have no recent missclick!' } })
        return
    end

    local victimId = damageInfo.victimId
    local healthLost = damageInfo.healthLost
    local armorLost = damageInfo.armorLost

        if armorLost > 0 then
            TriggerClientEvent('fsg_misclick:restorePartialArmor', victimId, armorLost)
            TriggerClientEvent('chat:addMessage', src, { args = { '^2You have restored the health (and/or armor) of the last person you hit.' } })
            TriggerClientEvent('chat:addMessage', victimId, { args = { '^2Your armor has been restored by the other player.' } })
            debugprint("DEBUG: Successfully restored", armorLost, "armor for", victimId)
        elseif healthLost > 0 then
            TriggerClientEvent('fsg_misclick:restorePartialHealth', victimId, healthLost)
            TriggerClientEvent('chat:addMessage', src, { args = { '^2You have restored the health (and/or armor) of the last person you hit.' } })
            TriggerClientEvent('chat:addMessage', victimId, { args = { '^2Your health has been restored by the other player.' } })
            debugprint("DEBUG: Successfully restored", healthLost, "health for", victimId)
        end

    lastDamageData[src] = nil
    debugprint("DEBUG: Cleared lastDamageData for", src)
end, false)

AddEventHandler('playerDropped', function()
    local src = source
    lastDamageData[src] = nil
    debugprint("DEBUG: Player", src, "dropped, clearing lastDamageData")
end)
