local sketch = {}

-- Import openai and quill
package.path = "/DALL-CC/?.lua;" .. package.path
local openai = require("lib/openai-lua/openai")
local quill = require("quill")



-- Generates image with DALL-E using prompt, number, and size
function sketch.generate(prompt, number, size)
    local gen = openai.generate(prompt, number, size)

    -- Error image if failed
    if not gen then
        gen = quill.scribe("/DALL-CC/empty.json", "r")
    end

    -- Write json and link
    quill.scribe("/DALL-CC/gen.json", "w", gen)
    local link = textutils.unserialiseJSON(gen)["data"][1]["url"]
    quill.scribe("/DALL-CC/out.txt", "w", link)
    return link
end


return sketch