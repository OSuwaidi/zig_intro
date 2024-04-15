// بسم الله الرحمن الرحيم وبه نستعين

// All *statements* in Zig must end with a semicolon ";"!

// There are no "string" types in Zig, instead, they're represented as an array of bytes: "[_]u8" (array of characters)

// Naming convention in Zig:
// Variables and constants are "snake_case"
// Functions and methods are "camelCase" (the first letter of every word after the first word is capitalized)
// Types, structs, and functions that return a type or struct are "PascalCase"

// When dealing with Zig's constant types, the constant type is always the type that is prefixed the "const" keyword, not after!
// Examples:
// "*const <struct>" --> a constant pointer to a <struct> type ==> the <struct>'s field themselves could change, but the pointer canno't change what it's pointing at!
// "[]const u8" --> a slice consisting of constant data elements of type u8
// "*const []const u8" --> a constant pointer to a slice of constant elements

// "{ }" are called block scopes that define the scope of a function, method, struct, etc.

// To import an *exported* Zig function from Python or C run: "zig build-lib file_name.zig -dynamic -fPIC -O ReleaseFast -femit-bin=library_name.so"
// "-fPIC" == Position Independent Code: implies that the generated machine code is independent on being loaded on a specific memory address (OS can load the library at any address in memory)
// "-dynamic" --> allows the compiled code (.so) to be loaded into different address spaces and share its executable code between multiple running applications, enhancing memory and loading times
// If you omit "-dynamic", you generate a static library (.a) --> all the code from different libraries is included directly into the final executable (linked into the application at compile-time).
// Hence, the resulting executable is larger in size (because all necessary library code is included directly in the app's binary), but it can lead to faster
// runtine performance, as there are no lookup costs associated with dynamic linking. It also doesn't support being shared across multiple applications (each will have its own copy)

