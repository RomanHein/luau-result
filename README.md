# What is a Result?

A Result is an object which wraps around values to represent success or failure.

A Result has two variants, either it is an ok Result or an err Result. The variant ultimately decides whether it stores a value or an error.

Results offer many methods to comfortably and safely manipulate, extract or inspect the stored value or error.

# Why should I use it?

If you find yourself constantly checking for failures or writing deeply nested code, Results can make the control flow more concise and easier to follow.

```lua
local success, user = fetchUser()

if not success then
    return false, nil
end

local success2, profile = fetchProfile(user.id)

if not success2 then
    return false, nil
end

return true, profile.displayName
```

```lua
return fetchUser()
    :Map(function(user)
        return user.id
    end)
    :AndThen(fetchProfile)
    :Map(function(profile)
        return profile.displayName
    end)
```

# Sections

[Tutorial with code samples](samples/tutorial.luau)  
[Install guide](docs/Installation.md)  
[API documentation](docs/API.md)
