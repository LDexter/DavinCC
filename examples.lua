-- Import completion API
local completion = require("completion")
local quill = require("quill")


-- Determine risk and personality
local risk = 1
local personality = "shy"
-- Select greeting file based on personality
personality = quill.firstUpper(personality)
local greetFile = "/DavinCC/greetings/greet" .. personality .. ".txt"


-- Generate completion request from prompt, with a risk temperature and maximum token limit
completion.request("Say this is a test", 0, 10)


-- Source locally stored response and print text from first choice
local last = completion.last()
last = last["choices"][1]["text"]
print(last .. "\n")


--! AUTO-ESCAPE QUOTATION MARKS
-- Initiate a conversation
local start = quill.scribe(greetFile, "r")
print(start .. "\n")
local prompt = read()
start = quill.truncateSpc(start)
local greet = completion.greet(greetFile, prompt, risk, 200)
print(greet["choices"][1]["text"])


--! AUTO-ESCAPE QUOTATION MARKS
-- Continue the conversation indefinately
while true do
    print("\n")
    prompt = read()
    local cont = completion.continue(prompt, risk, 200)
    print(cont["choices"][1]["text"])
end
