local dalib = {}

-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("lib/completion")
local quill = require("lib/quill")
local sketch = require("lib/sketch")
local flag = require("lib/flag")

local personality, risk, cutoff, model, img, magnitude
local tokens = 500
local isInput = true
local isPrompt = true
local isChat = false
local isImg
local size
local number

-- Library input for risk and personality
function dalib.setup(setPersonality, setRisk, setCutoff, setModel, setImg, setMagnitude)
    personality = setPersonality
    risk = setRisk
    cutoff = setCutoff
    model = setModel
    img = setImg
    magnitude = setMagnitude

    personality = personality or "standard"
    personality = string.lower(personality)
    model = model or "gpt-3.5"

    -- Checking usage of chat method
    if model == "gpt-3.5" then
        model = "gpt-3.5-turbo"
    end
    if model == "gpt-3.5" or model == "gpt-3.5-turbo" or model == "gpt-4" or model == "gpt-4-32k" then
        isChat = true
    end

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
    elseif magnitude == "md" or magnitude == "lg" then -- Medium AND large
        size = "512x512"
    elseif magnitude == "lg" then --! Large images not rendering, thus temporarily disabled
        size = "1024x1024"
    end

    -- Input testing for non-number
    if type(risk) ~= "number" then
        risk = 0
    end
    if type(cutoff) ~= "number" then
        cutoff = 10
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
        local greetFile

        -- Test for ChatGPT model
        if isChat then
            greetFile = "/DavinCC/greetings/greet" .. greetPersonality .. ".json"
        else
            greetFile = "/DavinCC/greetings/greet" .. greetPersonality .. ".txt"
        end

        -- Initiate a conversation
        completion.greet(greetFile, false, true)
    end

    --! No startup print
    local cont
    if isChat then
        cont = completion.chat("hello", risk, tokens, cutoff)
    else
        cont = completion.continue("hello", risk, tokens, cutoff)
    end
    dalib.reply = cont

    -- Return UX-ready concat of all basic variables
    return "Personality: \"" .. personality .. "\" Risk: " .. risk .. " Cutoff: " .. cutoff .. " Img: " .. img
end

-- Conversation variables
local prompt
local cont
local reply
local number


