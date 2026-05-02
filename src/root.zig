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
    try merge_sort_parameterized(allocator, items);
}

fn merge_sort_parameterized(allocator: std.mem.Allocator, items: []u32) !void {
    if (items.len == 1) return;
    const middle = items.len / 2;
    try merge_sort_parameterized(allocator, items[0..middle]);
    try merge_sort_parameterized(allocator, items[middle..]);

    try merge(allocator, items);
}

fn merge(allocator: std.mem.Allocator, output: []u32) !void {
    const middle = output.len / 2;
    const left_array = try allocator.dupe(u32, output[0..middle]);
    defer allocator.free(left_array);
    const right_array = try allocator.dupe(u32, output[middle..]);
    defer allocator.free(right_array);

    var left_count: u32 = 0;
    var right_count: u32 = 0;

    var index: usize = 0;
    while (left_count < left_array.len and right_count < right_array.len) {
        if (left_array[left_count] < right_array[right_count]) {
            output[index] = left_array[left_count];
            left_count += 1;
        } else {
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
}

test "merge sort 2 items" {
    var input = [_]u32{ 32, 12 };
    try merge_sort(std.testing.allocator, input[0..]);

    try std.testing.expect(input[0] == 12);
    try std.testing.expect(input[1] == 32);
}

test "merge sort with 4 items" {
    var input = [_]u32{ 32, 12, 24, 1 };
    try merge_sort(std.testing.allocator, input[0..]);

    try std.testing.expect(input[0] == 1);
    try std.testing.expect(input[1] == 12);
    try std.testing.expect(input[2] == 24);
    try std.testing.expect(input[3] == 32);
}
