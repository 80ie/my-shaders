precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float FREQ = 7.0;
const float GRID_SIZE = 1.0;

vec3 palette( float t ) {
    // 0.5, 0.5, 0.5		0.5, 0.5, 0.5	1.0, 1.0, 1.0	0.00, 0.10, 0.20
    vec3 a = vec3(0.5);
    vec3 b = vec3(0.5);
    vec3 c = vec3(1.0);
    vec3 d = vec3(0.0, 0.32, 0.67);	

    return a + b*cos( 6.28318*(c*t+d) );
}

float sdRoundedBox(in vec2 p, in vec2 b, in vec4 r) {
    // b = half extents
    // r = corner radii: x top-right, y bottom-right, z top-left, w bottom-left
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

vec2 toCanvas(vec2 pixelCoord) {
    return (pixelCoord - 0.5 * u_resolution.xy) / u_resolution.y * GRID_SIZE;
}

void main() 
{
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    float d = sdRoundedBox(uv, vec2(0.1), vec4(0.01));

    vec3 rainbow = palette(fract(u_time*0.05)); 

    d = sin(d*FREQ - u_time)/FREQ;
    d = abs(d);
    d = smoothstep(0.0, 0.3, d);
    
    //d = 0.02 / d; 

    //col += d;
    vec3 color = vec3(d);
    gl_FragColor = vec4(color, 1.0);
}