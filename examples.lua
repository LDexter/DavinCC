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
local dalib = require("lib/dalib")

-- Conversation arguments
local personality = "standard"
local risk = 1
local tokens = 500
local cutoff = 10
local model = "chat"

-- Select greeting file based on personality
personality = quill.firstUpper(personality)
local greetFile
if model == "chat" then
    greetFile = "/DavinCC/greetings/greet" .. personality .. ".json"
else
    greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"
end


--? Part of old example
-- -- Generate test completion, with a risk temperature and maximum token limit
-- completion.greet(greetFile, false, true)
-- completion.chat("Tell me about yourself", 0, 100)


-- -- Source locally stored response and print text from first choice
-- local last = completion.last(model)
-- print(last .. "\n")


-- Simple usage of dalib, a library version of the da user interface for conversations
--* dalib.setup(setPersonality, setRisk, setCutoff, setImg, setMagnitude)
dalib.setup("standard", risk, cutoff, model)
print(dalib.reply .. "\n")

-- Once setup, dalib is prepped and ready for these parameters
dalib.run("Tell me about ants.")
print(dalib.reply .. "\n")

-- Contextual call-back to prove the AI understands what "their" could mean
dalib.run("Tell me about their colonies.")
print(dalib.reply .. "\n")

-- Inserting "x" variable
dalib.run("Say x=1 without spaces.")
print(dalib.reply .. "\n")

-- Referring back to last prompt's use of "x"
dalib.run("What did you say about x=")
print(dalib.reply .. "\n")
sleep(1)
-- Utilising the VAR prompt command to change the value of "x" from last prompt
dalib.run("[VAR]-nx-v42")
sleep(1)
-- Referring to "x" again
dalib.run("What did you say about x=")
print(dalib.reply .. "\n")
sleep(1)


-- Initiate a new "DIY" conversation, as barebones and lightweight version of da
completion.greet(greetFile, false, true)
local start = completion.chat("hello", risk, tokens, cutoff)
print(start .. "\n")


-- Continue the conversation indefinately, similar to da
local prompt
local cont
while true do
    print("\n")
    prompt = read()
    -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
    cont = completion.chat(prompt, risk, tokens, cutoff)
    print(cont)
end