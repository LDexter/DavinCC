local dalib = {}

-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("lib/completion")
local quill = require("lib/quill")
local sketch = require("lib/sketch")
local flag = require("lib/flag")

local personality, risk, cutoff, img, magnitude
local isImg
local size
local number

-- Library input for risk and personality
function dalib.setup(setPersonality, setRisk, setCutoff, setImg, setMagnitude)
    personality = setPersonality
    risk = setRisk
    cutoff = setCutoff
    img = setImg
    magnitude = setMagnitude

    personality = personality or "standard"
    personality = string.lower(personality)

    -- Input conversion
    if risk then
        risk = tonumber(risk)
    end
    if img then
        img = string.lower(img)
    else
        img = "false"
    end
    if magnitude then
        magnitude = string.lower(magnitude)
    else
        magnitude = "sm"
    end

    -- Magnitude conversion, defaults to small
    size = "256x256"
    if magnitude == "sm" then
        size = "256x256"
    elseif magnitude == "md" then
        size = "512x512"
    elseif magnitude == "lg" then
        size = "1024x1024"
    end

    -- Input testing for non-number
    if type(risk) ~= "number" then
        risk = 0
    end
    if type(cutoff) ~= "number" then
        cutoff = 5
    end

    -- Input testing for out of range
    if risk < 0 then
        risk = 0
    elseif risk > 1 then
        risk = 1
    end
    if cutoff < 0 then
        cutoff = 0
    elseif cutoff > 42 then
        cutoff = 42
    end

    -- Translating string to boolean
    if img == "true" or img == "t" or img == 1 then
        img = "true"
        isImg = true
    elseif img == "false" or img == "f" or img == 0 then
        img = "false"
        isImg = false
    end

    if personality ~= "none" then
        -- Select greeting file based on personality
        local greetPersonality = quill.firstUpper(personality)
        local greetFile = "/DavinCC/greetings/greet" .. greetPersonality .. ".txt"
    
        -- Initiate a conversation
        completion.greet(greetFile)
        quill.scribe(greetFile, "r")
    end

    -- Return UX-ready concat of all basic variables
    return "Personality: \"" .. personality .. "\" Risk: " .. risk .. " Cutoff: " .. cutoff .. " Img: " .. img
end


-- Configure based on new prompt
local function config(prompt)
    -- Process image flags
    local tblImg = flag.img(prompt)
    if flag.isCall then
        if tblImg then
            number = tblImg["n"]
            size = tblImg["s"]
        end
        isImg = true

        prompt = quill.replace(prompt, "[IMG]" .. flag.call, "")
        prompt = quill.trailSpace(prompt)
    else
        isImg = false
    end

    -- TODO: other configs... [INS]-ffile, [PMPT]-rrisk-ccutoff-ttokens, [PER]-ggreet-rreplay, [SELF]-ggreet, [LIST]-llines

    return prompt
end


-- Run da with prompt
function dalib.run(prompt)
    local reply
    local cont

    -- Quick and flavourless request
    if personality == "none" then
        --! No prompt print

        -- Configuring based on prompt commands
        prompt = config(prompt)

        -- Complete prompt (user input), risk (0-1), token limit
        cont = completion.request(prompt, risk, 1000)

        -- Store truncated reply
        reply = cont["choices"][1]["text"]
        reply = quill.truncate(reply)
        quill.scribe("/DavinCC/out.txt", "w", reply)

        --! No reply print

        -- Generating image if true
        if isImg then
            sleep(1)
            sketch.generate(reply, number, size)
            print("I made an image...\n")
        end


    -- Otherwise, conduct conversation with chosen personality
    else
        --! No startup print
        cont = completion.continue("hello", risk, 200, cutoff)

        --! No prompt print

        -- Configuring based on prompt commands
        prompt = config(prompt)

        -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
        cont = completion.continue(prompt, risk, 200, cutoff)

        -- Store truncated reply
        reply = cont["choices"][1]["text"]
        reply = quill.truncate(reply)
        quill.scribe("/DavinCC/data/out.txt", "w", reply)

        -- Send reply out for library access
        dalib.reply = reply

        --! No reply print

        -- Generating image if true
        if isImg then
            sleep(1)
            sketch.generate(reply, number, size)
            print("I made an image...\n")
        end
    end

    -- Library variables
    dalib.prompt = prompt
    dalib.reply = reply

    return reply
end

return dalib