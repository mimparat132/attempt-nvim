local yaml = require('lyaml')
local file = io.open("helmrelease.metallb.yaml","r")
local content = file:read("*all")
file:close()

local data = yaml.load(content)

local function recursive_print(table)
    for key,value in pairs(table) do
        if type(value) == "table" then
            print(key,value)
            recursive_print(value)
        else
            print(key,value)
        end
    end
end

print("printing the data table at the beginning...\n")

recursive_print(data)

print("\nFinding and building the path...\n")

-- current_path = array with each element a node in the path.
-- paths = array of paths
-- value_to_find = value we are looking for
-- t = input table
local function recursive_find(t, value_to_find, paths, current_path)
    if paths == nil then
        paths = {}
    end
    if current_path == nil then
        current_path = {}
    end

    print("current_path:", current_path)
    for key, value in pairs(t) do
        print("key:", key)
        print("value", value)
        if (type(value) ~= "table") and (value == value_to_find) then
            print("found the value, adding current path to paths and returning")
            -- table.insert(current_path,key)
            -- table.insert(paths,current_path)
            local res = {}
            table.insert(res,key)
            return res
        end

        if type(value) == "table" then
            -- table.insert(current_path,key)
            local result = recursive_find(value, value_to_find, paths, current_path)
            local next = next
            if next(result) ~= nil then
                local path = {}
                table.insert(path,key .. "." .. result[1])
                return path
            end
        end
    end
    return {}
end


local output = recursive_find(data,"This is the target value")

print("printing output table...")
print(output[1])
-- recursive_print(output)
-- for index,stuff in ipairs(output) do
--     -- print(index)
--     for key,value in pairs(stuff) do
--         print(key, value)
--     end
-- end

-- local function recursive_find(t, value_to_find, paths, current_path)
--     if paths == nil then
--         paths = {}
--     end
--     if current_path == nil then
--         current_path = {}
--     end
-- 
--     print("current_path:", current_path)
--     for key, value in pairs(t) do
--         print("key:", key)
--         print("value", value)
--         if (type(value) ~= "table") and (value == value_to_find) then
--             print("found the value, adding current path to paths and returning")
--             table.insert(current_path,key)
--             table.insert(paths,current_path)
--             return paths
--         end
-- 
--         if type(value) == "table" then
--             -- table.insert(current_path,key)
--             local result = recursive_find(value, value_to_find, paths, current_path)
--             local next = next
--             if next(result) ~= nil then
--                 return result
--             end
--         end
--     end
--     return {}
-- end
