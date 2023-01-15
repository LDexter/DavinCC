-- Import completion API
local completion = require("completion")
local quill = require("quill")

-- Generate completion request from prompt, with a risk temperature and maximum token limit
completion.request("Say this is a test", 0, 10)

-- Source locally stored response and print text from first choice
local last = completion.last()
last = last["choices"][1]["text"]
print(last .. "\n")


-- Initiate a conversation
local start = quill.scribe("/DavinCC/greet.txt", "r")
print(start)
local prompt = read()
start = quill.truncateSpc(start)
local greet = completion.greet(prompt, 0, 200)
greet = string.gsub(greet["choices"][1]["text"], start, "")
print(greet)


-- Continue the conversation indefinately
while true do
    print("\n")
    prompt = read()
    local cont = completion.continue(prompt, 0, 200)
    print(cont["choices"][1]["text"])
end
