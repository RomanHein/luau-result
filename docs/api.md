# Overview

### Types

[Result](#result)

### Constructors

[ok](#ok)  
[err](#err)  

### Methods

[Map](#map)  
[MapErr](#maperr)  
[AndThen](#andthen)  
[OrElse](#orelse)  
[Match](#match)  
[Inspect](#inspect)  
[InspectErr](#inspecterr)  
[Unwrap](#unwrap)  
[UnwrapErr](#unwraperr)  

### Properties

[isOk](#isok)  
[isErr](#iserr)  

### Errors

[InvalidArgument](#invalidargument)  
[LogicalError](#logicalerror)  

## Result

> Wraps a value to represent success or failure by being ok or err.

**Type Parameters**

| Name | Description |
| --- | --- |
| T | The type of the value |
| E | The type of the error |

**Example**

```lua
function foo(result: Result.Result<number, string>)
    -- ...
end
```

## ok

> Creates an ok Result that contains a value.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| value | T | The value to contain |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, never> | The ok Result that contains the value |

**Example**

```lua
local result = Result.ok(5)

print(result)
```

```text
Ok(5)
```

## err

> Creates an err Result that contains an error.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| err | E | The error to contain |

**Returns**

| Type | Description |
| --- | --- |
| Result<never, E> | The err Result that contains the error |

**Example**

```lua
local result = Result.err("Something went wrong!")

print(result)
```

```text
Err(Something went wrong!)
```

## Map

> Transforms the value of an ok Result into a new ok Result.   
> Err Results do not get transformed and are returned unchanged.  

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The ok Result with the value to transform |
| transformer | (T) -> U | The function that transforms the value |

**Returns**

| Type | Description |
| --- | --- |
| Result<U, E> | The ok Result with the transformed value or the original err Result |

**Example**

```lua
local result = Result.ok(10)

result = result:Map(function(value)
    return value * 10
end)

print(result)
```

```text
Ok(100)
```

## MapErr

> Transforms the error of an err Result into a new err Result.   
> Ok Results do not get transformed and are returned unchanged.  

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The err Result with the error to transform |
| transformer | (E) -> U | The function that transforms the error |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, U> | The err Result with the transformed error or the original ok Result |

**Example**

```lua
local result = Result.err("Something went wrong!")

result = result:MapErr(function(err)
    return "CriticalError: "..err
end)

print(result)
```

```text
Err(CriticalError: Something went wrong!)
```

## AndThen

> Chains a Result-producing function to an ok Result.  
> Err Results do not invoke the handler and are returned unchanged.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The ok Result to chain onto |
| handler | (T) -> Result<U, F> | The function that returns a Result |

**Returns**

| Type | Description |
| --- | --- |
| Result<U, F> | The Result returned by the handler |

**Example**

```lua
local result = Result.ok(10)

result = result:AndThen(function(value)
    if value > 5 then
        return Result.ok(value * 2)
    end

    return Result.err("Value is too small!")
end)

print(result)
```

```text
Ok(20)
```

## OrElse

> Chains a Result-producing function to an err Result.  
> Ok Results do not invoke the handler and are returned unchanged.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The err Result to chain onto |
| handler | (E) -> Result<T, F> | The function that returns a Result |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, F> | The Result returned by the handler |

**Example**

```lua
local result = Result.err("Mock error")

result = result:OrElse(function(err)
    if err == "Mock error" then
        return Result.ok("Everything is ok")
    end

    return Result.err(err)
end)

print(result)
```

```text
Ok(Everything is ok)
```

## Match

> Invokes the handler that is associated with the Result's variant.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Result to match against |
| handlers | {ok: (T) -> F, err: (E) -> R} | The functions that handle the respective state of the Result |

**Returns**

| Type | Description |
| --- | --- |
| F \| R | The value returned by the handler |

**Example**

```lua
local result = Result.ok(30)

result = result:Match({
    ok = function(value)
        return value * 2
    end,

    err = function(err)
        return err
    end,
})

print(result)
```

```text
60
```

## Inspect

> Invokes a function with the value of an ok Result. Returns the Result unchanged.  
> Err Results do not invoke the function.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The ok Result to inspect |
| inspector | (T) -> () | The function to invoke |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, E> | The original Result |

**Example**

```lua
local result = Result.ok("Hello world!")

result:Inspect(print)
```

```text
Hello world!
```

## InspectErr

> Invokes a function with the error of an err Result. Returns the Result unchanged.  
> Ok Results do not invoke the function.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The err Result to inspect |
| inspector | (E) -> () | The function to invoke |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, E> | The original Result |

**Example**

```lua
local result = Result.err("Something went wrong")

result:InspectErr(warn)
```

```text
Something went wrong
```

## Unwrap

> Returns the value of an ok Result.  
> Unwrapping an err Result throws an error.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The ok Result to unwrap |

**Returns**

| Type | Description |
| --- | --- |
| T | The value of the ok Result |

**Example**

```lua
local result = Result.ok("Apple")
local value = result:Unwrap()

print(value)
```

```text
Apple
```

## UnwrapErr

> Returns the error of an err Result.  
> Unwrapping an ok Result throws an error.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The err Result to unwrap |

**Returns**

| Type | Description |
| --- | --- |
| E | The error of the err Result |

**Example**

```lua
local result = Result.err(177)
local err = result:UnwrapErr()

print(err)
```

```text
177
```

## isOk

> Indicates whether a Result is ok.

**Example**

```lua
local result = Result.ok(50)

print(result.isOk)
```

```text
true
```

## isErr

> Indicates whether a Result is err.

**Example**

```lua
local result = Result.err("Error message")

print(result.isErr)
```

```text
true
```

## InvalidArgument

> Thrown when a function receives an argument that does not satisfy its requirements.

**Example**

```lua
result:Map(0)
```

```text
InvalidArgument: 'transformer' must be a function
```

## LogicalError

> Thrown when an operation is illogical.

**Example**

```lua
okResult:UnwrapErr()
```

```text
LogicalError: unwrapping error of ok Result
```
