attribute vec2 a_position;
attribute vec4 a_color;
uniform mat3 u_model;
uniform mat3 u_projection;

varying vec4 v_color;

void main() {
    gl_Position = vec4((u_projection * u_model * vec3(a_position, 1.0)).xy, 0.0, 1.0);
    v_color = a_color;
}