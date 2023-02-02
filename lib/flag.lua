local flag = {}

local quill = require("lib/quill")

local imgCall = "[IMG]"
flag.isCall = nil
flag.call = ""


function flag.next(args)
    local argEnd = 1
    local arg
    local remain = args
    local more = true
    local tblArgs = {}
    local key
    local val
    repeat
        -- Check for more args
        if string.find(args, "-", argEnd + 1) then
            arg = quill.seek(remain, "-", "-")
            argEnd = argEnd + #arg
            remain = string.sub(remain, argEnd)
        else
            arg = string.sub(args, argEnd)
            more = false
        end
        key = string.sub(arg, 2, 2)
        val = string.sub(arg, 3)
        tblArgs[key] = val
    until not more
    return tblArgs
end


-- Processes image flag
function flag.img(prompt)
    -- Get and loop through arguments
    flag.isCall = string.find(prompt, imgCall)
    flag.call = quill.seek(prompt, imgCall, " ")
    local tblArgs = {}
    local tblOut = {}
    tblOut["n"] = 1
    tblOut["s"] = "256x256"
    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(flag.call, "-") then
            tblArgs = flag.next(flag.call)

            -- Convert number ("n") argument
            tblOut["n"] = tonumber(tblArgs["n"])
            -- Input testing for number
            if type(tblArgs["n"]) == "number" then
                if tblArgs["n"] < 1 then
                    tblOut["n"] = 1
                elseif tblArgs["n"] > 10 then
                    tblOut["n"] = 10
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

return flag