/* Higher Order Functions
 * ----------------------
 * Kat @katsaii and danielpancake @danielpancake
 *
 */
 
/// @func into_method(_f)
/// @desc Converts script function into method.
/// @param {Function|Real} _f Method or script function.
/// @returns {Function} Converted method.
function into_method(_f) {
  var type = typeof(_f);
  
  switch (type) {
    case "method":
      return _f;
    
    case "number":
      return method(undefined, _f);
    
    default:
      throw "Cannot convert type " + type + " into a method!";
  }
}

/// @func identity(_x)
/// @desc The identity function.
/// @param {Any} _x The value to return.
/// @returns {Any} Returns the input value.
function identity(_x) {
  return _x;
}

/// @func noop()
/// @desc The no-op function. Takes nothing and returns nothing.
function noop() {
  return undefined;
}

/// @func compose(_f, _g)
/// @desc Makes a composition of two functions.
/// @param {Function} _f The function to feed the result of `g(x)`.
/// @param {Function} _g The function to feed `x`.
/// @returns {Function} The composition of two functions.
function compose(_f, _g) {
  return method(
    {
      f: _f,
      g: _g,
    },
    
    function(_x) {
      return f(g(_x));
    }
  );
}

/// @func partial(_f)
/// @desc Returns a new function with a number of arguments partially applied.
/// @param {Function} _f The function or method to apply currying to.
/// @param {Any} [_args] The arguments to partially apply to the function.
/// @returns {Function} Partially applied function.
function partial(_f) {
  var count = argument_count - 1;
  var args = array_create(count);
  
  var i = count - 1;
  while (i >= 0) {
    args[@ i] = argument[i + 1];
    i--;
  }
  
  return method(
    {
      f: _f,
      len: count,
      closure: args,
    },
    
    function() {
      var args = array_create(len + argument_count);
      array_copy(args, 0, closure, 0, len);
      
      var i = len;
      while (i >= 0) {
        args[@ len + i] = argument[i];
        i--;
      }
      
      return method_call(f, args);
    }
  );
}

/// @func curry(_f)
/// @desc Applies currying to function which accepts two arguments.
/// @param {Function} _f The function or method to apply currying to.
/// @returns {Function}
function curry(_f) {
  return method(
    {
      f: _f,
    },
    
    function(_a) {
      return method(
        {
          f: f,
          a: _a,
        },
        
        function(_b) {
          return f(a, _b);
        }
      );
    }
  );
}


/// @func uncurry(_f)
/// @desc Uncurries a function which returns a higher-order function.
/// @param {Function} _f The function or method to uncurry.
/// @returns {Function}
function uncurry(_f) {
  return method(
    {
      f: _f,
    },
    
    function(_a, _b) {
      return f(_a)(_b);
    }
  );
}

/// @func operator_map()
/// @desc Returns a new ds_map containing operator references.
/// @returns {Id.DsMap<Function>}
function operator_map() {
  var map = ds_map_create();
  
  map[? "+"] = function(_l, _r) { return _l + _r };
  map[? "-"] = function(_l, _r) { return _l - _r };
  map[? "*"] = function(_l, _r) { return _l * _r };
  map[? "/"] = function(_l, _r) { return _l / _r };
  map[? "%"] = function(_l, _r) { return _l % _r };
  map[? "mod"] = map[? "%"];
  map[? "div"] = function(_l, _r) { return _l div _r };
  map[? "|"] = function(_l, _r) { return _l | _r };
  map[? "&"] = function(_l, _r) { return _l & _r };
  map[? "^"] = function(_l, _r) { return _l ^ _r };
  map[? "~"] = function(_x) { return ~_x };
  map[? "<<"] = function(_l, _r) { return _l << _r };
  map[? ">>"] = function(_l, _r) { return _l >> _r };
  map[? "||"] = function(_l, _r) { return _l || _r };
  map[? "or"] = map[? "||"];
  map[? "&&"] = function(_l, _r) { return _l && _r };
  map[? "and"] = map[? "&&"];
  map[? "^^"] = function(_l, _r) { return _l ^^ _r };
  map[? "xor"] = map[? "^^"];
  map[? "!"] = function(_x) { return !_x };
  map[? "not"] = map[? "!"];
  map[? "=="] = function(_l, _r) { return _l == _r };
  map[? "="] = map[? "=="];
  map[? "!="] = function(_l, _r) { return _l != _r };
  map[? "<>"] = map[? "!="];
  map[? ">="] = function(_l, _r) { return _l >= _r };
  map[? "<="] = function(_l, _r) { return _l <= _r };
  map[? ">"] = function(_l, _r) { return _l > _r };
  map[? "<"] = function(_l, _r) { return _l < _r };
  map[? "!!"] = function(_x) { return bool(_x) };
  
  map[? "."] = function(_container, _key) {
    if (is_struct(_container)) {
      return variable_struct_exists(_container, _key)
        ? variable_struct_get(_container, _key)
        : undefined;
    } else {
      return variable_instance_exists(_container, _key)
        ? variable_instance_get(_container, _key)
        : undefined;
    }
  };
  
  map[? "[]"] = function(_container, _key) {
    if (_key >= 0 && _key < array_length(_container)) {
      return _container[_key];
    } else {
      return undefined;
    }
  };
  
  return map;
}

/// @func operator(_op)
/// @desc Returns an operator reference.
/// @param {String} _op
/// @returns {Function}
function operator(_op) {
  static ops = operator_map();
  return ops[? _op];
}
