precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


void main() {
    float aspect = u_resolution.x / u_resolution.y; 
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    vec3 color = vec3(0.0);
    vec2 center = vec2(0.5);
    vec2 grid_size = vec2(3);

    st.x *= aspect;
    st *= grid_size;
    vec2 ist = floor(st);
    vec2 fst = fract(st);

    vec2 mouse = u_mouse/u_resolution;
    mouse.x *= aspect;
    mouse = vec2(mouse.x*grid_size.x, mouse.y*grid_size.y);


    float m_dist = 1.;

    float dist = distance(st, mouse);
	
    color += dist;



    // olor = vec3(st.x, st.y, abs(sin(u_time)));
    gl_FragColor = vec4(color, 1.0);
}
