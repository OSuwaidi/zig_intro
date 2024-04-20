//
//    "Trunks and tails
//     Are handy things"

//     from Holding Hands
//       by Lenore M. Link
//
// Now that we have tails all figured out, can you implement trunks?
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null,
    trunk: ?*Elephant = null,
    visited: bool = false,

    // Elephant tail methods!
    pub fn getTail(self: *Elephant) *Elephant {
        return self.tail.?; // Remember, this means "orelse unreachable"
    }

    pub fn hasTail(self: *Elephant) bool {
        return (self.tail != null);
    }

    // Your Elephant trunk methods go here!
    // ---------------------------------------------------

    // Since we're not going to modify the struct's fields (only read them), no need to pass struct by reference in the below methods, can pass by value (copy) -> "self: Elephant".
    // But this will create a copy of the struct each time it's called! So, if the struct was complex (big in size), this approach will be inefficient.
    // Hence, pass by (mutable) reference:
    pub fn hasTrunk(self: *Elephant) bool {
        return (self.trunk != null);
    }

    // pass by (immutable) reference:
    pub fn getTrunk(self: *const Elephant) *Elephant { // we can also coerce the argument as a pointer to "const" (immutable) self since we don't need to modify it
        return self.trunk.?;
    }

    // ---------------------------------------------------

    pub fn visit(self: *Elephant) void {
        self.visited = true;
    }

    pub fn print(self: *Elephant) void {
        // Prints elephant letter and [v]isited
        const v: u8 = if (self.visited) 'v' else ' ';
        std.debug.print("{u}{u} ", .{ self.letter, v });
    }
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // We link the elephants so that each tail "points" to the next.
    elephantA.tail = &elephantB;
    elephantB.tail = &elephantC;

    // And link the elephants so that each trunk "points" to the previous.
    elephantB.trunk = &elephantA;
    elephantC.trunk = &elephantB;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// This function visits all elephants twice, tails to trunks.
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    // We follow the tails!
    while (true) {
        e.print();
        e.visit();

        // This gets the next elephant or stops.
        e = if (e.hasTail()) e.getTail() else break;
    }

    // "e" here is now "elephantC"

    // We follow the trunks!
    while (true) {
        e.print();

        // This gets the previous elephant or stops.
        e = if (e.hasTrunk()) e.getTrunk() else break;
    }
}
