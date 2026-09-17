precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float freq = 7.0;

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

void main() 
{
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 col = vec3(0.0, 0.0, 0.0); 

    float d = length(uv);

    d = sin(d*freq - u_time)/freq;
    d = abs(d);
    d = smoothstep(0.0, 0.2, d);
    
    //d = 0.02 / d; 

    col += d;

    gl_FragColor = vec4(col, 1.0);
}