-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("completion")
local quill = require("quill")

-- User input for risk and personality
local personality, risk = ...
personality = personality or "standard"
personality = string.lower(personality)
risk = tonumber(risk)

-- Input testing for non-number
if type(risk) ~= "number" then
    risk = 0
end
-- Input testing for out of range
if risk < 0 then
    risk = 0
elseif risk > 1 then
    risk = 1
end

-- Continuation variables
local greetFile
local cont
local prompt
local idxPrompt
local reply


-- Print arguments
print("Personality: \"" .. personality .. "\" Risk: " .. risk ..  "\n")


-- Pathing to greeting file
personality = quill.firstUpper(personality)
greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"


-- Read and truncate greeting into prompt
prompt = quill.scribe(greetFile, "r")
prompt = quill.truncateSpc(prompt)
idxPrompt = #prompt + 2


-- Continue with prompt (file input), risk (0-1), token limit
cont = completion.request(prompt, risk, 1000)
reply = string.sub(cont["choices"][1]["text"], idxPrompt)
quill.scribe("/DavinCC/out.txt", "w", reply)


-- Print as orange
term.setTextColour(colours.red)
print(reply .. "\n")