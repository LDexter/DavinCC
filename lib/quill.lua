local quill = {}


-- Writes, reads, or appends to a file
function quill.scribe(path, mode, input)
    local text
    local file = fs.open(path, mode)
    if mode == "r" or mode == "rb" then
        text = file.readAll()
        return text
    elseif mode == "w" or mode == "a" or mode == "wb" or mode == "ab" then
        file.write(input)
    end
    file.close()
end


-- Inserts into a string at provided position
function quill.insert(str1, str2, pos)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end


-- Create literal-ready patterns from strings
function quill.literalize(literal)
    if literal then
        literal = literal:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
    end
    return literal
end


-- Finds text starting after a pattern, up to a stopping pattern
function quill.seek(str, pattern, stop)
    -- Find start and end index
    -- pattern = quill.literalize(pattern)
    local seekStart = string.find(str, pattern)
    local seekEnd
    if seekStart then
        seekEnd = string.find(str, stop, seekStart + 1)
    else
        return nil
    end
    -- Accounting for missing stop
    if seekEnd then
        seekEnd = seekEnd - 1
    else
        seekEnd = #str
    end

    local seekOut
    if seekEnd - 1 > seekStart then
        -- Isolate desired text
        seekOut = string.sub(str, seekStart + #pattern - 1, seekEnd)
    else
        seekOut = nil
    end

    return seekOut
end


-- Replace string literal
function quill.replace(str, pattern, repl)
    pattern = quill.literalize(pattern)
    if pattern and repl then
        str = str:gsub(pattern, repl)
    end
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


-- Sets a number to within a range, converting if necessary
function quill.range(number, min, max, default)
    local result = default

    -- Convert number
    if type(number) ~= "number" then
        number = tonumber(number)
    end

    -- Ensure type and range
    if type(number) == "number" then
        result = math.max(min, math.min(number, max))
    end

    return result
end


function quill.boolify(str, default)
    local bool = default

    -- Translating string to boolean
    if str == "true" or str == "t" or str == "1" then
        str = "true"
        bool = true
    elseif str == "false" or str == "f" or str == "0" then
        str = "false"
        bool = false
    end

    return bool
end

return quill