--[[
	Result.luau
	
	An object that wraps values to represent success or failure.
]]

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

type ResultClass = {
	ok: typeof(
		--[[
			Creates a new ok Result containing the value.
		]]
		function<T>(value: T): Result<T, never>
		end
	),

	err: typeof(
		--[[
			Creates a new err Result containing the error.
		]]
		function<E>(err: E): Result<never, E>
		end
	),
}

export type Result<T, E> = {
	Map: typeof(
		--[[
			Transforms the value of the Result and returns the changes in a new ok
			Result. If the result is err

			Transforms the value of the Result and returns a new ok Result
			containing the transformed value. If the Result is err, it is returned instead.
		]]
		function(result: Result<T, E>, transformer: (value: T) -> any): Result<T, E>
		end
	),

	MapErr: typeof(
		--[[
			Transforms the error of the err Result and returns a new err Result
			containing the transformed error. 
			If the Result is ok, it is returned instead.
		]]
		function(result: Result<T, E>, transformer: (err: E) -> any): Result<T, E>
		end
	),

	AndThen: typeof(
		--[[
			Passes the value of the ok Result to the handler and returns the Result
			returned by the handler.
			If the Result is err, it is returned instead.
		]]
		function(result: Result<T, E>, handler: (value: T) -> Result<T, E>): Result<T, E>
		end
	),

	OrElse: typeof(
		--[[
			Passes the error of the err Result to the handler and returns the Result
			returned by the handler.
			If the Result is ok, it is returned instead.
		]]
		function(result: Result<T, E>, handler: (err: E) -> Result<T, E>): Result<T, E>
		end
	),

	Match: typeof(
		--[[
			Calls the ok handler if the Result is ok, or the err handler if the Result
			is err, and returns the handler's returned value.
		]]
		function<R, F>(result: Result<T, E>, results: {ok: (value: T) -> R, err: (err: E) -> F}): R | F
		end
	),

	Inspect: typeof(
		--[[
			Calls the inspector with the value of the ok Result without modifying it and
			returns the Result. 
			If the Result is err, the inspector will not be called.
		]]
		function(result: Result<T, E>, inspector: (value: T) -> ()): Result<T, E>
		end
	),

	InspectErr: typeof(
		--[[
			Calls the inspector with the error of the err Result without modifying it and
			returns the Result. 
			If the Result is ok, the inspector will not be called.
		]]
		function(result: Result<T, E>, inspector: (err: E) -> ()): Result<T, E>
		end
	),

	Unwrap: typeof(
		--[[
			Returns the value of the ok Result.
			If the Result is err, an error is thrown.
		]]
		function(result: Result<T, E>): T
		end
	),

	UnwrapErr: typeof(
		--[[
			Returns the error of the err Result.
			If the Result is ok, an error is thrown.
		]]
		function(result: Result<T, E>): E
		end
	),

	isOk: boolean,
	isErr: boolean,
}

--------------------------------------------------------------------------------
-- IMPLEMENTATION
--------------------------------------------------------------------------------

local Result = {} :: ResultClass

function Result.ok(value)
	return setmetatable({
		_isOk = true,
		_value = value,
	}, Result)
end

function Result.err(err)
	return setmetatable({
		_isOk = false,
		_err = err,
	}, Result)
end

function Result:Map(transformer)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(transformer) ~= "function" then
		error("InvalidArgument: 'transformer' must be a function", 2)
	end

	if not self._isOk then
		return self
	end

	return Result.ok(transformer(self._value))
end

function Result:MapErr(transformer)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(transformer) ~= "function" then
		error("InvalidArgument: 'transformer' must be a function", 2)
	end

	if self._isOk then
		return self
	end

	return Result.err(transformer(self._err))
end

function Result:AndThen(handler)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(handler) ~= "function" then
		error("InvalidArgument: 'handler' must be a function", 2)
	end

	if not self._isOk then
		return self
	end

	local result = handler(self._value)

	if getmetatable(result) ~= Result then
		error("InvalidArgument: 'handler' must return a Result", 2)
	end

	return result
end

function Result:OrElse(handler)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(handler) ~= "function" then
		error("InvalidArgument: 'handler' must be a function", 2)
	end

	if self._isOk then
		return self
	end

	local result = handler(self._err)

	if getmetatable(result) ~= Result then
		error("InvalidArgument: 'handler' must return a Result", 2)
	end

	return result
end

function Result:Match(handlers)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(handlers) ~= "table" or type(handlers.ok) ~= "function" or type(handlers.err) ~= "function" then
		error("InvalidArgument: 'handlers' must be a table containing functions 'ok' and 'err'", 2)
	end

	if self._isOk then
		return handlers.ok(self._value)
	end

	return handlers.err(self._err)
end

function Result:Inspect(inspector)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(inspector) ~= "function" then
		error("InvalidArgument: 'inspector' must be a function", 2)
	end

	if self._isOk then
		inspector(self._value)
	end

	return self
end

function Result:InspectErr(inspector)
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if type(inspector) ~= "function" then
		error("InvalidArgument: 'inspector' must be a function", 2)
	end

	if not self._isOk then
		inspector(self._err)
	end

	return self
end

function Result:Unwrap()
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if not self._isOk then
		error("LogicalError: unwrapping value of err Result", 2)
	end

	return self._value
end

function Result:UnwrapErr()
	if getmetatable(self) ~= Result then
		error("InvalidArgument: 'result' must be a Result", 2)
	end

	if self._isOk then
		error("LogicalError: unwrapping error of ok Result", 2)
	end

	return self._err
end

--------------------------------------------------------------------------------
-- METAMETHODS
--------------------------------------------------------------------------------

function Result:__index(index)
	if index == "isOk" then
		return self._isOk
	end

	if index == "isErr" then
		return not self._isOk
	end

	return Result[index]
end

function Result:__newindex(index, value)
	if index == "isOk" or index == "isErr" then
		error("LogicalError: assignment to read-only property", 2)
	end

	rawset(self, index, value)
end

function Result:__tostring()
	if self._isOk then
		return string.format("Ok(%s)", tostring(self._value))
	end

	return string.format("Err(%s)", tostring(self._err))
end

function Result:__eq(other)
	if getmetatable(other) ~= Result then
		return false
	end

	if self._isOk ~= other._isOk then
		return false
	end

	if other._isOk then
		return self._value == other._value
	end

	return self._err == other._err
end

return Result