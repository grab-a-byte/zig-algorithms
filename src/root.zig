const std = @import("std");

pub fn insertion_sort(items: []u32) void {
    for (1..items.len) |index| {
        const key = items[index];
        var i: i64 = @intCast(index - 1);
        while (i >= 0 and items[@intCast(i)] > key) : (i -= 1) {
            items[@intCast(i + 1)] = items[@intCast(i)];
        }
        items[@intCast(i + 1)] = key;
    }
}

//Merge Sort
pub fn merge_sort(allocator: std.mem.Allocator, items: []u32) !void {
    try merge_sort_parameterized(allocator, items, 0, items.len);
}

fn merge_sort_parameterized(allocator: std.mem.Allocator, items: []u32, left: usize, right: usize) !void {
    std.debug.print("left: {d} && right {d}\n", .{ left, right });
    if (left >= right) return;

    const middle = left + (right - left) / 2;
    std.debug.print("middle: {d}\n", .{middle});
    try merge_sort_parameterized(allocator, items, left, middle);
    try merge_sort_parameterized(allocator, items, middle + 1, right);

    try merge(allocator, items, left, middle, right);
}

fn merge(allocator: std.mem.Allocator, output: []u32, left: usize, middle: usize, right: usize) !void {
    std.debug.print("merge {d} {d} {d}\n", .{ left, middle, right });
    const left_array = try allocator.dupe(u32, output[left..middle]);
    defer allocator.free(left_array);
    const right_array = try allocator.dupe(u32, output[middle..right]);
    defer allocator.free(right_array);
    print_array(left_array, "left");
    print_array(right_array, "right");

    var left_count: u32 = 0;
    var right_count: u32 = 0;

    var index = left;
    while (left_count < left_array.len and right_count < right_array.len) {
        // std.debug.print("hit\n", .{});
        // std.debug.print("{d}\n", .{left_array[left_count]});
        // std.debug.print("{d}\n", .{right_array[right_count]});
        if (left_array[left_count] < right_array[right_count]) {
            // std.debug.print("hit2\n", .{});
            output[index] = left_array[left_count];
            left_count += 1;
        } else {
            // std.debug.print("hit3\n", .{});
            output[index] = right_array[right_count];
            right_count += 1;
        }

        index += 1;
    }

    while (left_count < left_array.len) {
        output[index] = left_array[left_count];
        left_count += 1;
        index += 1;
    }

    while (right_count < right_array.len) {
        output[index] = right_array[right_count];
        right_count += 1;
        index += 1;
    }

    print_array(output, "");
}

fn print_array(items: []u32, prefix: []const u8) void {
    std.debug.print("{s}", .{prefix});
    std.debug.print("[", .{});
    for (items) |i| {
        std.debug.print("{d},", .{i});
    }
    std.debug.print("]\n", .{});
}

// test "merge sort 2 items" {
//     var input = [_]u32{ 32, 12 };
//     try merge_sort(std.testing.allocator, input[0..]);

//     try std.testing.expect(input[0] == 12);
//     try std.testing.expect(input[1] == 32);
// }

test "merge sort with 4 items" {
    var input = [_]u32{ 32, 12, 24, 1 };
    try merge_sort(std.testing.allocator, input[0..]);

    print_array(&input, "");

    try std.testing.expect(input[0] == 1);
    try std.testing.expect(input[1] == 12);
    try std.testing.expect(input[2] == 24);
    try std.testing.expect(input[3] == 32);
}
