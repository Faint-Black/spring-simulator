const std = @import("std");

pub const Vector2D = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
};

/// zero init
pub fn initVector() Vector2D {
    return Vector2D{
        .x = 0.0,
        .y = 0.0,
    };
}

/// helper alias
pub fn resetVector() Vector2D {
    return Vector2D{
        .x = 0.0,
        .y = 0.0,
    };
}

/// get the magnitude/length/force of a vector
pub fn getVectorMagnitude(vector: Vector2D) f32 {
    return std.math.sqrt((vector.x * vector.x) + (vector.y * vector.y));
}

/// get the vector that goes from point A to point B
pub fn getVectorFromPoints(point_a: Vector2D, point_b: Vector2D) Vector2D {
    return Vector2D{
        .x = (point_b.x - point_a.x),
        .y = (point_b.y - point_a.y),
    };
}

/// get the opposite direction version of a vector
pub fn getVectorOpposite(vector: Vector2D) Vector2D {
    return Vector2D{
        .x = (vector.x * -1),
        .y = (vector.y * -1),
    };
}

/// helper alias
pub fn applyDamping(velocity: Vector2D, damping: f32) Vector2D {
    return Vector2D{
        .x = (velocity.x * damping),
        .y = (velocity.y * damping),
    };
}

/// apply Newton's second law
pub fn getAcceleration(force: Vector2D, mass: f32) Vector2D {
    return Vector2D{
        .x = (force.x / mass),
        .y = (force.y / mass),
    };
}

/// apply the equation of motion
pub fn getNewVelocity(oldVelocity: Vector2D, acceleration: Vector2D, timestep: f32) Vector2D {
    return Vector2D{
        .x = (oldVelocity.x + (acceleration.x * timestep)),
        .y = (oldVelocity.y + (acceleration.y * timestep)),
    };
}
/// apply the first kinematic equation
pub fn getNewPosition(oldPosition: Vector2D, velocity: Vector2D, timestep: f32) Vector2D {
    return Vector2D{
        .x = (oldPosition.x + (velocity.x * timestep)),
        .y = (oldPosition.y + (velocity.y * timestep)),
    };
}

/// adds two vectors into another vector
pub fn addVectors(a: Vector2D, b: Vector2D) Vector2D {
    return Vector2D{
        .x = (a.x + b.x),
        .y = (a.y + b.y),
    };
}
