precision highp float;   // mediump can band visibly in the sweep ramp

uniform vec2  u_resolution;
uniform vec2  u_mouse;
uniform float u_time;

const float GRID_SIZE   = 5.0;  // cells across the short axis
const float ROT_SPEED   = 0.2;  // radians per second
const float CYCLE_SPEED = 0.1;  // sweep cycles per second
const float BAND_WIDTH  = 0.5;  // stripe half-thickness, in cell units

// b = half extents
// r = corner radii: x top-right, y bottom-right, z top-left, w bottom-left
float sdRoundedBox(in vec2 p, in vec2 b, in vec4 r)
{
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

float band()

void main()
{
    // ---- coordinates ------------------------------------------------
    // Origin at the centre of the grid, square cells, GRID_SIZE cells tall.
    vec2 gridPos = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y * GRID_SIZE;

    vec2 cellId = floor(gridPos + 0.5);  // integer cell coords; also the cell's centre
    vec2 cellUV = gridPos - cellId;      // -0.5 .. 0.5 within the cell

    // ---- stage 4: rounded square ------------------------------------
    float boxDist = sdRoundedBox(cellUV, vec2(0.4), vec4(0.3));

    // ---- stage 5: per-cell glow -------------------------------------
    float glow = 1.0 - smoothstep(0.0, 3.0, length(cellId));

    // ---- stage 6: rotating sweep ------------------------------------
    float sweepAngle    = u_time * ROT_SPEED;
    vec2  sweepDir = vec2(cos(sweepAngle), sin(sweepAngle));

    float proj     = dot(gridPos, sweepDir);
    float halfDiag = GRID_SIZE * 0.5 * sqrt(2.0);
    float extent   = halfDiag + BAND_WIDTH;

    float travel = fract(u_time*CYCLE_SPEED);  // TODO: sweep -extent .. +extent, looping on time
    travel = mix(-extent, extent, travel);
    float band   = 1.0 - smoothstep(0.0, BAND_WIDTH, abs(proj - travel));  // TODO: bright near the stripe, dark away from it

    // ---- stage 7: combine (not yet) ---------------------------------
    vec3 color = vec3(band);

    gl_FragColor = vec4(color, 1.0);
}