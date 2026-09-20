# Overview

### Types

[Result](#result)

### Constructor

[ok](#ok)  
[err](#err)  

### Methods

[Map](#map)  
[MapErr](#maperr)  
AndThen  
OrElse  
Match  
Inspect  
InspectErr  
Unwrap  
UnwrapErr  

### Properties

isOk  
isErr  

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

```lua
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

```lua
Err(Something went wrong!)
```

## Map

> Transforms the value inside an ok Result and returns the tranformed value in a new ok Result.  
> Transformation is skipped on err Results and the Result is returned unchanged.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Result to transform |
| transformer | (T) -> U | The function that transforms the value |

**Returns**

| Type | Description |
| --- | --- |
| Result<U, E> | The ok Result that contains the transformed value or the original err Result |

**Example**

```lua
local result = Result.ok(10)

local newResult = result:Map(function(value)
    return value * 10
end)

print(result)
print(newResult)
```

```lua
Ok(10)
Ok(100)
```

## MapErr

> Transforms the error inside an err Result and returns the tranformed error in a new err Result.  
> Transformation is skipped on ok Results and the Result is returned unchanged.

**Parameters**

| Name | Type | Description |
| --- | --- | --- |
| result | Result<T, E> | The Result to transform |
| transformer | (E) -> U | The function that transforms the error |

**Returns**

| Type | Description |
| --- | --- |
| Result<T, U> | The err Result that contains the transformed error or the original ok Result |

**Example**

```lua
local result = Result.err("Something went wrong!")

local newResult = result:MapErr(function(err)
    return "CriticalError: "..err
end)

print(result)
print(newResult)
```

```lua
Err(Something went wrong!)
Err(CriticalError: Something went wrong!)
```

## InvalidArgument

> Thrown when a function receives an argument that does not satisfy its requirements.

**Example**

```lua
result:Map(0)
```

```lua
InvalidArgument: 'transformer' must be a function
```

## LogicalError

> Thrown when an operation is illogical.

**Example**

```lua
okResult:UnwrapErr()
```

```lua
LogicalError: unwrapping error of ok Result
```