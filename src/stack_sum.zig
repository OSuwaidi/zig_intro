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
    // Pre-allocate on the stack 1028 bytes to store user's input:
    // var input_buffer: [1024]u8 = undefined;

    // Continously read and parse user input:
    while (true) {
        // Pre-allocate (initialized as zeros) on the stack 1028 bytes to store user's input:
        var buffer: std.BoundedArray(u8, std.math.pow(usize, 32, 2)) = .{}; // contains ".buffer" and ".len" fields

        try std.io.getStdIn().reader().streamUntilDelimiter(buffer.writer(), '\n', 1024);
        const trimmed_string: []const u8 = std.mem.trim(u8, buffer.slice(), " "); // ".slice()" returns a truncated (up to delimiter) view of buffer

        if (std.mem.eql(u8, trimmed_string, "q")) {
            print("Existing program...\n\n", .{});
            break;
        }

        var numbers = std.mem.tokenize(u8, trimmed_string, " "); // returns an iterator

        print("Sum of the numbers: {d:.2}\n", .{try sumNums(&numbers)});
    }
}
