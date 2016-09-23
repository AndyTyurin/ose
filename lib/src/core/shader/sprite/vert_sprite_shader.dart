part of ose;

const String _vertexSpriteShaderSource = "attribute vec2 a_position;"
    "attribute vec2 a_texCoord;"
    "uniform mat3 u_model;" 
    "uniform mat3 u_projection;"
    "varying vec2 v_texCoord;"
    "void main() {"
    "vec2 pos = vec2(a_position.x, a_position.y) * 2.0 - 1.0;"
    "gl_Position = vec4((u_projection * u_model * vec3(pos, 1.0)).xy, 0.0, 1.0);"
    "v_texCoord = a_texCoord;"
    "}";

final Shader _spriteVertexShader =
    new Shader(ShaderType.Vertex, _vertexSpriteShaderSource);
