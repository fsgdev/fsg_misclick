Config = {
    debug = false,

    Command = 'mc', 
}

function debugprint(message)
    if Config.debug then
        print(message)
    end
end
