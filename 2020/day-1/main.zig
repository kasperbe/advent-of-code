const std = @import("std");

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer std.fs.File.close(file);

    var buffer = std.io.bufferedReader(file.reader());
    var stream = buffer.reader();

    var buf: [1024]u8 = undefined;

    const writer = std.io.getStdIn().writer();
    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try writer.print("Hello world {s}", .{line});
    }
}
