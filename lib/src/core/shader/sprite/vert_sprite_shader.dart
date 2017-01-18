part of ose;

String _genVertexSpriteSrc(int maxLights) {
    return
        "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
            "precision highp float;\n"
        "#else\n"
            "precision mediump float;\n"
        "#endif\n"
        "precision mediump int;"
        // Vertex position.
        "attribute vec2 a_position;"
        // Texel position.
        "attribute vec2 a_texCoord;"
        // Model matrix.
        "uniform mat3 u_m;"
        // View matrix.
        "uniform mat3 u_v;"
        // Projection matrix.
        "uniform mat3 u_p;"
        // Lights positions (only for spot lights).
        "uniform vec2 u_lightPosition[${maxLights}];"
        // Lights directions (only for directional lights).
        "uniform vec2 u_lightDirection[${maxLights}];"
        // Lights types.
        // 0 - light not bound.
        // 1 - directional light.
        // 2 - spot light.
        "uniform int u_lightType[${maxLights}];"
        // Lights rays (directiona vector & distance from light source to target
        // object). For directional lights it will be converted to direction vector.
        "varying vec2 v_lightRay[${maxLights}];"
        // Interpolated texel coordinates.
        "varying vec2 v_texCoord;"
        "void main() {"
            // Convert to projection-view-model space from -1 to 1.
            "vec2 pos = (u_m * vec3(a_position * 2.0 - 1.0, 1.0)).xy;"
            // Set texel position.
            "v_texCoord = a_texCoord;"
            // Iterate through the lights and set ray to each one if light has been bound.
            "for (int i = 0; i < ${maxLights}; i++) {"
                "if (u_lightType[i] == 0) {"
                    "continue;"
                "}"
                "vec2 lightRay;"
                "if (u_lightType[i] == 1) {"
                    "lightRay = u_lightDirection[i];"
                "} else if (u_lightType[i] == 2) {"
                    "lightRay = vec2(u_lightPosition[i].x - pos.x, pos.y - u_lightPosition[i].y);"
                "}"
                "v_lightRay[i].x = lightRay.x * u_m[0][0] + lightRay.y * u_m[1][0];"
                "v_lightRay[i].y = lightRay.x * u_m[1][0] - lightRay.y * u_m[0][0];"
            "}"
            // Set vertex position.
            "gl_Position = vec4((u_p * u_v * vec3(pos, 1.0)).xy, 1.0, 1.0);"
        "}";
}
