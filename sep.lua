local string = "    key: value"

local function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t,str)
    end
    return t
end

-- local split = mysplit(string)
-- for i,v in ipairs(split) do
--    print(v)
-- end

-- print(string.len(split[2]))
-- local val_len = string.len(split[2])
-- local string_len = string.len(string)
-- local new_string = string.sub(string,1,string_len - val_len)
-- new_string = new_string .. "some_value"
-- print(new_string)

function Set_search_line()
    local cur_line = vim.api.nvim_get_current_line()
    local split = mysplit(cur_line)
    local val_len = string.len(split[2])
    local string_len = string.len(string)
    local new_string = string.sub(string,1,string_len - val_len)
    new_string = new_string .. "some_value"
    vim.api.nvim_set_current_line(new_string)
end
