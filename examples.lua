-- Import completion and quill
package.path = "/DavinCC/?.lua;" .. package.path
local completion = require("lib/completion")
local quill = require("lib/quill")
local dalib = require("lib/dalib")

-- Conversation arguments
local personality = "standard"
local risk = 1
local tokens = 200
local cutoff = 5

-- Select greeting file based on personality
personality = quill.firstUpper(personality)
local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"


-- Generate test completion, with a risk temperature and maximum token limit
completion.request("Say this is a test", 0, 10)


-- Source locally stored response and print text from first choice
local last = completion.last()
last = last["choices"][1]["text"]
print(last .. "\n")


-- Simple usage of dalib, a library version of the da user interface for conversations
--* dalib.setup(setPersonality, setRisk, setCutoff, setImg, setMagnitude)
dalib.setup("standard")
print(dalib.reply .. "\n")

-- Once setup, dalib is prepped and ready for these parameters
dalib.run("Tell me about ants.")
print(dalib.reply .. "\n")

-- Contextual call-back to prove the AI understands what "their" could mean
dalib.run("Tell me about their colonies. x=1")
print(dalib.reply .. "\n")

-- Referring back to last prompt's use of "x"
dalib.run("Solve x=")
print(dalib.reply .. "\n")
sleep(1)
-- Utilising the VAR prompt command to change the value of "x" from last prompt
dalib.run("[VAR]-nx-v42")
sleep(1)
-- Referring to "x" again
dalib.run("Solve x=")
print(dalib.reply .. "\n")
sleep(1)

-- Initiate a "DIY" conversation, as barebones and lightweight version of da
completion.greet(greetFile)
local start = quill.scribe(greetFile, "r")
print(start .. "\n")


-- Continue the conversation indefinately, similar to da
local prompt
local cont
while true do
    print("\n")
    prompt = read()
    -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
    cont = completion.continue(prompt, risk, tokens, cutoff)
    print(cont["choices"][1]["text"])
end