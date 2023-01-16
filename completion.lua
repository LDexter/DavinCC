local completion = {}

-- Import openai API
local openai = require("../openai-lua/openai")
local quill = require("quill")


-- Request text from Davinci, given provided prompt, temperature, and maximum tokens
function completion.request(prompt, temp, tokens) -- TODO: add config class as argument
    local cmplJSON = openai.complete("text-davinci-003", prompt, temp, tokens)
    if not cmplJSON then
        cmplJSON = quill.scribe("/DavinCC/empty.json", "r")
    end

    -- Unserialise into lua object/table
    local cmplOut = textutils.unserialiseJSON(cmplJSON)
    -- Test choices for contextless summaries
    for _, choice in pairs(cmplOut["choices"]) do
        -- Find opening space to indicate lack of context
        local summStart = string.find(choice["text"], " ")
        if summStart == 1 then
            -- Capitalise first letter of prompt
            prompt = quill.firstUpper(prompt)

            -- Concatenate prompt as prefix to response and semicolon as suffix to summary
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
    -- Storing response locally for later access
    quill.scribe("/DavinCC/cmpl.json", "w", cmplJSON)

    return cmplOut
end


-- Retrieve the last Davinci response
function completion.last()
    -- Accessing local storage
    local cmplData = quill.scribe("/DavinCC/cmpl.json", "r")

    -- Return as lua object/table
    return textutils.unserialiseJSON(cmplData)
end


-- Greet AI and prepare for conversation
function completion.greet(prompt, temp, tokens)
    -- Read greeting structure and write into log
    local greetStart = quill.scribe("/DavinCC/greet.txt", "r") .. " " .. prompt .. "\nAI: "
    local idxStart = string.len(greetStart)
    quill.scribe("/DavinCC/log.txt", "w", greetStart)

    -- Truncate newlines of greeting and generate reply
    greetStart = quill.truncateSpc(greetStart)
    local greetReply = completion.request(greetStart, temp, tokens)
    local greetText = greetReply["choices"][1]["text"]

    -- Cut history if present and store truncated reply in log
    if string.find(greetText, greetStart) then
        greetReply["choices"][1]["text"] = string.sub(greetText, idxStart + 2)
    end
    local greetScribe = quill.truncateFull(greetReply["choices"][1]["text"])
    quill.scribe("/DavinCC/log.txt", "a", greetScribe)

    return greetReply
end


-- Continue with conversation
function completion.continue(prompt, temp, tokens)
    local promptOrigin = string.lower(prompt)
    -- Append log with user prompt
    prompt = "\nYou: " .. prompt .. "\nAI: "
    quill.scribe("/DavinCC/log.txt", "a", prompt)

    -- Adding log history to prompt
    local history = quill.scribe("/DavinCC/log.txt", "r")
    prompt = history .. " " .. prompt

    -- Truncate prompt and generate reply
    prompt = quill.truncateSpc(prompt)
    local idxPrompt = string.len(prompt)
    completion.request(prompt, temp, tokens)
    local contReply = completion.last()
    local contText = contReply["choices"][1]["text"]

    -- Cut history if present and append fully-truncated reply to log
    if string.find(contText, "The following is a conversation") then
        contReply["choices"][1]["text"] = string.sub(contText, idxPrompt + 2)
    end
    local contLog = quill.truncateFull(contReply["choices"][1]["text"])
    quill.scribe("/DavinCC/log.txt", "a", contLog)

    -- Clear logs and terminate program if prompted with goodbye keyword
    if promptOrigin == "goodbye" then
        quill.scribe("/DavinCC/log.txt", "w", "")
        os.queueEvent("terminate")
    end

    -- Return original reply
    return contReply
end


return completion