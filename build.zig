// CAUTION! zig version may be outdated during your compilation
// zig version 0.14.0-dev.2271+f845fa04a
// November 2024

const std = @import("std");

/// "$ zig build format test run" for full dev functionality
/// "$ zig build" for the install
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "spring-simulator",
        .root_source_file = b.path("./src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.linkSystemLibrary("raylib");
    exe.linkLibC();
    b.installArtifact(exe);

    Step_Format(b);
    Step_Test(b);
    Step_Run(b, exe);
}

/// zig build format
pub fn Step_Format(b: *std.Build) void {
    const format_step = b.step("format", "Format the style of the zig source files");

    const format_options = std.Build.Step.Fmt.Options{
        .paths = &.{"src/"},   //where to look for source files
        .exclude_paths = &.{}, //no exclude within src
        .check = false,        //format file inplace
    };
    const performStep_format = b.addFmt(format_options);

    format_step.dependOn(&performStep_format.step);
}

/// zig build test
pub fn Step_Test(b: *std.Build) void {
    var test_step = b.step("test", "Run zig tests");

    const added_tests = b.addTest(.{ .root_source_file = b.path("./src/main.zig") });
    const performStep_test = b.addRunArtifact(added_tests);

    test_step.dependOn(&performStep_test.step);
}

/// zig build run
pub fn Step_Run(b: *std.Build, exe: *std.Build.Step.Compile) void {
    var run_step = b.step("run", "Run the executable");

    const performStep_run = b.addRunArtifact(exe);

    run_step.dependOn(&performStep_run.step);
}

