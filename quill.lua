local quill = {}


function quill.insert(str1, str2, pos)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end


function quill.firstUpper(str)
    return (str:gsub("^%l", string.upper))
end


function quill.trailSpace(str)
    return string.gsub(str, '[ \t]+%f[\r\n%z]', '')
end


function quill.toBeContd(str)
    str = quill.trailSpace(str)
    return str .. "..."
end


return quill