# Introduction

A Result is an object that represents the success or failure of an operation.

It can be imagined as an object that contains a boolean and a value. The boolean indicates whether the value represents the successful result of an operation or an error. This allows operations that are prone to failure to explicitly communicate whether they succeeded, while carrying the corresponding value or error with them.

# Benefits

Larger codebases benefit from Results mainly due to their conciser and compacter way of handling failure-prone code, and encouraging developers to write better code.

The code snippets below demonstrate the advantages Results yield in a failure prone environment in comparison to a traditional implementation, both accomplish the same task.

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
| Error handling | Manual check after each call | Centralized in `InspectErr` |

# Sections

[Install guide](docs/installation.md)  
[API documentation](docs/api.md)  