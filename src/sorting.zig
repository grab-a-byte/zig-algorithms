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
    if (items.len == 1) return;
    const middle = items.len / 2;
    try merge_sort(allocator, items[0..middle]);
    try merge_sort(allocator, items[middle..]);

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

//Heap sort
pub fn heap_sort(items: []u32) void {
    const n = items.len - 1;
    build_max_heap(items);
    for (0..n) |index| {
        const i = n - index;
        items[0], items[i] = .{ items[i], items[0] };
        max_heapify(items, i, 0);
    }
}

fn build_max_heap(items: []u32) void {
    const n = (items.len / 2) - 1;
    for (0..n) |value| {
        const i = n - value;
        max_heapify(items, n, i);
    }
}

fn max_heapify(items: []u32, heap_size: usize, index: usize) void {
    const left = (index * 2) + 1;
    const right = (index * 2) + 2;

    var largest = if (left < heap_size and items[left] > items[index]) left else index;
    largest = if (right < heap_size and items[right] > items[largest]) right else largest;

    if (largest != index) {
        items[largest], items[index] = .{ items[index], items[largest] };
        max_heapify(items, heap_size, largest);
    }
}

//Quicksort
// pub fn quicksort(items: []u32, start: usize, end: usize) void {
//     if (start > end) return;
//     std.debug.print("going from {d} to {d}\n", .{ start, end });
//     const middle = partition(items, start, end);
//     quicksort(items, start, middle);
//     quicksort(items, middle, end);
// }

// fn partition(items: []u32, low: usize, high: usize) usize {
//     const pivot = items[high];
//     var i: u32 = low - 1;
//     for (low..high - 1) |index| {
//         if (items[index] <= pivot) {
//             i = i + 1;
//             std.mem.swap(u32, &items[i], &items[index]);
//         }
//     }

//     std.mem.swap(u32, &items[i + 1], &items[high]);
//     return i + 1;
// }

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

// test "Quicksort should sort" {
//     var input = [_]u32{ 2, 8, 7, 1, 3, 5, 6, 4 };
//     quicksort(&input, 0, input.len - 1);
//     try std.testing.expect(input[0] == 1);
//     try std.testing.expect(input[1] == 2);
//     try std.testing.expect(input[2] == 3);
//     try std.testing.expect(input[3] == 4);
//     try std.testing.expect(input[4] == 5);
//     try std.testing.expect(input[5] == 6);
//     try std.testing.expect(input[6] == 7);
//     try std.testing.expect(input[7] == 8);
// }
