
// All *statements* in Zig must end with a semicolon ";"

// "{ }" are called block scopes that define the scope of a function, method, etc.

// Top-level declarations are order-independent:
const os = std.os;
const std = @import("std");  // import zig's standard library
const print = std.debug.print;
const assert = @import("std").debug.assert;


export fn add(a: i32, b: i32) i32 {
    return a + b;
}

// "void" implies that the function will not return anything. However, if it's prefixed with a "!", that means it might return an error
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Different ways to print ouptput:
    std.debug.print("Hello world!\n", .{});  // ".{ }" is used to pass the arguments as a tuple
    print("Quick print!\n", .{});  // the more recommended way most of the time

    // because the functions below might return an error, we had to modify the "main" function to return "!void" rather than "void"
    try stdout.print("Try Hello, {s}!\n", .{"world"});
    stdout.print("Catch Hello, {s}!\n", .{"world"}) catch {};


    // Defining varibles:
    const x: i32 = 1;
    const y: f32 = 5.0;
    const result: i32 = add(x, y);  // the constant "y" is going to be mapped to "i32" automatically inside the function "add()"

    print("The sum of {} and {} is {}\n", .{x, y, result});

    }
