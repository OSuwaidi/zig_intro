const std = @import("std");

pub fn main() !void {
    const arr = [_]i32{ 1, 5, 8, 20, 28, 35, 99, 101, 205 };
    std.debug.print("Enter a number to find: ", .{});

    var input_buffer: [10]u8 = undefined; // can take up to 9 characters because an extra byte is needed for the null terminator string -> "\n" in Zig rahter than "\0"
    const user_input = (try std.io.getStdIn().reader().readUntilDelimiterOrEof(&input_buffer, '\n')).?; // returns a slice of "input_buffer", truncating at "delimiter"
    const trimmed_input = std.mem.trim(u8, user_input, " ");

    const target = std.fmt.parseInt(i32, trimmed_input, 10) catch |err| {
        std.debug.print("Invalid number: \"{s}\", with error: {}\n", .{ trimmed_input, err });
        return;
    };

    if (binary_search(&arr, target)) |answer| {
        std.debug.print("Target found at index: {}\n", .{answer});
    } else {
        std.debug.print("Target not found!\n", .{});
    }
}

fn binary_search(arr: []const i32, target: i32) ?usize {
    const length = arr.len;
    var upper_bound = length - 1;
    var lower_bound: usize = 0;
    var middle = upper_bound / 2;
    var middle_num: i32 = arr[middle];

    while ((middle_num != target) and (upper_bound != lower_bound) and (lower_bound != length) and (upper_bound != 0)) {
        if (middle_num > target) {
            upper_bound = middle;
        } else {
            lower_bound = middle + 1;
        }

        middle = (upper_bound + lower_bound) / 2;
        middle_num = arr[middle];
    }

    if (middle_num == target) {
        return middle;
    }
    return null;
}
