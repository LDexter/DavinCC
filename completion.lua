local completion = {}

-- Import openai API
local openai = require("../openai-lua/openai")
local quill = require("quill")


-- Request text from Davinci, given provided prompt, temperature, and maximum tokens
function completion.request(prompt, temp, tokens)
    local cmplJSON = openai.complete("text-davinci-003", prompt, temp, tokens)

    -- Unserialise into lua object/table
    local cmplOut = textutils.unserialiseJSON(cmplJSON)
    -- Test choices for contextless summaries
    for idx, choice in pairs(cmplOut["choices"]) do
        -- Find openg space to indicate lack of context
        local summStart = string.find(choice["text"], " ")
        if summStart == 1 then
            -- Capitolise first letter of prompt
            prompt = quill.firstUpper(prompt)

            -- Concatonate prompt as prefix to response and semicolon as suffix to summary
            local summEnd = string.find(choice["text"], "\n") or string.len(choice["text"]) + 1
            cmplOut["choices"][idx]["text"] = prompt .. quill.insert(choice["text"], ";", summEnd - 1)
        end
    end

    cmplJSON = textutils.serialiseJSON(cmplOut)

    -- Storing response locally for later access --! Overwriting
    local cmplFile = fs.open("/DavinCC/cmpl.json", "w")
    cmplFile.write(cmplJSON)
    cmplFile.close()

    return cmplOut
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