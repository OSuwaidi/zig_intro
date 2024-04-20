//
// We've seen that passing arrays around can be awkward. Perhaps you
// remember a particularly horrendous function definition from quiz3?
// This function can only take arrays that are exactly 4 items long!
//
//     fn printPowersOfTwo(numbers: [4]u16) void { ... }
//
// That's the trouble with arrays - their size is part of the data
// type and must be hard-coded into every usage of that type. This
// digits array is a [10]u8 forever and ever:
//
//     var digits = [10]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
//
// Thankfully, Zig has slices which lets you dynamically point to a start item and provide a
// length (many-item pointer to the first element with length). Here are slices of our digit array:
//
//     const foo = digits[0..1];  // 0
//     const bar = digits[3..9];  // 3 4 5 6 7 8
//     const baz = digits[5..9];  // 5 6 7 8
//     const all = digits[0..];   // 0 1 2 3 4 5 6 7 8 9
//
// As you can see, a slice [x..y] starts with the index of the
// first item at x and the last item at y-1. You can leave the y
// off to get "the rest of the items".
//
// Slices provide a way to efficiently work with a portion (view) of an array or any contiguous
// memory buffer *without the need to copy* its underlying data!

// A slice *does not* own the memory it points to ==> not responsible for the allocation or deallocation of that memory.

// *Note*: a slice of type "[]T" is basically a "struct { ptr: [*]T, len: usize };" type!

const std = @import("std");

pub fn main() void {
    var cards = [8]u8{ 'A', '4', 'K', '8', '5', '2', 'Q', 'J' }; // this is actually an array of characters rather than a string, hence: "[8]u8"

    // Please put the first 4 cards in hand1 and the rest in hand2.
    const hand1: []u8 = cards[0..4]; // if not for specifiying type: "[]u8", it would've been a pointer to an array: "*[8]u8"!
    const hand2: []u8 = cards[4..]; // slices are just many-item pointers (views) to "arbitrary-sized" arrays

    std.debug.print("Hand1: ", .{});
    printHand(hand1);

    std.debug.print("Hand2: ", .{});
    printHand(hand2);
}

// Please lend this function a hand. A u8 slice hand, that is.
fn printHand(hand: []u8) void {
    for (hand) |h| {
        std.debug.print("{u} ", .{h});
    }
    std.debug.print("\n", .{});
}
//
// Fun fact: Under the hood, slices are stored as a pointer to
// the first item and a length.
