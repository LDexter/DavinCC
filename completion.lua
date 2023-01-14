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
    for _, choice in pairs(cmplOut["choices"]) do
        -- Find opening space to indicate lack of context
        local summStart = string.find(choice["text"], " ")
        if summStart == 1 then
            -- Capitolise first letter of prompt
            prompt = quill.firstUpper(prompt)

            -- Concatonate prompt as prefix to response and semicolon as suffix to summary
            choice["text"] = prompt .. choice["text"]
            local summEnd = string.find(choice["text"], "\n") or false
            if summEnd then
                choice["text"] = quill.insert(choice["text"], ";", summEnd - 1)
            end
        end

        if choice["finish_reason"] == "length" then
            choice["text"] = quill.toBeContd(choice["text"])
        end
    end

    -- Reserialising for local storage
    cmplJSON = textutils.serialiseJSON(cmplOut)

    -- Storing response locally for later access --! Overwriting each completion
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