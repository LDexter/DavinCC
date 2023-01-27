-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("completion")
local quill = require("quill")

-- User input for risk and personality
local personality, risk, cutoff = ...
personality = personality or "standard"
personality = string.lower(personality)
risk = tonumber(risk)

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

local prompt
local cont


-- Quick and flavourless request
if personality == "none" then
    print("Personality: \"" .. personality .. "\"\n")
    prompt = read()
    -- Complete prompt (user input), risk (0-1), token limit
    cont = completion.request(prompt, risk, 200)
    print(cont["choices"][1]["text"] .. "\n")


-- Otherwise, conduct conversation with chosen personality
else
    -- Printing chosen arguments
    print("Personality: \"" .. personality .. "\" Risk: " .. risk .. " Cutoff: " .. cutoff)


    -- Select greeting file based on personality
    personality = quill.firstUpper(personality)
    local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"


    -- Initiate a conversation
    completion.greet(greetFile)
    quill.scribe(greetFile, "r")


    -- Start with reply to "hello" prompt
    cont = completion.continue("hello", risk, 200, cutoff)
    print(cont["choices"][1]["text"])


    -- Continue the conversation indefinately
    while true do
        print("\n")
        prompt = read()
        print("\n")
        -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
        cont = completion.continue(prompt, risk, 200, cutoff)
        print(cont["choices"][1]["text"])
    end
end