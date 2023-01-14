-- Import completion API
local completion = require("completion")

-- Generate completion request from prompt, with a risk temperature and maximum token limit
completion.request("computers are", 0, 7)

-- Source locally stored response and print text from first choice
local last = completion.last()
print(last["choices"][1]["text"])