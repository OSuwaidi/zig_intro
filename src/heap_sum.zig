// بسم الله الرحمن الرحيم وبه نستعين

const std = @import("std");
const print = std.debug.print;

fn sumNums(iterator: anytype) !f32 {
    var sum: f32 = 0;

    // The ".next()" method of the iterator ***modifies (mutates)*** the internal state of the iterator to advance it to the next element, hence, it has to be "var"!
    while (iterator.next()) |number| {
        sum += std.fmt.parseFloat(f32, number) catch |err| {
            print("Failed to parse number: \"{s}\", with error: {!}\n", .{ number, err });
            continue;
        };
    }

    return sum;
}

pub fn main() !void {
    print("Enter numbers separated by whitespaces:\n", .{});
    // Heap allocate via the "arena" allocation strategy:
    // It reserves a big chunk of memory in *contiguous blocks* upfront, then parcels out smaller, variable-sized pieces of memory via "bump" allocation *as requested*
    // Once the arena allocator is destroyed or freed (at scope exist), *all* of the allocated memory is automatically freed; no individual memory deallocation!
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator); // the arena allocator allocates a contiguous chunk of 8 bytes (64 bits) initially by default
    defer print("Arena's deallocation result: {}\n", .{arena.deinit()}); // print status and clean up all memory allocated through the arena at the end (exit) of this scope

    // The logging Allocator logs all memory allocations (and their sizes), expansions, shrinks, and frees
    var logging_alloc = std.heap.loggingAllocator(arena.allocator()); // the ".allocator()" method returns an "mem.Allocator" interface type

    // Continously read and parse user input:
    while (true) {
        // The "ArrayList" struct borrows memory from the specified allocator but will internally manage that memory independently (it internally stores a "std.mem.Allocator")
        var array = std.ArrayList(u8).init(logging_alloc.allocator()); // has ".items", ".capacity", and ".allocator" fields
        defer array.deinit(); // will deallocate the array's memory at the end of each iteration

        try std.io.getStdIn().reader().streamUntilDelimiter(array.writer(), '\n', null); // last argument specifies maximum read size (unbounded)

        const trimmed_string: []const u8 = std.mem.trim(u8, array.items, " "); // ".items" is a *growable* slice: "[]u8"

        if (std.mem.eql(u8, trimmed_string, "q")) {
            print("Existing program...\n", .{});
            break;
        }

        var numbers = std.mem.tokenize(u8, trimmed_string, " "); // returns an iterator

        print("Sum of the numbers: {d:.2}\n", .{try sumNums(&numbers)});
    }
}
