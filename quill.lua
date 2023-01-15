local quill = {}


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


function quill.insert(str1, str2, pos)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end


function quill.firstUpper(str)
    return (str:gsub("^%l", string.upper))
end


function quill.trailSpace(str)
    return string.gsub(str, '[ \t]+%f[\r\n%z]', '')
end


function quill.truncateSpc(str)
    return string.gsub(str, "\n", " ")
end


function quill.truncateFull(str)
    return string.gsub(str, "\n", "")
end


function quill.toBeContd(str)
    str = quill.trailSpace(str)
    return str .. "..."
end


return quill