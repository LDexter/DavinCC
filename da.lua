-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("completion")
local quill = require("quill")

-- User input for risk and personality
local personality, risk, cutoff = ...
personality = personality or "standard"

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
elseif cutoff > 100 then
    cutoff = 100
end


-- Select greeting file based on personality
personality = quill.firstUpper(personality)
local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"


-- Initiate a conversation
completion.greet(greetFile)
quill.scribe(greetFile, "r")


-- Start with reply to "hello" prompt
local cont = completion.continue("hello", risk, 200, 5)
print(cont["choices"][1]["text"])


-- Continue the conversation indefinately
local prompt
while true do
    print("\n")
    prompt = read()
    print("\n")
    -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
    cont = completion.continue(prompt, risk, 200, 5)
    print(cont["choices"][1]["text"])
end
