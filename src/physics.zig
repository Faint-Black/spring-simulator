const std = @import("std");

/// 1% friction
pub const damping_constant: f32 = 0.99;

/// Delta t simulation time
pub const time_step: f32 = 0.01;

pub const Vector2D = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
};

pub fn getVectorMagnitude(vec: Vector2D) f32 {
    return std.math.sqrt((vec.x * vec.x) + (vec.y * vec.y));
}

pub fn initVector() Vector2D {
    return Vector2D{
        .x = 0.0,
        .y = 0.0,
    };
}

pub fn resetVector() Vector2D {
    return Vector2D{
        .x = 0.0,
        .y = 0.0,
    };
}

pub fn getVectorFromPoints(point_a: Vector2D, point_b: Vector2D) Vector2D {
    return Vector2D{
        .x = (point_b.x - point_a.x),
        .y = (point_b.y - point_a.y),
    };
}

pub fn getVectorOpposite(vector: Vector2D) Vector2D {
    return Vector2D{
        .x = (vector.x * -1),
        .y = (vector.y * -1),
    };
}

pub fn applyDamping(velocity: Vector2D, damping: f32) Vector2D {
    return Vector2D{
        .x = (velocity.x * damping),
        .y = (velocity.y * damping),
    };
}

pub fn getAcceleration(force: Vector2D, mass: f32) Vector2D {
    return Vector2D{
        .x = (force.x * mass),
        .y = (force.y * mass),
    };
}

pub fn getVelocity(oldVelocity:Vector2D, acceleration: Vector2D, timestep: f32) Vector2D {
    return Vector2D{
        .x = (oldVelocity.x + (acceleration.x * timestep)),
        .y = (oldVelocity.y + (acceleration.y * timestep)),
    };
}

pub fn getPosition(oldPosition:Vector2D, velocity: Vector2D, timestep: f32) Vector2D {
    return Vector2D{
        .x = (oldPosition.x + (velocity.x * timestep)),
        .y = (oldPosition.y + (velocity.y * timestep)),
    };
}

pub fn addVectors(a: Vector2D, b: Vector2D) Vector2D {
    return Vector2D{
        .x = (a.x + b.x),
        .y = (a.y + b.y),
    };
}
