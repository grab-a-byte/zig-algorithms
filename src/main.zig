const std = @import("std");
const sorting = @import("sorting.zig");

pub fn main(init: std.process.Init) !void {
    var r = std.Random.DefaultPrng.init(42);
    const rand = r.random();
    const allocator = init.arena.allocator();

    var vec: std.ArrayList(u32) = .empty;
    for (0..10) |_| {
        try vec.append(allocator, rand.int(u32) % 10_000);
    }

    //Insertion sort timing
    const in_sort_values = try allocator.dupe(u32, vec.items);
    // print_array(in_sort_values, "before: ");
    var start = std.Io.Timestamp.now(init.io, .real).toMilliseconds();
    sorting.insertion_sort(in_sort_values);
    var end = std.Io.Timestamp.now(init.io, .real).toMilliseconds();
    // print_array(in_sort_values, "");
    std.debug.print("{d}\n", .{end - start});

    //Merge sort timing
    const merge_sort_values = try allocator.dupe(u32, vec.items);
    // print_array(merge_sort_values, "before: ");
    start = std.Io.Timestamp.now(init.io, .real).toMilliseconds();
    try sorting.merge_sort(allocator, merge_sort_values);
    end = std.Io.Timestamp.now(init.io, .real).toMilliseconds();
    // print_array(merge_sort_values, "");
    std.debug.print("{d}\n", .{end - start});

    //heap sort timing
    const heap_sort_values = try allocator.dupe(u32, vec.items);
    print_array(heap_sort_values, "before: ");
    start = std.Io.Timestamp.now(init.io, .real).toMilliseconds();
    sorting.heap_sort(heap_sort_values);
    end = std.Io.Timestamp.now(init.io, .real).toMilliseconds();
    print_array(heap_sort_values, "");
    std.debug.print("{d}\n", .{end - start});
}

fn print_array(items: []u32, prefix: []const u8) void {
    std.debug.print("{s}", .{prefix});
    std.debug.print("[", .{});
    for (items) |i| {
        std.debug.print("{d},", .{i});
    }
    std.debug.print("]\n", .{});
}
