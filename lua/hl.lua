local hl = {}

local config_lines = {}

local function add(line)
    table.insert(config_lines, line)
end

function hl.general(opts)
    add("general {")
    for k, v in pairs(opts) do
        add(string.format("    %s = %s", k, tostring(v)))
    end
    add("}")
end

function hl.decorations(opts)
    add("decoration {")
    for k, v in pairs(opts) do
        add(string.format("    %s = %s", k, tostring(v)))
    end
    add("}")
end

function hl.monitor(opts)
    local name = opts.output or ""
    local res = opts.mode or "preferred"
    local offset = opts.offset or "auto"
    local scale = opts.scale or "1"
    add(string.format("monitor=%s,%s,%s,%s", name, res, offset, scale))
end

function hl.bind(opts)
    local arg = opts.arg or ""
    add(string.format("bind = %s, %s, %s, %s", opts.mod, opts.key, opts.dispatcher, arg))
end

function hl.plugin(path)
    add(string.format("plugin = %s", path))
end

function hl.raw(line)
    add(line)
end

function hl.compile()
    return table.concat(config_lines, "\n")
end

return hl
