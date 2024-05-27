local M = {}

M._stack = {}

-- M.setup = function(opts)
--  print("options:",opts)
-- end


-- vim.api.nvim_get_keymap(...)

local find_mapping = function(maps, lhs)
  for _, value in ipairs(maps) do
    if value.lhs == lhs then
      return value
    end
  end
end

M.push = function(name, mode, mappings)
  local maps = vim.api.nvim_get_keymap(mode)

  local existing_maps = {}
  for lhs, rhs in pairs(mappings) do
    local existing = find_mapping(maps,lhs)
    if existing then
      table.insert(existing_maps, existing)
    end
  end
  -- P(existing_maps)
  M._stack[name] = existing_maps

  for lhs, rhs in pairs(mappings) do
    -- Need some way to pass in options here
    vim.keymap.set(mode,lhs,rhs)
  end
end

M.pop = function(name)
end


M.push("debug_mode", "n", {
  [" h"] = "echo 'Hello'",
  [" g"] = "echo 'Goodbye'",
})

return M
