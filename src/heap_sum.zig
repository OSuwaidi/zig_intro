// بسم الله الرحمن الرحيم وبه نستعين

const std = @import("std");
const print = std.debug.print;

fn sumNums(iterator: anytype) !f32 {
    var sum: f32 = 0;

    // The ".next()" method of the iterator ***modifies (mutates)*** the internal state of the iterator to advance it to the next element, hence, it has to be "var"!
    while (iterator.next()) |number| {
        sum += std.fmt.parseFloat(f32, number) catch |err| {
            print("Invalid number: \"{s}\", with error: {}\n", .{ number, err });
            continue;
        };
    }

    return sum;
}

pub fn main() !void {
    print("Enter numbers separated by whitespaces:\n", .{});
    // Heap allocate via the "arena" allocation strategy:
    // It reserves a big chunk of memory in *contiguous blocks* upfront, then parcels out smaller, variable-sized pieces of memory via "bump" allocation as requested
    // Once the arena allocator is destroyed or freed (at scope exist), *all* the allocated memory is automatically freed; no individual memory deallocation
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator); // the arena allocator allocates a contiguous chunk of 8 bytes initially by default
    defer print("Arena allocator's result: {}\n", .{arena.deinit()}); // print status and free up the entirety of its allocated memory at the end (exit) of this scope

    // The logging Allocator logs all memory allocations (and their sizes), shrinks, expansions, and frees
    var logging_alloc = std.heap.loggingAllocator(arena.allocator()); // the ".allocator()" method returns an "mem.Allocator" object

    // Continously read and parse user input:
    while (try std.io.getStdIn().reader().readUntilDelimiterOrEofAlloc(logging_alloc.allocator(), '\n', std.math.pow(usize, 1024, 2))) |user_input| { // specify a maximum size
        const trimmed_string: []const u8 = std.mem.trim(u8, user_input, " ");

        if (std.mem.eql(u8, trimmed_string, "b")) {
            print("Existing program...\n\n", .{});
            break;
        }

        var numbers = std.mem.tokenize(u8, trimmed_string, " "); // returns an iterator

        print("Sum of the numbers: {d:.2}\n", .{try sumNums(&numbers)});
    }
}
