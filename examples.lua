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
dalib.setup("standard")
-- Once setup, dalib is prepped and ready for these parameters
dalib.run("Tell me about ants")
print(dalib.reply .. "\n")
-- Contextual call-back to prove the AI understands what "their" could mean
dalib.run("Tell me about their colonies")
print(dalib.reply .. "\n")


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