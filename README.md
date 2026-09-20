# Introduction

Wraps a value to exclusively represent success or failure.  

# Benefits

Larger codebases benefit from Results mainly due to their conciser and compacter way of handling failure-prone code, and encouraging developers to write better code.

The code snippets below demonstrate the advantages Results yield in comparison to a traditional implementation.

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

Results flattened the control flow, reduced variable clutter, and separated error propagation from the successful data-processing logic.

# Sections

[API documentation](docs/API.md)