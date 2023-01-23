-- Import completion API
local completion = require("completion")
local quill = require("quill")


-- Determine risk and personality
local risk = 1
local personality = "standard"
-- Select greeting file based on personality
personality = quill.firstUpper(personality)
local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"


-- Generate completion request from prompt, with a risk temperature and maximum token limit
completion.request("Say this is a test", 0, 10)


-- Source locally stored response and print text from first choice
local last = completion.last()
last = last["choices"][1]["text"]
print(last .. "\n")


-- Initiate a conversation
completion.greet(greetFile)
local start = quill.scribe(greetFile, "r")
print(start .. "\n")
-- Continue the conversation indefinately
local prompt
while true do
    print("\n")
    prompt = read()
    -- Continue with prompt (user input), risk (0-1), token limit (max per reply), cutoff (how many replies to remember)
    local cont = completion.continue(prompt, risk, 200, 5)
    print(cont["choices"][1]["text"])
end
