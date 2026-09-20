local Result = require("../source/init.luau")

function someErrorProneFunction()
    return Result.err("Something went wrong!")
end

someErrorProneFunction()
    :InspectErr(print)
    :OrElse(function(err)
        return Result.ok({msg = "Recovered from error!", value = 2})
    end)
    :Inspect(print)
    :Map(function(value)
        return value.value
    end)
    :Match({
        ok = function(value)
            print(value)
        end,

        err = function(err)
            error(err)
        end,
    })