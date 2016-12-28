part of ose;

const String _vertexBasicShaderSource = "attribute vec2 a_position;"
    "attribute vec4 a_color;"
    "uniform mat3 u_model;"
    "uniform mat3 u_projection;"
    "uniform mat3 u_view;"
    "varying vec4 v_color;"
    "void main() {"
    "vec2 pos = vec2(a_position.x, a_position.y) * 2.0 - 1.0;"
    "gl_Position = vec4((u_projection * u_view * u_model * vec3(pos, 1.0)).xy, 1.0, 1.0);"
    "v_color = a_color;"
    "}";

final Shader _basicVertexShader =
    new Shader(ShaderType.Vertex, _vertexBasicShaderSource);
