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

> Wraps a value to represent success or failure by being Ok or Err.

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

> Creates an Ok Result that contains a value.

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

> Creates an Err Result that contains an error.

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

> Transforms the value of an Ok Result into a new Ok Result.

**Notes**

* Err Results do not get transformed and are returned unchanged.  

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Ok Result with the value to transform |
| transformer | (T) -> U | The function that transforms the value |

**Returns**

| Type | Description |
| --- | --- |
| Result<U, E> | The Ok Result with the transformed value |

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

> Transforms the error of an Err Result into a new Err Result.  

**Notes**

* Ok Results do not get transformed and are returned unchanged.  

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Err Result with the error to transform |
| transformer | (E) -> U | The function that transforms the error |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, U> | The Err Result with the transformed error |

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

> Chains a Result-producing function to an Ok Result.  

**Notes**

* Err Results do not invoke the handler and are returned unchanged.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Ok Result to chain onto |
| handler | (T) -> Result<U, E> | The function that returns a Result |

**Returns**

| Type | Description |
| --- | --- |
| Result<U, E> | The Result returned by the handler |

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

> Chains a Result-producing function to an Err Result.  

**Notes**

* Ok Results do not invoke the handler and are returned unchanged.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Err Result to chain onto |
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

> Invokes a function that handles the Result's variant.

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

> Invokes a function with the value of an Ok Result.

**Notes**

* Err Results do not invoke the function.
* Values that are tables are passed by reference.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Ok Result to inspect |
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

> Invokes a function with the error of an Err Result.

**Notes**

* Ok Results do not invoke the function.
* Errors that are tables are passed by reference.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Err Result to inspect |
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

> Returns the value of an Ok Result.  

**Notes**

* Unwrapping an Err Result throws an error.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Ok Result to unwrap |

**Returns**

| Type | Description |
| --- | --- |
| T | The value of the Ok Result |

**Example**

```lua
local result = Result.ok("Apple")

print(result:Unwrap())
```

```text
Apple
```

## UnwrapErr

> Returns the error of an Err Result.  

**Notes**

* Unwrapping an Ok Result throws an error.  

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Err Result to unwrap |

**Returns**

| Type | Description |
| --- | --- |
| E | The error of the Err Result |

**Example**

```lua
local result = Result.err(177)

print(result:UnwrapErr())
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
LogicalError: unwrapping error of Ok Result
```