-- Configure based on new prompt
local function config(prompt)
    --! TODO: Literalise prompt commands
    local confPmpt = "[PMPT]"
    local confPer = "[PER]"
    local confIns = "[INS]"
    local confImg = "[IMG]"
    local confSelf = "[SELF]"
    local confVar = "[VAR]"
    local confClr = "[CLR]"

    isPrompt = true


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


    --* Process personality flags and check for [PER]
    local tblPer = flag.per(prompt, risk, tokens, cutoff)
    local replay
    if flag.isCall then
        -- Check output
        if tblPer then
            personality = tblPer["g"] or personality
            replay = tblPer["r"] or replay
        end

        -- Remove from prompt
        prompt = quill.replace(prompt, confPer .. flag.call, "")
        prompt = string.gsub(prompt, " +", " ")
    end


    --* Process insert flags and check for [INS]
    -- TODO: automatic absolute path detection
    local tblIns = flag.ins(prompt)
    if flag.isCall then
        -- Remove from prompt before modifying
        prompt = quill.replace(prompt, confIns .. flag.call, "  ")

        -- Check output
        if tblIns then
            if tblIns["u"] then
                -- Prioritising url, with full webscrape
                print(tblIns["u"])
                local request = http.get(tblIns["u"])
                local response = request.readAll()
                request.close()

                -- Finding matches for text within HTML
                local text = ""
                for match in response:gmatch(">%s*(.-)%s*<") do text = text .. match end
                print(text)
                quill.truncate(text)

                -- Inserting scrape at command location
                prompt = quill.insert(prompt, text, flag.isCall)
            elseif tblIns["f"] then
                -- Appending file name to path
                local insFile = "/DavinCC/data/" .. tblIns["f"]

                -- Checking for file extension
                if not string.find(tblIns["f"], "%.") then
                    insFile = insFile .. ".txt"
                end

                -- Reading and inserting file contents at command location
                local insertion = quill.scribe(insFile, "r")
                prompt = quill.insert(prompt, insertion, flag.isCall)
            end
        end

        -- Remove spaces after modifying
        prompt = string.gsub(prompt, " +", " ")
    end


    --* Process image flags and check for [IMG]
    local tblImg = flag.img(prompt)
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


    --* Process self flags and check for [SELF]
    local tblSelf = flag.self(prompt, risk, tokens, cutoff)
    if flag.isCall then
        -- Check output
        if tblSelf then
            personality = tblSelf["g"] or personality
            isInput = false
        end

        -- Remove from prompt
        prompt = quill.replace(prompt, confSelf .. flag.call, "")
        prompt = string.gsub(prompt, " +", " ")
    end


    --* Process variable flags and check for [VAR]
    local tblVar = flag.var(prompt)
    if flag.isCall and isInput then
        if tblVar then
            -- Stop prompting
            isPrompt = false
        end

        -- Remove from prompt
        prompt = quill.replace(prompt, confVar .. flag.call, "")
        prompt = string.gsub(prompt, " +", " ")
    end
    if not tblVar then
        -- Re-enable prompting
        isPrompt = true
    end


    --* Check for [CLR]
    if quill.seek(prompt, confClr, "%s") then
        -- Clear terminal and reset pos
        term.clear()
        term.setCursorPos(1, 1)

        -- Remove from prompt
        prompt = quill.replace(prompt, confClr, "")
        prompt = string.gsub(prompt, " +", " ")
    end


    -- TODO: other configs... [SELF]-ggreet, [LIST]-llines

    -- Return new trail-less prompt
    -- prompt = quill.trailSpace(prompt)
    return prompt
end


local function promptSelf()
    -- Allow cancellation
    print("Continue? (y/n)")
    sleep(1)
    local _, ans = os.pullEvent("char")

    local x, y = term.getCursorPos()
    term.setCursorPos(x, y - 1)
    term.clearLine()

    if ans == "y" then
        -- Continue conversation with self
        cont = completion.continueSelf(reply, risk, tokens, cutoff, model)

        -- Store and print truncated prompt
        prompt = cont
        prompt = quill.truncate(prompt)
        quill.scribe("/DavinCC/data/out.txt", "w", prompt)
        print(prompt)
        sleep(1)
        isInput = false

    elseif ans == "n" then
        isInput = true
        prompt = read()
    end
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
        cont = completion.request(prompt, risk, tokens, model)

        -- Store truncated reply
        reply = cont
        reply = quill.truncate(reply)
        quill.scribe("/DavinCC/out.txt", "w", reply)

        --! No reply print

        -- Generating image if true
        if isImg then
            local links = sketch.generate(reply, number, size)
            print("I made an image...\n")
            sketch.display(links)
        end


    -- Otherwise, conduct conversation with chosen personality
    else
        --! No prompt print

        -- Configuring based on prompt commands
        prompt = config(prompt)

        -- Check for self conversation
        if not isInput then
            promptSelf()
            print("\n")
        end

        if isPrompt then
            -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
            if isChat then
                cont = completion.chat(prompt, risk, tokens, cutoff, model)
            else
                cont = completion.continue(prompt, risk, tokens, cutoff, model)
            end

            -- Store truncated reply
            reply = cont
            reply = quill.truncate(reply)
            quill.scribe("/DavinCC/data/out.txt", "w", reply)

            -- Send reply out for library access
            dalib.reply = reply

            --! No reply print

            -- Generating image if true
            if isImg then
                local links = sketch.generate(reply, number, size)
                print("I made an image...\n")
                sketch.display(links)
            end
        end
    end

    -- Library variables
    dalib.prompt = prompt
    dalib.reply = reply

    return reply
end

return dalib