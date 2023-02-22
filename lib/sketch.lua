local sketch = {}

-- Import openai and quill
local pathOG = package.path
package.path = "/DALL-CC/?.lua;" .. package.path
local openai = require("lib/openai-lua/openai")
local quill = require("lib/quill")

-- Import canvas
package.path = "/DALL-CC/lib/pngLua/?.lua;" .. pathOG
local isCanv, canvas = pcall(require, "lib/canvas")
if not isCanv then
    canvas =  setmetatable({}, {__index=function () error("Canvas not found.") end})
end


-- Generates image with DALL-E using prompt, number, and size
function sketch.generate(prompt, number, size)
    local gen = openai.generate(prompt, number, size)
    local links = {}

    -- Checking for flags
    if openai.isFlagged then
        print("PROMPT FLAGGED FOR:")
        -- Iterate flag categories
        for key, value in pairs(openai.flags.categories) do
            -- Print all true categories
            if value then
                print(key)
            end
        end
    end

    -- Error image if failed
    if not gen then
        gen = quill.scribe("/DALL-CC/data/empty.json", "r")
    end

    -- Write to gen.json and clear out.txt
    quill.scribe("/DALL-CC/data/gen.json", "w", gen)
    quill.scribe("/DALL-CC/data/out.txt", "w", "")

    -- Append out with each link
    for count, image in pairs(textutils.unserialiseJSON(gen)["data"]) do
        links[count] = image["url"]
        quill.scribe("/DALL-CC/data/out.txt", "a", links[count] .. "\n")
    end

    -- Return last link
    return links
end


function sketch.display(links)
    term.setTextColour(colours.orange)
    print("Generated...\n")

    -- Define and make image directory
    local dirGen = "/DALL-CC/images/gen/"
    local dirOut = "/DALL-CC/images/out/"

    fs.delete(dirGen)
    fs.delete(dirOut)

    fs.makeDir(dirGen)
    fs.makeDir(dirOut)

    -- Use pngLua to render each in ComputerCraft
    for count, url in pairs(links) do
        -- Pull images only if exist
        local req = http.get(url, nil, true)
        if req then
            local png = req.readAll()
            req.close()
            print("Downloaded...\n")

            -- Create name and path for gen
            local gen = "gen" .. count .. ".png"
            local out = "out" .. count .. ".bimg"
            local pathGen = dirGen .. gen
            local pathOut = dirOut .. out

            -- Display and save generations
            quill.scribe(pathGen, "wb", png)
            print("Saved...\n")
            canvas.render(pathGen, pathOut)

            -- Clear and repeat upon any user input
            os.pullEvent("char")
            canvas.clear()
            print("Next...\n")
        else
            print("Prompt not accepted.")
        end
    end

    -- Finish
    term.clear()
    term.setCursorPos(1, 1)
end


return sketch