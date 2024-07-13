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

-- TODO! After figuring out where to put the search string,
-- return a table that will tell the wrapper function what kind
-- of recursive search to perform on the yaml file

-- | "TLMKV"
-- |Top level map with key value
-- | apiVersion: networking.k8s.io/v1

-- | "IOK"
-- |Indented object key
-- |  annotations:

-- | "IMKV"
-- |Indented map with key value
-- |    cert-manager.io/cluster-issuer: acme # This will attempt to automatically generate a cert.

-- | "AKV"
-- |Array with key value
-- |    - host: uxguide-temp.k8s.epic.com # What about this

-- | "AOK"
-- |Array object key
-- |       - backend: # some stuff

-- | "AVO"
-- |Array value only
-- |        - uxguide-temp.k8s.epic.com

function Set_search_string(str_input_table,needle)
    local res = {}
    res["table_type"] = ""
    local search_str = ""
    -- case 1: top level key
    if (string.match(str_input_table[1],":$") ~= nil) then
        if (str_input_table[2] ~= nil) and (str_input_table[2] ~= "#") then
            search_str = str_input_table[1] .. " " .. needle
            return search_str
        else
            search_str = needle .. ":"
            return search_str
        end
    end

    -- We now know there is just whitespace in the first table index
        -- If true the first value in the string table is leading whitespace
    if (string.match(str_input_table[1],"%S") == nil) then
        -- If true, the second value in the string is a key value
        if (string.match(str_input_table[2],":$") ~= nil) then
            -- matches "   key:"
            if str_input_table[3] == nil then
                search_str = search_str .. str_input_table[1] .. needle .. ":"
                return search_str
            end
            if (str_input_table[3] ~= nil) and (str_input_table[3] == "#") then
                search_str = search_str .. str_input_table[1] .. needle .. ":"
                return search_str
            end
            if (str_input_table[3] ~= nil) and (str_input_table[3] ~= "#") then
                -- search_str = search_str .. str_input_table[1] .. str_input_table[2] .. " AXOEIEO5346322"
                search_str = search_str .. str_input_table[1] .. str_input_table[2] .. " " .. needle
                return search_str
            end
        end
    end

    for key, value in pairs(str_input_table) do

        if (string.match(value,"%S") == nil) then
            search_str = search_str .. value

        -- This will match array objects
        elseif (value == "-") and (string.match(str_input_table[key+1],":$") == nil) then
            print("Made it into the first elseif")
            -- search_str = search_str .. value .. " AXOEIEO5346322"
            search_str = search_str .. value .. " " .. needle
            return search_str
        -- This will match "   - key:"

        elseif (value == "-") and (string.match(str_input_table[key+1],":$") ~= nil) then
            print("made it into the second elseif")
            if (str_input_table[key+2] ~= nil) and (str_input_table[key+2] == "#") then
                print("made it into elseif 2 if 1")
                -- search_str = search_str .. "- AXOEIEO5346322:"
                search_str = search_str .. "- " .. needle .. ":"
                return search_str
            end

            -- This will match "    - value"
            if (str_input_table[key+2] == nil) then
                print("made it into elseif 2 if 2")
                -- search_str = search_str .. "- AXOEIEO5346322:"
                search_str = search_str .. "- " .. needle .. ":"
                return search_str
            end

            -- if the next value is not a comment then it will match "   - key: value"
            if (str_input_table[key+2] ~= nil) and (str_input_table[key+2] ~= "#") then
                print("made it into elseif 2 if 3")
                -- search_str = search_str .. "- " .. str_input_table[key+1] .. " AXOEIEO5346322"
                search_str = search_str .. "- " .. str_input_table[key+1] .. " " .. needle
                return search_str
            end
        end
    end
end


function Print_string()
    local cur_line = vim.api.nvim_get_current_line()
    local output = mysplit(cur_line)
    recursive_print(output)
    local res = Set_search_string(output,"8YDxcEYQyu0UKU4+omo2bQ==")
    print(res)
    --  local strings = "   -"
    --  local some = string.match(strings,"%s")
    --  print('"' .. some .. '"')
end
