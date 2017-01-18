part of ose;

String _genFragmentSpriteSrc(int maxLights) {
    return
        "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
            "precision highp float;\n"
        "#else\n"
            "precision mediump float;\n"
        "#endif\n"
        "precision mediump int;"
        // Target's color map.
        "uniform sampler2D u_colorMap;"
        // Target's normal map.
        "uniform sampler2D u_normalMap;"
        // Ambient color.
        "uniform vec4 u_ambientLightColor;"
        // Lights colors.
        "uniform vec4 u_lightColor[${maxLights}];"
        // Lights falloffs (x + y * D + z * D * D, by default [0.75, 3, 20]).
        "uniform vec3 u_lightFalloff[${maxLights}];"
        // Lights types.
        // 0 - light not bound.
        // 1 - directional light.
        // 2 - spot light.
        "uniform int u_lightType[${maxLights}];"
        // Lights rays (directiona vector & distance from light source to target
        // object). For directional lights it will be converted to direction vector.
        "varying vec2 v_lightRay[${maxLights}];"
        // Interpolated texels.
        "varying vec2 v_texCoord;"
        "void main() {"
            // Get color from color map texture.
            "vec4 color = texture2D(u_colorMap, v_texCoord);"
            // Final color will be accumulated by lightning.
            "vec3 finalColor = color.rgb;"
            // Get normal from normal map texture.
            "vec2 N = normalize(texture2D(u_normalMap, v_texCoord).xy * 2.0 - 1.0);"
            // Attenuation factor.
            "float attenuation = 1.0;"
            // Process each light.
            "for (int i = 0; i < ${maxLights}; i++) {"
                "if (u_lightType[i] == 0) {"
                    "continue;"
                "}"
                // Get light direction.
                "vec2 L = normalize(v_lightRay[i]);"
                // Calculate light diffuse.
                "vec3 lightDiffuse = (u_lightColor[i].rgb * u_lightColor[i].a) * max(dot(N, L), 0.0);"
                // Calculate attenuation for spot light.
                "if (u_lightType[i] == 2) {"
                    "vec3 lightFalloff = u_lightFalloff[i];"
                    "float D = length(v_lightRay[i]);"
                    "attenuation = 1.0 / (lightFalloff.x + lightFalloff.y * D + lightFalloff.z * D * D);"
                "}"
                // Accumulate lightning.
                "finalColor += lightDiffuse * attenuation;"
            "}"
            // Set color.
            "gl_FragColor = vec4(u_ambientLightColor.rgb * u_ambientLightColor.a + finalColor, color.a);"
        "}";
}