// Top-level declarations are order-independent:
const os = std.os;
const std = @import("std"); // import Zig's standard library
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
    std.debug.print("Hello world!\n", .{}); // ".{ }" is used to pass the arguments as a tuple
    print("Quick print!\n", .{}); // the more recommended way most of the time

    // because the functions below might return an error (error union), we had to modify the "main" function to return "!void" rather than "void"
    try stdout.print("Try Hello, {s}!\n", .{"world"}); // "try" is similar to Rust's "unwrap" but for extracting a possible *error* outcome
    stdout.print("Catch Hello, {s}!\n\n", .{"world"}) catch {};

    // Defining varibles
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
    var fixed_str = "Hello World"; // a string literal: is a *constant* pointer to a *constant* array of bytes: "*const [11:0]u8"
    var grow_str: []const u8 = "Hello Variable"; // a slice; a view (pointer) into a section of an array, here, it's a string of *variable* length

    // fixed_str = "New World"; --> this will error, because while the variable name "fixed_str" is mutable, its content (type) is *NOT*; it's a fixed (constant) size array!
    // Hence, newely assigned string must be exactly of the same size (same number of bytes):
    fixed_str = "Okay World?";
    grow_str = "Nice"; // since this is a slice (of dynamic length), it can take up any string value
    // grow_str[0] = 'H'; --> this will error, because although the slice (pointer) is mutable, its contents (bytes) are not!

    print("fixed_str is: {s}\ngrow_str is: {s}\n\n", .{ fixed_str, grow_str });

    //characters:
    const some_char = 'A'; // denoted by single quotation marks: of type "u8" (a byte)
    print("some_char without any format specifier: {}\n", .{some_char}); // by default, it prints its Unicode encoding (65 in this case)
    print("some_char with \"u\" format specifier: {u}\n\n", .{some_char}); // "u" is for unicode character while "c" is for ASCII character

    var byte_array = [_]u8{ 'h', 'e', 'y' }; // initialize a mutable array of three (inferred), single byte (8-bit) characters: "[3]u8"
    byte_array[0] = 'w';
    print("byte_array is now: {s}\n\n", .{byte_array});

    // optional:
    var optional_var: ?[]const u8 = null; // prefixing the data type with a "?" implies it's an optional value (type union null)
    assert(optional_var == null);
    print("optional_var 1 holds: {any}\nand is of type: {}\n\n", .{ optional_var, @TypeOf(optional_var) });

    optional_var = "hi";
    assert(optional_var != null);
    // ".?" is the *unpacking* operator which unpacks an optional type and will panic if the unpacked value is null!
    print("optional_var 2 holds: {?s}\nand is of type: {}, but type {} when unpacked.\n\n", .{ optional_var, @TypeOf(optional_var), @TypeOf(optional_var.?) });

    // error union:
    var number_of_error: anyerror!i32 = error.ArgNotFound;
    print("error 1\nvalue: {!}\ntype: {}\n\n", .{ number_of_error, @TypeOf(number_of_error) });

    number_of_error = 1234;
    print("error 2\nvalue: {!}\ntype: {}\n\n", .{ number_of_error, @TypeOf(number_of_error) });

    // pointers:
    var some_int: i32 = 100;
    const ptr = &some_int; // returns the address of the variable which in this case is of type "*i32"
    print("The address of some_int in memory is: {*},\nwith the pointer pointing to the value: {}\n\n", .{ ptr, ptr.* }); // dereference the pointer via ".*"

    // What's the point (use) of pointers?
    var float1: f32 = 0;
    var float2: f32 = 0;
    print("Original values of float1 and float2 are: {d}, {d}\nwith their stored addresses at: {}, {}.\n\n", .{ float1, float2, &float1, &float2 });

    passByValueManip(float1, float2);
    print("After first function, values of float1 and float2 are still: {d}, {d}.\n\n", .{ float1, float2 });

    passByReferenceManip(&float1, &float2); // pass the variables' memory addresses rather than their values!
    print("After second function, values of float1 and float2 are now: {d}, {d}.\n", .{ float1, float2 });

    // "for" loops:
    var numbers = [_]u8{ 1, 2, 3 };

    // Capture elements by value (copy):
    for (numbers) |n| { // variable "n" is called the "captured" value
        _ = n; // "n: u8" here is a created copy of each element in "numbers"
    }

    // Capture elements by copied "read-only" reference (pratically same as the above, just there for convenience):
    for (&numbers) |n| {
        _ = n; // "n: u8" here is a *copied* accessed (read) value (dereferenced pointer) of each element in "numbers"
    }

    // Capture elements by "write" reference:
    for (&numbers) |*n| {
        _ = n; // "n: *u8" here is a pointer capture value of each element in "numbers" that can be dereferenced via "n.*"
    }

    // Invalid:
    // for (numbers) |*n| {
    //     // error: pointer capture of non pointer type
    // }

    // ***Note***
    // Variables defined within a block of code only live (exist) within that block of code!
    // example 1:
    if (true) {
        const fish = "salmon";
        _ = fish; // variable must be used somehow...
    }
    // print("where is fish? {}\n", .{fish}); -->  error: use of undeclared identifier 'fish'

    // example 2:
    for (numbers, 0..) |_, i| { // you can create a loop variable "i" that enumerates the looped over iterable
        const fish = "salmon";
        _ = i;
        _ = fish;
    }
    // print("where is fish? {}\n", .{fish}); -->  error: use of undeclared identifier 'fish'
}

// By default, arguments are passed by into functions by *value*, meaning a *copy* of each argument is created when it's passed into a function
fn passByValueManip(x: f32, y: f32) void {
    print("Addresses of x (float1) and y (float2) are: {}, and {}, respectively.\nNotice that the addresses are different than the original variables because they're a copy!\n", .{ &x, &y });
    // In Zig, function arguments are immutable by default, hence you cannot directly modify their values (unlike in C)!
    // a += 20;  -> error: cannot assign to constant
    // b = 10;  --> error: cannot assign to constant
    // _ = a + b; // must use the function's arguments
}

fn passByReferenceManip(x: *f32, y: *f32) void {
    print("Addresses of x (float1) and y (float2) are: {}, and {}, respectively.\nNotice that now since we're using pointers, they're the same addresses as the original varaibles!\n", .{ x, y });
    // Access the variables' original value in memory by dereferencing the pointers pointing to their address in memory
    x.* = 99;
    y.* = 10;
    return undefined; // "undefined" is the same as "void", whereas "null" is a value representing the *absence* of a value!
}
