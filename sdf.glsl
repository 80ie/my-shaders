precision highp float;   // mediump can band visibly in the sweep ramp

uniform vec2  u_resolution;
uniform vec2  u_mouse;
uniform float u_time;

const float GRID_SIZE   = 5.0;  // cells across the short axis
const float ROT_SPEED   = 0.2;  // radians per second
const float CYCLE_SPEED = 0.1;  // sweep cycles per second
const float BAND_WIDTH  = 0.1;  // stripe half-thickness, in cell units
const float RING_SPACING   = 10.0;   // distance between ring peaks, in grid units
const float RING_SHARPNESS = 50.0;  // higher = thinner, crisper rings

float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

// b = half extents
// r = corner radii: x top-right, y bottom-right, z top-left, w bottom-left
float sdRoundedBox(in vec2 p, in vec2 b, in vec4 r)
{
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

vec2 toGridSpace(vec2 pixelCoord)
{
    return (pixelCoord - 0.5 * u_resolution.xy) / u_resolution.y * GRID_SIZE;
}

float band(in float dist, in float offset, in float speed)
{
    float phase = dist / RING_SPACING - u_time * speed + offset;
    float wave  = sin(phase * 6.28318530718) * 0.5 + 0.5;  // -1..1 -> 0..1
    float b     = pow(wave, RING_SHARPNESS);

    //b *= smoothstep(0.0, 0.5, dist);  // fade in near the mouse point 


    return b;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return a + b * cos(6.28318530718 * (c * t + d));
}

void main()
{
    // ---- coordinates ------------------------------------------------
    // Origin at the centre of the grid, square cells, GRID_SIZE cells tall.
    vec2 gridPos = toGridSpace(gl_FragCoord.xy);
    vec2 mouseGridPos = toGridSpace(u_mouse);

    vec2 cellId = floor(gridPos + 0.5);  // integer cell coords; also the cell's centre
    vec2 cellUV = gridPos - cellId;      // -0.5 .. 0.5 within the cell

    // ---- stage 4: rounded square ------------------------------------
    float boxDist = sdRoundedBox(cellUV, vec2(0.4), vec4(0.1));

    // ---- stage 5: per-cell glow -------------------------------------
    float glow = 1.0 - smoothstep(0.0, 3.0, length(cellId - mouseGridPos));

    // ---- stage 6: rotating sweep ------------------------------------
    float distFromMouse = length(gridPos - mouseGridPos);

    float b = band(distFromMouse, 0.0, CYCLE_SPEED);
    b += band(distFromMouse, 0.33, CYCLE_SPEED);
    b += band(distFromMouse, 0.66, CYCLE_SPEED);
    
    b *= smoothstep(0.0, 0.5, length(mouseGridPos - cellId));
    
    // ---- stage 7: combine ---------------------------------
    boxDist = mix(0.0, 1.0, boxDist); 

    float intensity = 1.0 - (boxDist-b) * glow;
    intensity = clamp(intensity, 0.0, 1.0);

    //vec3 color = palette(intensity, vec3(0.5), vec3(0.5), vec3(1.0), vec3(0.0, 0.33, 0.67));
    vec3 color = vec3(intensity);
    gl_FragColor = vec4(color, 1.0);
}