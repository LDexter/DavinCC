local dalib = {}

-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("lib/completion")
local quill = require("lib/quill")
local sketch = require("lib/sketch")
local flag = require("lib/flag")

local personality, risk, cutoff, img, magnitude
local tokens = 200
local isPrompt = true
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
    if cutoff then
        cutoff = tonumber(cutoff)
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

    --! No startup print
    local cont = completion.continue("hello", risk, tokens, cutoff)
    dalib.reply = cont["choices"][1]["text"]

    -- Return UX-ready concat of all basic variables
    return "Personality: \"" .. personality .. "\" Risk: " .. risk .. " Cutoff: " .. cutoff .. " Img: " .. img
end


-- Configure based on new prompt
local function config(prompt)
    local confPmpt = "[PMPT]"
    local confImg = "[IMG]"
    local confVar = "[VAR]"


    --* Process prompt flags and check for [PMPT]
    local tblPmpt = flag.pmpt(prompt)
    if flag.isCall then
        -- Check output
        if tblPmpt then
            risk = tblPmpt["r"] or risk
            cutoff = tblPmpt["c"] or cutoff
            tokens = tblPmpt["t"] or tokens
        end

        -- Remove from prompt
        prompt = quill.replace(prompt, confPmpt .. flag.call, "")
        prompt = string.gsub(prompt, " +", " ")
    end

    --* Process image flags
    local tblImg = flag.img(prompt)

    -- Check calling for [IMG]
    if flag.isCall then
        -- Check output
        if tblImg then
            number = tblImg["n"]
            size = tblImg["s"]
        end

        -- Prepare for image
        isImg = true

        -- Remove from prompt
        prompt = quill.replace(prompt, confImg .. flag.call, "")
        prompt = string.gsub(prompt, " +", " ")
    else
        -- Stop preparing for image
        isImg = false
    end


    --* Process variable flags
    local tblVar = flag.var(prompt)

    -- Check calling for [VAR]
    if flag.isCall then
        -- Stop prompting
        isPrompt = false

        -- Remove from prompt
        prompt = quill.replace(prompt, confVar .. flag.call, "")
        prompt = string.gsub(prompt, " +", " ")
    else
        -- Re-enable prompting
        isPrompt = true
    end

    -- TODO: other configs... [INS]-ffile, [PMPT]-rrisk-ccutoff-ttokens, [PER]-ggreet-rreplay, [SELF]-ggreet, [LIST]-llines

    -- Return new prompt
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
        cont = completion.request(prompt, risk, tokens)

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
        --! No prompt print

        -- Configuring based on prompt commands
        prompt = config(prompt)

        if isPrompt then
            -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
            cont = completion.continue(prompt, risk, tokens, cutoff)

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
    end

    -- Library variables
    dalib.prompt = prompt
    dalib.reply = reply

    return reply
end

return dalib