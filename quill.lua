local quill = {}


function quill.insert(str1, str2, pos)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end


function quill.firstUpper(str)
    return (str:gsub("^%l", string.upper))
end


function quill.toBeContd(str)
    str = string.gsub(str, '[ \t]+%f[\r\n%z]', '')
    return str .. "..."
end


return quill