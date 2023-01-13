-- Import completion API
local complete = require("complete")

-- Generate completion request from prompt, with a risk temperature and maximum token limit
complete.request("Say this is a test", 0, 7)

-- Source locally stored response and print text from first choice
local last = complete.last()
print(last["choices"][1]["text"])