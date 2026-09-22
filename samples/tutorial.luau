local Result = require("../source/init.luau")


-- 1.
--[[
    Use Result.ok to represent success or Result.err to represent failure.

    An ok Result contains a value while an err Result contains an error.

    Developers can decide what exactly the error/value is, e.g. number,
    string, boolean, table, etc.
]]

local okResult = Result.ok({5})
local errResult = Result.err("Something went wrong")

-- 2.
--[[
    Use :Unwrap() and :UnwrapErr() to extract the value/error from a Result.
]]

local value = okResult:Unwrap()
local err = errResult:UnwrapErr()

print(value) -- {5}
print(err) -- Something went wrong

--[[
    Trying to unwrap the wrong variant throws an error.
]]

okResult:UnwrapErr() -- Throws an error.
errResult:Unwrap() -- Throws an error.

-- 3.
--[[
    Use .isOk and .isErr to check the Result variant.
]]

local randomResult = if math.random(1, 2) == 2 then Result.ok("Even") else Result.err("Odd")

if randomResult.isOk then
    randomResult:Unwrap()
end

-- 4.
--[[
    Use :Map() and :MapErr() to transform the value/error inside the Result.
]]

okResult = okResult:Map(function(value: {number})
    return value[1]
end)

errResult = errResult:MapErr(function(err: string)
    return string.format("Fail: %s", err)
end)

print(okResult) -- Ok(5)
print(errResult) -- Err(Fail: Something went wrong)

--[[
    The transformer is not called if the Result variant is wrong.
]]

errResult = errResult:Map(function(value: never)
    return 1
end)

print(errResult) -- Err(Fail: Something went wrong)

-- 5.
--[[
    Use :Match() to process both variants of the Result safely.
]]

local value = okResult:Match({
    ok = function(value)
        return value + 1
    end,

    err = function(err)
        return -1
    end,
})

print(value) -- 6

-- 6.
--[[
    Use :AndThen() and :OrElse() when the next operation itself returns a
    Result.
]]

local result = Result.ok(5):AndThen(function(value: number)
    if value > 0 then
        return Result.ok(value * 2)
    end

    return Result.err("Value must be positive")
end)

print(result) -- Ok(10)

--[[
    If the Result is err, the handler is skipped and the err Result is propagated
    automatically.

    :OrElse() works in the same way.
]]

result:OrElse(function(err: never)
    error("fatal error")
end):AndThen(function(value: number)
    return Result.ok(value * 2)
end)

print(result) -- Ok(20)

-- 7.
--[[
    :Inspect() and :InspectErr() are useful for observing a Result without
    changing it.
]]

okResult:Inspect(print) -- 5
errResult:InspectErr(print) -- Fail: Something went wrong

-- 8.
--[[
    Results can be compared directly with ==

    Equality is determined by comparing the values/errors with luau's == operator
    and comparing the variants of both Results.
]]

print(Result.ok(5) == Result.ok(5)) -- true 
print(Result.ok(5) == Result.ok(10)) -- false 
print(Result.err("Failed") == Result.err("Failed")) -- true 
print(Result.ok(5) == Result.err(5)) -- false