local quill = {}


-- Writes, reads, or appends to a file
function quill.scribe(path, mode, input)
    local text
    local file = fs.open(path, mode)
    if mode == "r" then
        text = file.readAll()
        return text
    elseif mode == "w" or mode == "a" then
        file.write(input)
    end
    file.close()
end


-- Inserts into a string at provided position
function quill.insert(str1, str2, pos)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end


-- Finds text starting after a pattern, up to a stopping pattern
function quill.seek(str, pattern, stop)
    -- Find start and end index
    local seekStart = string.find(str, pattern)
    local seekEnd
    if seekStart then
        seekEnd = string.find(str, stop, seekStart + 1)
    else
        return ""
    end
    -- Accounting for missing stop
    if seekEnd then
        seekEnd = seekEnd - 1
    else
        seekEnd = #str
    end

    -- Isolate desired text
    local seekOut = string.sub(str, seekStart + #pattern - 1, seekEnd)
    return seekOut
end


function quill.replace(str, pattern, repl)
    pattern = pattern:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
    str = str:gsub(pattern, repl)
    return str
end


-- Capitalises first letter
function quill.firstUpper(str)
    return (str:gsub("^%l", string.upper))
end


-- Removes trailing spaces
function quill.trailSpace(str)
    return string.gsub(str, '[ \t]+%f[\r\n%z]', '')
end


-- Truncates newlines into spaces
function quill.truncate(str)
    -- Eliminate all newlines and account for double spaces
    str = string.gsub(str, "\n", " ")
    str = string.gsub(str, "  ", " ")
    str = string.gsub(str, '^%s*(.-)%s*$', '%1')
    return str
end


-- Ends string with ellipsis
function quill.toBeContd(str)
    str = quill.trailSpace(str)
    return str .. "..."
end


return quill