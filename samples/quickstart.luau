local Result = require("../src/init.luau")

--[[
    Use Result.ok to represent succes or Result.err to represent failure.

    An ok Result contains a value while an err Result contains an error.

    Developers can decide what exactly the error/value is, e.g. number,
    string, boolean, table, etc.
]]

local okResult = Result.ok({5})
local errResult = Result.err("Something went wrong")

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

--[[
    Use .isOk and .isErr to check the Result variant before e.g. attempting to
    unwrap the Result.
]]

local randomResult = if math.random(1, 2) == 2 then Result.ok("Even") else Result.err("Odd")

randomResult:Unwrap() -- Bad, causes errors due to assuming the Result is always ok.

if randomResult.isOk or not randomResult.isErr then
    randomResult:Unwrap() -- Good, only runs when the Result is ok.
end

--[[
    Use :Map() and :MapErr() to transform the value/error inside a Result.
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
    If the Result is err, the handler is skipped and the err Result is propogated
    automatically.

    :OrElse() works in the same way.
]]

result:OrElse(function(err: never)
    error("fatal error")
end):AndThen(function(value: number)
    return Result.ok(value * 2)
end)

print(result) -- Ok(20)

--[[
    :Inspect() and :InspectErr() are useful for observing a Result without
    changing it.
]]

okResult:Inspect(print) -- 5
errResult:InspectErr(print) -- Fail: Something went wrong

--[[
    Results can be compared directly with ==
]]

print(Result.ok(5) == Result.ok(5)) -- true 
print(Result.ok(5) == Result.ok(10)) -- false 
print(Result.err("Failed") == Result.err("Failed")) -- true 
print(Result.ok(5) == Result.err(5)) -- false