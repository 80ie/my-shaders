precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

void main() {
    float aspect = u_resolution.x / u_resolution.y; 
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    vec3 color = vec3(0.0);
    vec2 center = vec2(0.5);
    vec2 grid_size = vec2(3.0);


    st *= grid_size;
    st.x *= aspect;
    vec2 ist = floor(st);
    vec2 fst = fract(st);

    vec2 mouse = u_mouse/u_resolution;
    mouse.x *= aspect;
    mouse = vec2(mouse.x*grid_size.x, mouse.y*grid_size.y);

    float m_dist = 1.;

    for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			// neighbor place in grid
			vec2 neighbor = vec2(float(x),float(y));

			// point pos
			vec2 point = neighbor + vec2(0.5);

            vec2 diff = neighbor + point - fst;
			float dist = length(diff);

			m_dist = min(m_dist, dist);
		}
	}

    float dist = distance(st, mouse);
    m_dist = min(m_dist, dist);
	
    //color += pow(m_dist, 2.0);
    //m_dist = pow(m_dist, 1.0);
    //m_dist = smoothstep(0.1,0.9, m_dist);
    //color += m_dist;
    m_dist = pow(m_dist, 2.0);
    color += m_dist;

    gl_FragColor = vec4(color, 1.0);
}
