local complete = {}


-- Request text from Davinci, given provided prompt, temperature, and maximum tokens
function complete.request(prompt, temp, tokens)
    -- Accessing private key in local .env file
    local cmplEnv = fs.open("/DavinCC/.env", "r")
    local cmplAuth = cmplEnv.readAll()
    cmplEnv.close()

    -- Posting to OpenAI using the private key
    local cmplPost = http.post("https://api.openai.com/v1/completions",
        '{"model": "text-davinci-003", "prompt": "' .. prompt .. '", "temperature": ' .. temp .. ', "max_tokens": ' .. tokens .. '}',
        { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. cmplAuth })
    local cmplData = cmplPost.readAll()

    -- Storing response locally for later access --! Overwriting
    local cmplFile = fs.open("/DavinCC/cmpl.json", "w")
    cmplFile.write(cmplData)
    cmplFile.close()
    
    -- Return as lua object/table
    return textutils.unserialiseJSON(cmplData)
end


-- Retrieve the last Davinci response
function complete.last()
    -- Accessing local storage
    local cmplFile = fs.open("/DavinCC/cmpl.json", "r")
    local cmplData = cmplFile.readAll()
    cmplFile.close()
    
    -- Return as lua object/table
    return textutils.unserialiseJSON(cmplData)
end


return complete