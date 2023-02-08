local flag = {}

local quill = require("lib/quill")
local completion = require("lib/completion")

local pmptCall = "[PMPT]"
local perCall = "[PER]"
local insCall = "[INS]"
local imgCall = "[IMG]"
local varCall = "[VAR]"
flag.isCall = nil
flag.call = ""


-- Separates flagging into argument table
function flag.separate(args)
    -- String subbing
    local argEnd = 1
    local arg
    -- Detection
    local remain = args
    local more = true
    -- Outputting
    local key
    local val
    local tblArgs = {}

    -- Loop over all -kvalue pairs (arguments)
    repeat
        -- Check for more args
        if string.find(args, "-", argEnd + 1) then
            -- Store next arg while more remain
            arg = quill.seek(remain, "-", "-") or ""
            argEnd = argEnd + #arg
            remain = string.sub(remain, argEnd)
        else
            -- Store last arg
            arg = string.sub(args, argEnd)
            more = false
        end

        if arg then
            -- Separate into substrings
            key = string.sub(arg, 2, 2)
            val = string.sub(arg, 3)

            -- Store pairs
            tblArgs[key] = val
        else
            more = false
        end
    until not more

    -- Return table with arg names as keys
    return tblArgs
end


-- Separates flagging into nested argument table
function flag.shift(args)
    -- String subbing
    local name
    local value
    -- Detection
    local remain = args
    local more = true
    -- Outputting
    local tblArgs = {}
    local idxArg = 1

    -- Loop over all -kvalue pairs (arguments)
    repeat
        -- Seek out names within dashes and update remaining
        name = quill.seek(remain, "-", "-")
        remain = quill.replace(remain, name, "")

        -- Seek out values within dashes and update remaining
        value = quill.seek(remain, "-", "-")
        remain = quill.replace(remain, value, "")

        -- Check for remaining
        if #remain <= 1 then
            more = false
        end

        if name and value then
            -- Isolate actual content
            name = string.sub(name, 3)
            value = string.sub(value, 3)

            -- Append to table
            tblArgs[idxArg] = { name, value }
            idxArg = idxArg + 1
        else
            more = false
        end

    until not more

    -- Return table with arg names and values nested
    return tblArgs
end


-- Processes prompt flag
function flag.pmpt(prompt)
    -- Get and loop through arguments
    local pattCall = quill.literalize(pmptCall)
    flag.isCall = string.find(prompt, pattCall)
    flag.call = quill.seek(prompt, pmptCall, "%s") or ""
    local tblArgs = {}
    local tblOut = {}

    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(flag.call, "-") then
            tblArgs = flag.separate(flag.call)

            -- Convert risk ("r") argument
            tblOut["r"] = quill.range(tblArgs["r"], 0, 1)
            -- Convert cutoff ("c") argument
            tblOut["c"] = quill.range(tblArgs["c"], 0, 42)
            -- Convert tokens ("t") argument
            tblOut["t"] = quill.range(tblArgs["t"], 1, 4000)
        end
    end
    -- Return arguments
    return tblOut
end


-- Processes personality flag
function flag.per(prompt, risk, tokens, cutoff)
    -- Get and loop through arguments
    local pattCall = quill.literalize(perCall)
    flag.isCall = string.find(prompt, pattCall)
    flag.call = quill.seek(prompt, perCall, "%s") or ""
    local tblArgs = {}
    local tblOut = {}

    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(flag.call, "-") then
            tblArgs = flag.separate(flag.call)
            -- Convert greet ("g") argument
            tblOut["g"] = tblArgs["g"] or "standard"
            -- Convert replay ("r") argument
            tblOut["r"] = quill.boolify(tblArgs["r"])

            local greetFile = "/DavinCC/greetings/greet" .. tblOut["g"] .. ".txt"
            if tblOut["r"] then
                completion.regreet(greetFile, risk, tokens, cutoff)
            else
                completion.greet(greetFile)
            end
        end
    end
    -- Return arguments
    return tblOut
end


-- Processes personality flag
function flag.ins(prompt)
    -- Get and loop through arguments
    local pattCall = quill.literalize(insCall)
    flag.isCall = string.find(prompt, pattCall)
    flag.call = quill.seek(prompt, insCall, "%s") or ""
    local tblArgs = {}
    local tblOut = {}

    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(flag.call, "-") then
            tblArgs = flag.separate(flag.call)
            -- Convert file ("f") argument
        end

        -- Always insert, defaulting to in.txt
        tblOut["f"] = tblArgs["f"] or "in"
    end
    -- Return arguments
    return tblOut
end


-- Processes image flag
function flag.img(prompt)
    -- Get and loop through arguments
    local pattCall = quill.literalize(imgCall)
    flag.isCall = string.find(prompt, pattCall)
    flag.call = quill.seek(prompt, imgCall, "%s") or ""
    local tblArgs = {}
    local tblOut = {}
    tblOut["n"] = 1
    tblOut["s"] = "256x256"

    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(flag.call, "-") then
            tblArgs = flag.separate(flag.call)

            -- Convert number ("n") argument
            tblArgs["n"] = tonumber(tblArgs["n"])
            -- Input testing for number
            if type(tblArgs["n"]) == "number" then
                if tblArgs["n"] < 1 then
                    tblOut["n"] = 1
                elseif tblArgs["n"] > 10 then
                    tblOut["n"] = 10
                else
                    tblOut["n"] = tblArgs["n"]
                end
            end

            -- Convert size ("s") argument
            if tblArgs["s"] == "sm" then
                tblOut["s"] = "256x256"
            elseif tblArgs["s"] == "md" then
                tblOut["s"] = "512x512"
            elseif tblArgs["s"] == "lg" then
                tblOut["s"] = "1024x1024"
            end
        end
    end
    -- Return arguments
    return tblOut
end

-- Processes variable flag
function flag.var(prompt)
    -- Get and loop through arguments
    local pattCall = quill.literalize(varCall)
    flag.isCall = string.find(prompt, pattCall)
    flag.call = quill.seek(prompt, varCall, "%s") or ""
    local tblArgs = {}
    local name
    local value

    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(flag.call, "-") then
            -- Shift args into nested table
            tblArgs = flag.shift(flag.call)
            
            -- Loop through argument entries
            for _, entry in pairs(tblArgs) do
                -- Store names and values
                name = quill.literalize(entry[1])
                value = entry[2]

                -- Read log and store old content
                local log = quill.scribe("/DavinCC/data/log.txt", "r")
                local old = quill.seek(log, name .. "=", "%s")

                -- Overwrite log
                if #old > 0 then
                    log = quill.replace(log, old, "=" .. value)
                    quill.scribe("/DavinCC/data/log.txt", "w", log)
                end
            end
        end
    end

    -- Return arguments
    return tblArgs
end

return flag