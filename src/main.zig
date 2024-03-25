
// All *statements* in Zig must end with a semicolon ";"

// "{ }" are called block scopes that define the scope of a function, method, etc.

// Top-level declarations are order-independent:
const os = std.os;
const std = @import("std");  // import zig's standard library
const print = std.debug.print;
const stdout = std.io.getStdOut().writer();
const assert = @import("std").debug.assert;

// "export" makes the function accessible from outside the compiled binary (with C linkage)
export fn add(a: i32, b: i32) i32 {
    return a + b;
}

// A function without a prefix implies it's private to the file (only accessibile within current file)
fn modulo(a: u32, b: u32) u32 {
    return a % b;
}

// "pub" makes the function accessible from other files within the same project
// "void" implies that the function will not return anything. However, if it's prefixed with a "!", that means it might return an error
pub fn main() !void {
    // Different ways to print ouptput:
    std.debug.print("Hello world!\n", .{});  // ".{ }" is used to pass the arguments as a tuple
    print("Quick print!\n", .{});  // the more recommended way most of the time

    // because the functions below might return an error, we had to modify the "main" function to return "!void" rather than "void"
    try stdout.print("Try Hello, {s}!\n", .{"world"});
    stdout.print("Catch Hello, {s}!\n\n", .{"world"}) catch {};


    // Defining varibles:
        // constant numerics:
        const x: i32 = 1;
        const y: f32 = 5.0;
        const result: i32 = add(x, y);  // the constant "y" is going to be mapped to "i32" automatically inside the function "add()"
        print("The sum of {} and {} is {}\n", .{x, y, result});

        // mutable numerics:
        var p: u32 = 10;
        var q: u32 = 1;
        p = 9; q = 3;
        print("{} modulo {} is {}\n\n", .{p, q, modulo(p, q)});

        // boolean:
        const not_true: bool = !true;
        const is_true = true;
        print("not_true value: {}\n", .{not_true});
        print("and operation = {}\nor operation = {}\n\n", .{not_true and is_true, not_true or is_true});

        // strings:
        const fixed_str = "Hello World";  // "*const [11:0]u8" ==> a pointer to a constant array of bytes
        const var_str: []const u8 = "Hello Variable"; // a slice; a view into a section of an array, here, it's a string of variable length
        print("The fixed size fixed_str is: {s}\nand the variable size var_str is: {s}\n", .{fixed_str, var_str});

        //characters:
        const some_char = 'A';  // of type u8 (a byte)
        print("some_char is: {}\n", .{some_char});  // by default, it prints its Unicode encoding (65 in this case)
        print("some_char is now: {c}\n\n", .{some_char});

        // optional:
        var optional_var: ?[]const u8 = null;  // prefixing the data type with a "?" implies it's an optional value
        assert(optional_var == null);
        print("optional_var 1 holds: {any}\nand is of type: {}\n\n", .{optional_var, @TypeOf(optional_var)});

        optional_var = "hi";
        assert(optional_var != null);
        print("optional_var 2 holds: {?s}\nand is of type: {}\n\n", .{optional_var, @TypeOf(optional_var)});

        // error union:
        var number_of_error: anyerror!i32 = error.ArgNotFound;
        print("error 1\nvalue: {!}\ntype: {}\n\n", .{number_of_error, @TypeOf(number_of_error)});

        number_of_error = 1234;
        print("error 2\nvalue: {!}\ntype: {}\n\n", .{number_of_error, @TypeOf(number_of_error)});

        // pointers:
        var some_int: i32 = 100;
        const ptr = &some_int;  // type "*i32"
        print("The address of some_int in memory is: {}\nwith pointer pointing to value: {}\n", .{ptr, ptr.*}); // dereference the pointer

    }
