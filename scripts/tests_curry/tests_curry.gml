/* Tests currying of functions
 * Kat @Katsaii
 */

// tests currying purity (no mutable state between the same partial function)
var dot = function(_a, _b, _c, _d) {
  return dot_product(_a, _b, _c, _d);
}
var dot_partial = partial(dot, 2, 3);
assert_eq(dot(2, 3, 8, 12), dot_partial(8, 12));
assert_eq(dot(2, 3, 7, 12), dot_partial(7, 12));

// tests basic currying
var prod = function(_a, _b) {
  return _a * _b;
}
var prod_partial = partial(prod, 2);
assert_eq(prod(2, 3), prod_partial(3));

// tests currying a curried function
var custom_print = function(_a, _b, _c) {
  return string(_a) + "izzard the " + string(_b) + " said " + string(_c);
}
var print_partial = partial(custom_print, "mega");
assert_eq(print_partial("brave", "James"), partial(print_partial, "brave")("James"));

// tests uncurrying a curried function
var f = function(_x, _y) { return _x * _y };
var f2 = uncurry(curry(f));
assert_eq(f(1, 2), f2(1, 2));

// tests operator sections
var section = curry(operator("."));
var access = section({ a : 1, b : "x" });
assert_eq(1, access("a"));
assert_eq("x", access("b"));