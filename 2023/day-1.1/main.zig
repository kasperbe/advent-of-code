const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer std.fs.File.close(file);

    var buffer = std.io.bufferedReader(file.reader());
    var stream = buffer.reader();

    const writer = std.io.getStdOut().writer();
    var buf: [1024]u8 = undefined;

    const allocator = std.heap.page_allocator;
    var nums = std.ArrayList(u16).init(allocator);
    defer nums.deinit();

    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var low: usize = 0;
        var high = line.len - 1;

        var lNum: u8 = 'a';
        var hNum: u8 = 'a';
        while (true) {
            switch (line[low]) {
                '0'...'9' => lNum = line[low],
                else => low = low + 1,
            }

            switch (line[high]) {
                '0'...'9' => hNum = line[high],
                else => high = high - 1,
            }

            if (lNum != 'a' and hNum != 'a') {
                var numStr: [2]u8 = undefined;
                numStr[0] = lNum;
                numStr[1] = hNum;

                const num = try std.fmt.parseUnsigned(u16, &numStr, 10);

                try nums.append(num);
                break;
            }
        }
    }

    var res: u16 = 0;
    for (nums.allocatedSlice()) |num| {
        res = res + num;
    }

    try writer.print("Result: {d}\n", .{res});
}
