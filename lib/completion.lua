local completion = {}

-- Import openai and quill
package.path = "/DavinCC/?.lua;" .. package.path
local openai = require("lib/openai-lua/openai")
local quill = require("lib/quill")

-- Enable outter scope for conversation indexing
local idxPos
local idxStart
local idxPosSelf
local idxStartSelf
local positions = {}
local positionsSelf = {}


-- Request text from Davinci, given provided prompt, temperature, and maximum tokens
function completion.request(prompt, temp, tokens) -- TODO: add config class as argument
    local cmplJSON = openai.complete("text-davinci-003", prompt, temp, tokens)
    -- Check for empty response
    if not cmplJSON then
        -- Check for moderation flagging
        if openai.isFlagged then
            print("PROMPT FLAGGED FOR:")
            -- Iterate flag categories
            for key, value in pairs(openai.flags.categories) do
                -- Print all true categories
                if value then
                    print(key)
                end
            end
        end
        -- Fill with dummy JSON when empty
        cmplJSON = quill.scribe("/DavinCC/data/empty.json", "r")
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

        if openai.isFilter then
            openai.filter(choice["text"])
            -- Check for moderation flagging
            if openai.isFlagged then
                print("RESPONSE FLAGGED FOR:")
                -- Iterate flag categories
                for key, value in pairs(openai.flags.categories) do
                    -- Print all true categories
                    if value then
                        print(key)
                    end
                end
            end
        end
    end

    -- Reserialising for local storage
    cmplJSON = textutils.serialiseJSON(cmplOut)
    -- Storing response locally for later access
    quill.scribe("/DavinCC/data/cmpl.json", "w", cmplJSON)

    return cmplOut
end


-- Retrieve the last Davinci response
function completion.last()
    -- Accessing local storage
    local cmplData = quill.scribe("/DavinCC/data/cmpl.json", "r")

    -- Return as lua object/table
    return textutils.unserialiseJSON(cmplData)
end


-- Greet AI and prepare for conversation
function completion.greet(greetFile, greetSelf)
    -- Read greeting structure and write into log
    local greetStart = quill.scribe(greetFile, "r")
    if not greetSelf then
        idxStart = string.len(greetStart)
        idxPos = 1
        quill.scribe("/DavinCC/data/log.txt", "w", greetStart)
        return idxStart
    else
        idxStartSelf = string.len(greetStart)
        idxPosSelf = 1
        quill.scribe("/DavinCC/data/logSelf.txt", "w", greetStart)
        return idxStartSelf
    end
end


-- Re-greet AI and replay conversation
function completion.regreet(greetFile, risk, tokens, cutoff)
    local log = quill.scribe("/DavinCC/data/log.txt", "r")
    local prompt
    local replay
    local tblReplays = {}

    -- Iterate reply positions
    cutoff = idxPos - cutoff
    for key = cutoff, #positions do
        -- Extract prompts
        prompt = string.sub(log, idxStart)
        prompt = string.sub(prompt, positions[key], positions[key + 1])
        prompt = quill.seek(prompt, "You: ", "AI: ")

        -- Store each truncated prompt for replay
        if prompt then
            replay = string.sub(prompt, 2)
            replay = quill.truncate(replay)
            replay = quill.trailSpace(replay)
            tblReplays[key] = replay
        end
    end

    -- Read greeting structure and write into log
    local greetStart = quill.scribe(greetFile, "r")
    idxStart = string.len(greetStart)
    quill.scribe("/DavinCC/data/log.txt", "w", greetStart)
    idxPos = 1

    -- Replay each prompt
    for _, value in pairs(tblReplays) do
        completion.continue(value, risk, tokens, cutoff)
    end

    return idxStart
end


-- Continue with conversation
function completion.continue(prompt, temp, tokens, cutoff)
    local promptLower = string.lower(prompt)

    -- Append prompt to log
    prompt = "\nYou: " .. prompt .. "\nAI: "
    quill.scribe("/DavinCC/data/log.txt", "a", prompt)

    -- Reading and adjusting log
    local history = quill.scribe("/DavinCC/data/log.txt", "r")
    history = string.gsub(history, "\"", "\'")

    -- Recording greeting and convo, as part of log
    local greeting = string.sub(history, 1, idxStart)
    local convo = string.sub(history, idxStart + 1)

    -- Current location stored in positions list
    local idxCurrent = #convo - #prompt
    positions[idxPos] = idxCurrent
    idxPos = idxPos + 1
    cutoff = idxPos - cutoff

    -- If cutoff position exists and cutoff not 0 (infinite), trim conversation
    if positions[cutoff] and cutoff > 0 then
        convo = string.sub(convo, positions[cutoff])
    end
    prompt = greeting .. convo

    -- Truncate prompt and generate reply
    prompt = quill.truncate(prompt)
    local idxPrompt = string.len(prompt)
    completion.request(prompt, temp, tokens)
    local contReply = completion.last()
    local contText = contReply["choices"][1]["text"]

    -- Cut history if present and append fully-truncated reply to log
    if string.find(contText, "The following is a conversation") then    -- TODO: add flexible matching
        contReply["choices"][1]["text"] = string.sub(contText, idxPrompt + 2)
    end
    local contLog = quill.truncate(contReply["choices"][1]["text"])
    quill.scribe("/DavinCC/data/log.txt", "a", contLog)

    -- Clear logs and terminate program if prompted with goodbye/bye keywords
    if promptLower == "goodbye" or promptLower == "bye" then
        os.queueEvent("terminate")
    end

    -- Return original reply
    return contReply
end


-- Continue with self
function completion.continueSelf(prompt, temp, tokens, cutoff)
    local promptLower = string.lower(prompt)

    -- Append prompt to log
    prompt = "\nYou: " .. prompt .. "\nAI: "
    quill.scribe("/DavinCC/data/logSelf.txt", "a", prompt)

    -- Reading and adjusting log
    local history = quill.scribe("/DavinCC/data/logSelf.txt", "r")
    history = string.gsub(history, "\"", "\'")

    -- Recording greeting and convo, as part of log
    local greeting = string.sub(history, 1, idxStartSelf)
    local convo = string.sub(history, idxStartSelf + 1)

    -- Current location stored in positions list
    local idxCurrent = #convo - #prompt
    positionsSelf[idxPosSelf] = idxCurrent
    idxPosSelf = idxPosSelf + 1
    cutoff = idxPosSelf - cutoff

    -- If cutoff position exists and cutoff not 0 (infinite), trim conversation
    if positionsSelf[cutoff] and cutoff > 0 then
        convo = string.sub(convo, positionsSelf[cutoff])
    end
    prompt = greeting .. convo

    -- Truncate prompt and generate reply
    prompt = quill.truncate(prompt)
    local idxPrompt = string.len(prompt)
    completion.request(prompt, temp, tokens)
    local contReply = completion.last()
    local contText = contReply["choices"][1]["text"]

    -- Cut history if present and append fully-truncated reply to log
    if string.find(contText, "The following is a conversation") then    -- TODO: add flexible matching
        contReply["choices"][1]["text"] = string.sub(contText, idxPrompt + 2)
    end
    local contLog = quill.truncate(contReply["choices"][1]["text"])
    quill.scribe("/DavinCC/data/logSelf.txt", "a", contLog)

    -- Clear logs and terminate program if prompted with goodbye/bye keywords
    if promptLower == "goodbye" or promptLower == "bye" then
        os.queueEvent("terminate")
    end

    -- Return original reply
    return contReply
end


return completion