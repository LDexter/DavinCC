local completion = {}

-- Import openai API
local openai = require("../openai-lua/openai")


-- Request text from Davinci, given provided prompt, temperature, and maximum tokens
function completion.request(prompt, temp, tokens)
    local cmplData = openai.complete("text-davinci-003", prompt, temp, tokens)

    -- Storing response locally for later access --! Overwriting
    local cmplFile = fs.open("/DavinCC/cmpl.json", "w")
    cmplFile.write(cmplData)
    cmplFile.close()

    -- Return as lua object/table
    return textutils.unserialiseJSON(cmplData)
end


-- Retrieve the last Davinci response
function completion.last()
    -- Accessing local storage
    local cmplFile = fs.open("/DavinCC/cmpl.json", "r")
    local cmplData = cmplFile.readAll()
    cmplFile.close()
    
    -- Return as lua object/table
    return textutils.unserialiseJSON(cmplData)
end


return completion