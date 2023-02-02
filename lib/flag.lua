local flag = {}

local quill = require("lib/quill")

local imgCall = "[IMG]"
flag.isCall = nil


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


function flag.params(tblArgs)
    
end


-- Processes image flag
function flag.img(prompt)
    -- Get and loop through arguments
    flag.isCall = string.find(prompt, imgCall)
    local call = quill.seek(prompt, imgCall, " ")
    local tblArgs = {}
    -- Check for call
    if flag.isCall then
        -- Check for arguments
        if string.find(call, "-") then
            tblArgs = flag.next(call)

            -- if tblArgs["n"] then
                
            -- end
            -- Convert number ("n") argument
            tblArgs["n"] = tonumber(tblArgs["n"])
            -- Input testing for non-number
            if type(tblArgs["n"]) ~= "number" then
                tblArgs["n"] = 1
            end
            if tblArgs["n"] < 1 then
                tblArgs["n"] = 1
            elseif tblArgs["n"] > 10 then
                tblArgs["n"] = 10
            end
            
            -- Convert size ("s") argument
            if tblArgs["s"] == "sm" then
                tblArgs["s"] = "256x256"
            elseif tblArgs["s"] == "md" then
                tblArgs["s"] = "512x512"
            elseif tblArgs["s"] == "lg" then
                tblArgs["s"] = "1024x1024"
            else
                tblArgs["s"] = "256x256"
            end
        end
    end
    -- Return arguments
    return tblArgs
end

return flag