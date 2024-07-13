local string = "    cert-manager.io/cluster-issuer: acme # This will attempt to automatically generate a cert."

vim.keymap.set("n", "<leader>b", ':lua Print_string()<CR>')

local function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    -- Check if there is leading whitespace and add that to the 
    -- string split table
    local whitespace = string.match(inputstr, "^%s+")
    if  whitespace ~= nil then
        table.insert(t,whitespace)
    end
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t,str)
    end
    return t
end

function Set_search_line()
    local cur_line = vim.api.nvim_get_current_line()
    local split = mysplit(cur_line)
    local val_len = string.len(split[2])
    local string_len = string.len(string)
    local new_string = string.sub(string,1,string_len - val_len)
    new_string = new_string .. "some_value"
    vim.api.nvim_set_current_line(new_string)
end

local function recursive_print(table)
    for key, value in pairs(table) do
        if type(value) == "table" then
            print("table key: " .. key)
            print("table value: ", value)
            recursive_print(value)
        else
            local word = string.match(value, "%w+")
            if word == nil then
                print("key: " .. key .. ', ' .. "value:" .. value)
            else
                print("key: " .. key .. ', ' .. "value:" .. value)
            end
        end
    end
end

function Set_search_string(str_input_table)
    local search_str
    -- case 1: top level key
    print(string.match(str_input_table[1],"$:"))
    if (string.match(str_input_table[1],"$:") ~= nil) then
        print("made it into the first loop")
        if (str_input_table[2] ~= nil) and (str_input_table[2] ~= "#") then
            search_str = str_input_table[1] .. " AXOEIEO5346322"
            return search_str
        else
            search_str = "AXOEIEO5346322:"
            return search_str
        end
    end
    -- We now know there is just whitespace in the first table index

    for key, value in pairs(str_input_table) do
        if string.match(value,"%w") == nil then
            search_str = search_str .. value
        -- This will match "   - value"
        elseif (value == "-") and (string.match(str_input_table[key+1],"$:") == nil) then
            search_str = search_str .. value .. " AXOEIEO5346322"
        -- This will match "   - key:"
        elseif (value == "-") and (string.match(str_input_table[key+1],"$:") ~= nil) then
            -- if the next value is not a comment then it will match "   - key: value"
            if (str_input_table[key+2] ~= nil) and (str_input_table[key+2] ~= "#") then
                search_str = search_str .. "- " .. str_input_table[key+1] .. " AXOEIEO5346322"
            end
            if (str_input_table[key+2] ~= nil) and (str_input_table[key+2] == "#") then
                search_str = search_str .. "- AXOEIEO5346322:"
            end
        end
    end
end


function Print_string()
    local cur_line = vim.api.nvim_get_current_line()
    local output = mysplit(cur_line)
    recursive_print(output)
    local res = Set_search_string(output)
    print(res)
    -- local strings = "    "
    -- print(string.match(strings,"%w"))
end
