/* Tests currying of functions
 * Kat @Katsaii
 */

var f;
var g;

// tests built-in function references
f = into_method(array_create);
assert_eq([0, 0, 0], f(3));

// tests the identity function
assert_eq("2", identity("2"));

// tests function composition
f = into_method(string_upper);
g = function(_x) { return _x + "!" };
var fg = compose(f, g);
assert_eq("SHOUTING!", fg("shouting"));
