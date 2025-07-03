Config = {
    debug = false,
}

function debugprint(message)
    if Config.debug then
        print(message)
    end
end
