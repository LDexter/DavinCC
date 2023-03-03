-- Check for invalid repository name
local isMain = fs.exists("/DavinCC-main/")
local isDavin = fs.exists("/DavinCC/")
if isMain then
    error("Incorrect repository name, please rename DavinCC-main to simply DavinCC.")
elseif not isDavin then
    error("Incorrect repository location or name, please ensure DavinCC is installed on root, as /DavinCC/.")
end

-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("lib/completion")
local quill = require("lib/quill")
local sketch = require("lib/sketch")
local flag = require("lib/flag")

-- User input for risk and personality
local personality, risk, cutoff, model, img, magnitude = ...
local tokens = 500
local isInput = true
local isPrompt = true
local isImg
personality = personality or "standard"
personality = string.lower(personality)
model = model or "chat"

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
local size = "256x256"
if magnitude == "sm" then
    size = "256x256"
elseif magnitude == "md" or magnitude == "lg" then  -- Medium AND large
    size = "512x512"
elseif magnitude == "lg" then   --! Large images not rendering, thus temporarily disabled
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

-- Conversation variables
local prompt
local cont
local reply
local number


-- Prepare for inserting
if not fs.exists("/DavinCC/data/in.txt") then
    quill.scribe("/DavinCC/data/in.txt", "w", "")
end


-- Configure based on new prompt
local function config(prompt)
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
            if tblIns["f"] then
                -- Appending file name to path
                local insFile = "/DavinCC/data/" .. tblIns["f"]

                -- Checking for file extension
                if not string.find(tblIns["f"], "%.") then
                    insFile = insFile .. ".txt"
                end

                -- Reading and inserting file contents
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


-- Quick and flavourless request
if personality == "none" then
    -- Print arguments
    print("Personality: \"" .. personality .. "\" Risk: " .. risk .. " Img: " .. img .. "\n")

    -- Read input as red
    term.setTextColour(colours.red)
    prompt = read()
    print("\n")

    -- Configuring based on prompt commands
    prompt = config(prompt)

    -- Complete prompt (user input), risk (0-1), token limit
    cont = completion.request(prompt, risk, tokens)

    -- Store truncated reply
    reply = cont
    reply = quill.truncate(reply)
    quill.scribe("/DavinCC/out.txt", "w", reply)

    -- Print output as orange
    term.setTextColour(colours.orange)
    print(reply .. "\n")

    -- Generating image if true
    if isImg then
        local links = sketch.generate(reply, number, size)
        print("I made an image...\n")
        sketch.display(links)
    end


-- Otherwise, conduct conversation with chosen personality
elseif model ~= "chat" then
    -- Printing chosen arguments
    print("Personality: \"" .. personality .. "\" Risk: " .. risk .. " Cutoff: " .. cutoff .. " Img: " .. img)

    -- Select greeting file based on personality
    personality = quill.firstUpper(personality)
    local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"

    -- Initiate a conversation
    completion.greet(greetFile)
    quill.scribe(greetFile, "r")

    -- Start with reply to "hello" prompt
    term.setTextColour(colours.orange)
    cont = completion.continue("hello", risk, tokens, cutoff, model)
    reply = cont
    print(reply)

    -- Continue the conversation indefinately
    while true do
        -- Read input as red
        print("\n")
        term.setTextColour(colours.red)
        if isInput then
            prompt = read()
        end
        -- Configuring based on prompt commands
        prompt = config(prompt)

        -- Check for self conversation
        if not isInput then
            promptSelf()
            print("\n")
        end

        if isPrompt then
            -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
            cont = completion.continue(prompt, risk, tokens, cutoff, model)

            -- Store truncated reply
            reply = cont
            reply = quill.truncate(reply)
            quill.scribe("/DavinCC/data/out.txt", "w", reply)

            -- Print output as orange
            term.setTextColour(colours.orange)
            print(reply)

            -- Generating image if true
            if isImg then
                local links = sketch.generate(reply, number, size)
                print("I made an image...\n")
                sketch.display(links)
            end
        end
    end
    
elseif model == "chat" then
    -- Printing chosen arguments
    print("Personality: \"" .. personality .. "\" Risk: " .. risk .. " Cutoff: " .. cutoff .. " Img: " .. img)

    -- Select greeting file based on personality
    personality = quill.firstUpper(personality)
    local greetFile = "/DavinCC/greetings/greet" .. personality .. ".json"

    --TODO: Initiate a conversation
    completion.greet(greetFile, false, true)
    -- quill.scribe(greetFile, "r")

    -- Start with reply to "hello" prompt
    term.setTextColour(colours.orange)
    cont = completion.chat("hello", risk, tokens, cutoff)
    reply = cont
    print(reply)

    -- Continue the conversation indefinately
    while true do
        -- Read input as red
        print("\n")
        term.setTextColour(colours.red)
        if isInput then
            prompt = read()
        end
        --TODO: Configuring based on prompt commands
        prompt = config(prompt)
        if not isInput then
            promptSelf()
            print("\n")
        end

        if isPrompt then
            -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
            cont = completion.chat(prompt, risk, tokens, cutoff)

            -- Store truncated reply
            reply = cont
            reply = quill.truncate(reply)
            quill.scribe("/DavinCC/data/out.txt", "w", reply)

            -- Print output as orange
            term.setTextColour(colours.orange)
            print(reply)

            -- Generating image if true
            if isImg then
                local links = sketch.generate(reply, number, size)
                print("I made an image...\n")
                sketch.display(links)
            end
        end
    end
end