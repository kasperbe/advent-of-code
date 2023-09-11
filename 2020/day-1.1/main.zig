const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer std.fs.File.close(file);

    var buffer = std.io.bufferedReader(file.reader());
    var stream = buffer.reader();

    var buf: [1024]u8 = undefined;

    const allocator = std.heap.page_allocator;
    var candidates = std.AutoHashMap(i32, i32).init(allocator);

    const writer = std.io.getStdIn().writer();
    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const expense = try std.fmt.parseInt(i32, line, 10);

        const res = candidates.get(2020 - expense);
        if (res) |rr| {
            try writer.print("Found : {d} + {d}, result: {d}", .{ rr, expense, rr * expense });
            return;
        }

        try candidates.put(expense, expense);
    }
}
