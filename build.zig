// CAUTION! zig version may be outdated during your compilation
// zig version 0.14.0-dev.2271+f845fa04a
// November 2024

const std = @import("std");

/// "$ zig build test run" for full functionality
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "executavel.out",
        .root_source_file = b.path("./src/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    exe.linkSystemLibrary("raylib");
    exe.linkLibC();
    b.installArtifact(exe);

    Step_Test(b);
    Step_Run(b, exe);
}

/// zig build test
pub fn Step_Test(b: *std.Build) void {
    const test_step = b.step("test", "Run zig tests");
    const create_tests = b.addTest(.{ .root_source_file = b.path("./src/main.zig") });
    const run_tests = b.addRunArtifact(create_tests);
    test_step.dependOn(&run_tests.step);
}

/// zig build run
pub fn Step_Run(b: *std.Build, exe: *std.Build.Step.Compile) void {
    const run_step = b.step("run", "Run the executable");
    const run_exe = b.addRunArtifact(exe);
    run_step.dependOn(&run_exe.step);
}
