// CAUTION! zig version may be outdated during your compilation
// zig version 0.14.0-dev.2271+f845fa04a
// November 2024

const raylib = @cImport({
    @cInclude("raylib.h");
});
const std = @import("std");
const phys = @import("physics.zig");

const Particle = struct {
    mass: f32,
    force: phys.Vector2D,
    acceleration: phys.Vector2D,
    velocity: phys.Vector2D,
    position: phys.Vector2D,
};

const Spring = struct {
    k: f32,
    restLen: f32,
    Particle_A: *Particle,
    Particle_B: *Particle,
};

const InteractivityHandler = struct {
    selected_particle: ?*Particle,
};

pub fn main () !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var particle_list = std.ArrayList(*Particle).init(gpa.allocator());
    defer particle_list.deinit();
    const A: *Particle = try gpa.allocator().create(Particle);
    const B: *Particle = try gpa.allocator().create(Particle);
    const C: *Particle = try gpa.allocator().create(Particle);
    const D: *Particle = try gpa.allocator().create(Particle);
    A.* = makeParticle(50, 50, 1);
    B.* = makeParticle(50, 100, 1);
    C.* = makeParticle(100, 50, 1);
    D.* = makeParticle(300, 50, 1);
    try particle_list.append(A);
    try particle_list.append(B);
    try particle_list.append(C);
    try particle_list.append(D);
    defer gpa.allocator().destroy(A);
    defer gpa.allocator().destroy(B);
    defer gpa.allocator().destroy(C);
    defer gpa.allocator().destroy(D);

    var spring_list = std.ArrayList(*Spring).init(gpa.allocator());
    defer spring_list.deinit();
    const AB: *Spring = try gpa.allocator().create(Spring);
    const BC: *Spring = try gpa.allocator().create(Spring);
    const CA: *Spring = try gpa.allocator().create(Spring);
    const CD: *Spring = try gpa.allocator().create(Spring);
    AB.* = makeSpring(A, B, 125, 10.0);
    BC.* = makeSpring(B, C, 75, 10.0);
    CA.* = makeSpring(C, A, 75, 10.0);
    CD.* = makeSpring(C, D, 75, 50.0);
    try spring_list.append(AB);
    try spring_list.append(BC);
    try spring_list.append(CA);
    try spring_list.append(CD);
    defer gpa.allocator().destroy(AB);
    defer gpa.allocator().destroy(BC);
    defer gpa.allocator().destroy(CA);
    defer gpa.allocator().destroy(CD);

    var interaction_handler: InteractivityHandler = InteractivityHandler{
        .selected_particle = null
    };

    raylib.SetTraceLogLevel(raylib.LOG_ERROR);
    raylib.SetTargetFPS(60);
    raylib.InitWindow(raylib.GetScreenWidth(), raylib.GetScreenHeight(), "Spring Simulator");
    while (!raylib.WindowShouldClose()) {
        // update state
        handleInputs(&interaction_handler, particle_list.items);
        for (spring_list.items) |spring| {
            applyHookeLaw(spring);
        }
        for (particle_list.items) |particle| {
            particle.acceleration = phys.getAcceleration(particle.force, particle.mass);
            particle.velocity = phys.getVelocity(particle.velocity, particle.acceleration, phys.time_step);
            particle.velocity = phys.applyDamping(particle.velocity, phys.damping_constant);
            particle.position = phys.getPosition(particle.position ,particle.velocity, phys.time_step);
            particle.force = phys.resetVector();
        }

        // render state
        raylib.BeginDrawing();
        renderFrame(spring_list.items);
        raylib.EndDrawing();
    }

    raylib.CloseWindow();

    return;
}

fn applyHookeLaw(spring: *Spring) void {
    const displacement_vector = phys.getVectorFromPoints(spring.Particle_A.position, spring.Particle_B.position);
    const unit_vector_magnitude = phys.getVectorMagnitude(displacement_vector);
    const unit_vector = phys.Vector2D{
        .x = (displacement_vector.x / unit_vector_magnitude),
        .y = (displacement_vector.y / unit_vector_magnitude),
    };

    // hooke's law
    const spring_force = phys.Vector2D{
        .x = ((-1 * spring.k) * (displacement_vector.x - (spring.restLen * unit_vector.x))),
        .y = ((-1 * spring.k) * (displacement_vector.y - (spring.restLen * unit_vector.y))),
    };

    const opposite_spring_force = phys.getVectorOpposite(spring_force);

    spring.Particle_A.force = phys.addVectors(spring.Particle_A.force, opposite_spring_force);
    spring.Particle_B.force = phys.addVectors(spring.Particle_B.force, spring_force);
}

fn makeParticle(x: f32, y: f32, mass: f32) Particle {
    return Particle{
        .position = phys.Vector2D{.x = x, .y = y},
        .mass = mass,
        .force = phys.Vector2D{.x = 0.0, .y = 0.0},
        .velocity = phys.Vector2D{.x = 0.0, .y = 0.0},
        .acceleration = phys.Vector2D{.x = 0.0, .y = 0.0},
    };
}

fn makeSpring(a: *Particle, b: *Particle, length: f32, k: f32) Spring {
    return Spring{
        .Particle_A = a,
        .Particle_B = b,
        .restLen = length,
        .k = k,
    };
}

fn renderFrame(springList: []*Spring) void {
    raylib.ClearBackground(raylib.RAYWHITE);
    for (springList) |spring| {
            raylib.DrawLineEx(raylib.Vector2{.x = spring.Particle_A.position.x, .y = spring.Particle_A.position.y},
                              raylib.Vector2{.x = spring.Particle_B.position.x, .y = spring.Particle_B.position.y},
                              5.0, raylib.GREEN);
            raylib.DrawCircle(@intFromFloat(spring.Particle_A.position.x), 
                              @intFromFloat(spring.Particle_A.position.y),
                              16.0, raylib.BLACK);
            raylib.DrawCircle(@intFromFloat(spring.Particle_B.position.x), 
                              @intFromFloat(spring.Particle_B.position.y),
                              16.0, raylib.BLACK);
            raylib.DrawCircle(@intFromFloat(spring.Particle_A.position.x), 
                              @intFromFloat(spring.Particle_A.position.y),
                              14.0, raylib.BLUE);
            raylib.DrawCircle(@intFromFloat(spring.Particle_B.position.x), 
                              @intFromFloat(spring.Particle_B.position.y),
                              14.0, raylib.BLUE);
    }
}

fn handleInputs(interaction_handler: *InteractivityHandler, particleList: []*Particle) void {
    const mouse_pos: raylib.Vector2 = raylib.GetMousePosition();
    if(interaction_handler.selected_particle) |selected_particle| {
        selected_particle.position.x = mouse_pos.x;
        selected_particle.position.y = mouse_pos.y;
    }

    if(raylib.IsMouseButtonDown(raylib.MOUSE_LEFT_BUTTON) and (interaction_handler.selected_particle != null))
    {
        interaction_handler.selected_particle = null;
        return;
    }

    for (particleList) |particle| {
        if(raylib.IsMouseButtonDown(raylib.MOUSE_LEFT_BUTTON) and (interaction_handler.selected_particle == null))
        {
            if((mouse_pos.x > (particle.position.x - 10))
            and (mouse_pos.x < (particle.position.x + 10))
            and (mouse_pos.y > (particle.position.y - 10))
            and (mouse_pos.y < (particle.position.y + 10)))
            {
                interaction_handler.selected_particle = particle;
                return;
            }
        }
    }
}
