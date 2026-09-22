# Introduction

A Result is an object that represents the outcome of an operation. A Result is either `Ok` and contains a value or `Err` and contains an error. Results allow operations to explicitly report whether they succeeded or failed.

```lua
function divide(x, y)
    if y == 0 then
        return Result.err("Cannot divide by 0")
    end

    return Result.ok(x / y)
end
```

# Benefits

Larger codebases benefit from Results mainly due to their conciser and compacter handling of failures. Another benefit is their ability to scale well with the code and ensuring a flatter control flow.

```lua
local success, profile = fetchProfile()

if not success then
    success, profile = retryFetchProfile()

    if not success then
        warn("Failed to retrieve profile:", profile)
        return
    end
end

local lastJoinDate = profile.joinLog[#profile.joinLog]

if lastJoinDate <= cutoffDate then
    local deleted, err = deleteJoinDate(lastJoinDate)

    if not deleted then
        warn("Failed to delete join date:", err)
    end
end
```

```lua
fetchProfile()
    :OrElse(retryFetchProfile)
    :Map(function(profile)
        return profile.joinLog[#profile.joinLog]
    end)
    :AndThen(function(lastJoinDate)
        if lastJoinDate <= cutoffDate then
            return deleteJoinDate(lastJoinDate)
        end

        return Result.ok()
    end)
    :InspectErr(warn)
```

| Category | Without Results | With Results |
| --- | --- | --- |
| Lines of code | 15 | 9-12 (depending on chaining style) |
| Temporary variables | 5 | None |
| Error handling | Manual check after each call | Propagated through the chain |

# Sections

[Install guide](docs/installation.md)  
[API documentation](docs/api.md)  