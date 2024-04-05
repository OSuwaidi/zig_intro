// بسم الله الرحمن الرحيم وبه نستعين

// All *statements* in Zig must end with a semicolon ";"!
// Variables in Zig are snake_case, while functions are camelCase (the first letter of every word after the first word is capitalized)

// "{ }" are called block scopes that define the scope of a function, method, struct, etc.

// Top-level declarations are order-independent:
const os = std.os;
const std = @import("std"); // import Zig's standard library
const print = std.debug.print;
const stdout = std.io.getStdOut().writer();
const assert = @import("std").debug.assert;

// "export" makes the function accessible from outside the compiled binary (with C linkage)
// To import a Zig function from Python or C run: "zig build-lib file_name.zig -dynamic -O ReleaseFast -femit-bin=file_name.so"
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
    std.debug.print("Hello world!\n", .{}); // ".{ }" is used to pass the arguments as a tuple
    print("Quick print!\n", .{}); // the more recommended way most of the time

    // because the functions below might return an error (error union), we had to modify the "main" function to return "!void" rather than "void"
    try stdout.print("Try Hello, {s}!\n", .{"world"}); // "try" is similar to Rust's "unwrap" but for extracting a possible *error* outcome
    stdout.print("Catch Hello, {s}!\n\n", .{"world"}) catch {};

    // Defining varibles:
    // constant numerics:
    const x: i32 = 1;
    const y: f32 = 5.0;
    const result: i32 = add(x, y); // the constant "y" is going to be mapped to "i32" automatically inside the function "add()"
    print("The sum of {} and {:.1} is {}\n", .{ x, y, result });

    // mutable numerics:
    var p: u32 = 10;
    var q: u32 = 1;
    p = 9;
    q = 3;
    print("{} modulo {} is {}\n\n", .{ p, q, modulo(p, q) });

    // boolean:
    const not_true: bool = !true;
    const is_true = true;
    print("not_true value: {}\n", .{not_true});
    print("and operation = {}\nor operation = {}\n\n", .{ not_true and is_true, not_true or is_true });

    // strings:
    const fixed_str = "Hello World"; // "*const [11:0]u8" ==> a pointer to a constant, *fixed* array of bytes
    const grow_str: []const u8 = "Hello Variable"; // a slice; a view into a section of an array, here, it's a string of *variable* length
    print("The fixed size fixed_str is: {s}\nand the variable size var_str is: {s}\n\n", .{ fixed_str, grow_str });

    //characters:
    const some_char = 'A'; // of type u8 (a byte)
    print("some_char is: {}\n", .{some_char}); // by default, it prints its Unicode encoding (65 in this case)
    print("some_char is now: {c}\n", .{some_char});

    var byte_array: [3]u8 = .{ 'h', 'e', 'y' }; // initialize a mutable array of three, single byte (8-bit) characters
    byte_array[0] = 'x';
    print("byte_array is now: {s}\n\n", .{byte_array});

    // optional:
    var optional_var: ?[]const u8 = null; // prefixing the data type with a "?" implies it's an optional value (type union null)
    assert(optional_var == null);
    print("optional_var 1 holds: {any}\nand is of type: {}\n\n", .{ optional_var, @TypeOf(optional_var) });

    optional_var = "hi";
    assert(optional_var != null);
    // ".?" is the *unpacking* operator which unpacks an optional type and will panic if the unpacked value is null!
    print("optional_var 2 holds: {?s}\nand is of type: {}, but type {} when unpacked.\n\n", .{ optional_var, @TypeOf(optional_var) , @TypeOf(optional_var.?)});

    // error union:
    var number_of_error: anyerror!i32 = error.ArgNotFound;
    print("error 1\nvalue: {!}\ntype: {}\n\n", .{ number_of_error, @TypeOf(number_of_error) });

    number_of_error = 1234;
    print("error 2\nvalue: {!}\ntype: {}\n\n", .{ number_of_error, @TypeOf(number_of_error) });

    // pointers:
    var some_int: i32 = 100;
    const ptr = &some_int; // return the address of the variable which in this case is of type "*i32"
    print("The address of some_int in memory is: {},\nwith the pointer pointing to the value: {}\n\n", .{ ptr, ptr.* }); // dereference the pointer via ".*"

    // What's the point (use) of pointers?
    var float1: f32 = 0;
    var float2: f32 = 0;
    print("Original values of float1 and float2 are: {d}, {d}\nwith their stored addresses at: {}, {}.\n\n", .{ float1, float2, &float1, &float2 });

    passByValueManip(float1, float2);
    print("After first function, values of float1 and float2 are still: {d}, {d}.\n\n", .{ float1, float2 });

    passByReferenceManip(&float1, &float2); // pass the variables' memory addresses rather than their values!
    print("After second function, values of float1 and float2 are now: {d}, {d}.\n", .{ float1, float2 });
}

// By default, arguments are passed by into functions by *value*, meaning a *copy* of each argument is created when it's passed into a function
fn passByValueManip(x: f32, y: f32) void {
    print("Addresses of x (float1) and y (float2) are: {}, and {}, respectively.\nNotice that the addresses are different than the original variables because they're a copy!\n", .{ &x, &y });
    // In Zig a function's arguments are immutable by default, hence you cannot directly modify their values (unlike in C)!
    // a += 20;  -> error: cannot assign to constant
    // b = 10;  --> error: cannot assign to constant
    // _ = a + b; // must use the function's arguments
}

fn passByReferenceManip(x: *f32, y: *f32) void {
    print("Addresses of x (float1) and y (float2) are: {}, and {}, respectively.\nNotice that now since we're using pointers, they're the same addresses as the original varaibles!\n", .{ x, y });
    // Access the variables' original value in memory by dereferencing the pointers pointing to their address in memory
    x.* = 99;
    y.* = 10;
    return undefined; // "undefined" is the same as "void", but "null" is a value representing the *absence* of a value!
}
