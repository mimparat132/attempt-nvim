
local find_map = function(maps, lhs)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return map
        end
    end
end

describe("mapstack", function()
  it("can be required", function()
    require ("stackmap")
  end)
end)

describe("mapstack", function()
    local rhs = "echo 'this is a test'"
    it("can push a single mapping", function()
    require("stackmap").push("test", "n", {
        asdfasdf = rhs,
    })

    local maps = vim.api.nvim_get_keymap('n')
    local found = find_map(maps,"asdfasdf")
    assert.are.same(rhs,found.rhs)
    end)
end)
