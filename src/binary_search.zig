const std = @import("std");

pub fn main() !void {
    const arr = [_]i32{ 1, 5, 8, 20, 28, 35, 99, 101, 205 };
    std.debug.print("Enter a number to find: ", .{});

    // The buffer below can a whole 10 characters, because the extra byte needed for the null terminator string ("\n" or "\0") is not included (written)
    var input_buffer: std.BoundedArray(u8, 10) = .{}; // stack allocated, fixed-size array

    // The ".streamUntilDelimiter()" method reads from the "reader" and appends content to the writer, which then writes data into the buffer, truncating at "delimiter" or end
    try std.io.getStdIn().reader().streamUntilDelimiter(input_buffer.writer(), '\n', null);

    // The ".slice()" mehtod returns a view of "input_buffer" (of length = "input_buffer.len") until the delimiter is reached, excluding it and the remaining empty spaces
    const trimmed_input = std.mem.trim(u8, input_buffer.slice(), " "); // slice is of type: "[]u8"

    const target = std.fmt.parseInt(i32, trimmed_input, 10) catch |err| {
        std.debug.print("Failed to parse number: \"{s}\", with error: {!}\n", .{ trimmed_input, err });
        return;
    };

    if (binary_search(&arr, target)) |answer| {
        std.debug.print("Target found at index: {d}\n", .{answer});
    } else {
        std.debug.print("Target not found!\n", .{});
    }
}

fn binary_search(arr: []const i32, target: i32) ?usize {
    if (arr.len == 0) {
        std.debug.print("Provided array is empty!\n", .{});
        return null;
    }

    var lower_bound: usize = 0;
    var upper_bound: usize = arr.len;
    var middle = upper_bound / 2;
    var middle_num: i32 = arr[middle];

    while ((middle_num != target) and (lower_bound != upper_bound)) {
        if (middle_num > target) {
            upper_bound = middle;
        } else {
            lower_bound = middle + 1;
        }

        middle = lower_bound + (upper_bound - lower_bound) / 2; // rewritten this away to avoid potential integer overflow
        middle_num = arr[middle];
    }

    if (middle_num == target) {
        return middle;
    }

    return null;
}
