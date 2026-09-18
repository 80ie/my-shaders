precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float freq = 7.0;

vec3 palette( float t )
{
    // 0.5, 0.5, 0.5		0.5, 0.5, 0.5	1.0, 1.0, 1.0	0.00, 0.10, 0.20
    vec3 a = vec3(0.5);
    vec3 b = vec3(0.5);
    vec3 c = vec3(1.0);
    vec3 d = vec3(0.0, 0.32, 0.67);	

    return a + b*cos( 6.28318*(c*t+d) );
}

void main() 
{
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    float d = length(uv);

    vec3 col = palette(fract(u_time*0.05)); 

    d = sin(d*freq - u_time)/freq;
    d = abs(d);
    d = smoothstep(0.0, 0.2, d);
    
    //d = 0.02 / d; 

    //col += d;

    gl_FragColor = vec4(col, 1.0);
}