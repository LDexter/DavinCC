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


local prompt
local cont


print("Personality: \"" .. personality .. "\"\n")

personality = quill.firstUpper(personality)
local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"

prompt = quill.scribe(greetFile, "r")
prompt = quill.truncateSpc(prompt)
-- Continue with prompt (file input), risk (0-1), token limit
cont = completion.request(prompt, risk, 200)
quill.scribe("/DavinCC/out.txt", "w", cont["choices"][1]["text"])
print(cont["choices"][1]["text"])