print('this is a util file')

vim.notify = require("notify")

-- require "luarocks.share.lua.5.1.lyaml.init"
-- package.cpath = package.cpath .. ";/home/mimparat/plugins/attempt.nvim/lua/rocks/lib/lua/5.1/yaml.so"
local yaml = require('lyaml')

vim.keymap.set("n", "<leader>b", ':lua Get_current_path()<CR>')
vim.keymap.set("n", "<leader>d", ':lua Get_current_path_test()<CR>')

local function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function recursive_print(table)
    for key, value in pairs(table) do
        if type(value) == "table" then
            print("table key: " .. key)
            print("table value: ", value)
            recursive_print(value)
        else
            print("key: " .. key .. ', ' .. "value: " .. value)
        end
    end
end

local function string_reindex(input_str)
    local string_table = mysplit(input_str, ".")

    for key, value in pairs(string_table) do
        local number = tonumber(value)
        if number ~= nil then
            string_table[key] = "[" .. (number - 1) .. "]"
        end
    end

    local new_reindexed_str = ""

    for key, value in pairs(string_table) do
        new_reindexed_str = new_reindexed_str .. "." .. value
    end

    return new_reindexed_str
end

Get_current_line = function()
    local current_line = vim.api.nvim_get_current_line()
    print(current_line)
end

local s = "one;two;;four"
local words = {}
for w in (s .. ";"):gmatch("([^;]*);") do
    table.insert(words, w)
end

function Set_search_line()
    local cur_line = vim.api.nvim_get_current_line()
    local split = mysplit(cur_line, ":")
    local val_len = string.len(split[2])
    local string_len = string.len(cur_line)
    local new_string = string.sub(cur_line, 1, string_len - val_len)
    new_string = new_string .. " AXOEIEO5346322"
    vim.api.nvim_set_current_line(new_string)
end

function Print_yaml_doc()
    local current_buf_content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    local current_buf_string = table.concat(current_buf_content, "\n")
    local data = yaml.load(current_buf_string)

    recursive_print(data)
end

function Get_current_path_test()
    -- local test_yaml = "    chart:"
    local cur_line = vim.api.nvim_get_current_line()
    -- check if the line is an array that has no key value
    local array_line_check = string.match(cur_line, "%S+")
    -- This will get everythng aften "-" not including the whitespace between
    -- "-" and the start of the value
    local array_val = string.match(cur_line, "%w+.*")
    -- if array_line_check == "-" then
    -- end
    local whitespace = string.match(cur_line, "%s+")

    local search_string = whitespace .. "- AXOEIEO5346322"
    vim.api.nvim_set_current_line(search_string)

    local current_buf_content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    local current_buf_string = table.concat(current_buf_content, "\n")
    local data = yaml.load(current_buf_string)

    local output = Recursive_find(data, "AXOEIEO5346322")

    vim.api.nvim_set_current_line(cur_line)
    local output_string = "'" .. string_reindex(output[1]) .. "'"
    vim.fn.setreg("+Y", output_string)
    vim.notify('Copied "' .. output_string .. '" to the clipboard!')
end

function Get_current_path()
    -- local test_yaml = "    chart:
    local cur_line = vim.api.nvim_get_current_line()
    if not (string.find(cur_line, ":")) then
        print("No yaml string found...")
        return
    end
    local split = mysplit(cur_line, ":")
    -- if the second value of the table containing the split key value
    -- pair is nil then we know we are looking for a key and not
    -- a key,value pair
    if split[2] == nil then
        local original_key = string.match(split[1], "%w+")
        local search_line
        -- There is no whitespace if the string.match function returns nil
        if (string.match(split[1], "%W+")) == nil then
            search_line = "AXOEIEO5346322:"
        else
            search_line = string.match(split[1], "%W+") .. "AXOEIEO5346322:"
        end
        vim.api.nvim_set_current_line(search_line)
        local current_buf_content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
        local current_buf_string = table.concat(current_buf_content, "\n")
        local data = yaml.load(current_buf_string)
        local output = Recursive_find_key(data, "AXOEIEO5346322")
        local result = string.gsub(output[1], "AXOEIEO5346322", original_key)
        vim.api.nvim_set_current_line(cur_line)
        print(result)
    else
        Set_search_line()
        local current_buf_content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
        local current_buf_string = table.concat(current_buf_content, "\n")
        local data = yaml.load(current_buf_string)
        local output = Recursive_find(data, "AXOEIEO5346322")
        -- put the current line back to the way it was before
        -- inserting the needle
        vim.api.nvim_set_current_line(cur_line)
        -- print("printing output table...")
        print(output[1])
    end
end

function Recursive_find(t, value_to_find, paths, current_path)
    if paths == nil then
        paths = {}
    end
    if current_path == nil then
        current_path = {}
    end

    -- print("current_path:", current_path)
    for key, value in pairs(t) do
        -- print("key:", key)
        -- print("value", value)
        if (type(value) ~= "table") and (value == value_to_find) then
            -- print("found the value, adding current path to paths and returning")
            -- table.insert(current_path,key)
            -- table.insert(paths,current_path)
            local res = {}
            table.insert(res, key)
            return res
        end

        if type(value) == "table" then
            -- table.insert(current_path,key)
            local result = Recursive_find(value, value_to_find, paths, current_path)
            local next = next
            if next(result) ~= nil then
                local path = {}
                table.insert(path, key .. "." .. result[1])
                return path
            end
        end
    end
    return {}
end

function Recursive_find_key(t, key_to_find, paths, current_path)
    if paths == nil then
        paths = {}
    end
    if current_path == nil then
        current_path = {}
    end

    -- print("current_path:", current_path)
    for key, value in pairs(t) do
        -- print("key:", key)
        -- print("value", value)
        if (key == key_to_find) then
            local path = {}
            table.insert(path, key)
            return path
        end

        if type(value) == "table" then
            local result = Recursive_find_key(value, key_to_find, paths, current_path)
            local next = next
            if next(result) ~= nil then
                local path = {}
                table.insert(path, key .. "." .. result[1])
                return path
            end
        end
    end
    return {}
end
