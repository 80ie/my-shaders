uniform float uAspect;
uniform float uMinDist;
uniform vec2 uGridSize;
uniform vec2 uCenter;
uniform vec2 uMouse;

out vec4 fragColor;
void main()
{
	vec3 color = vec3(.0);
	vec2 st = vUV.st;
	st.y *= uAspect;
	vec2 center = uCenter;
	vec2 mouse = vec2(uMouse.x, uMouse.y*uAspect);
	
	// scale
	//st *= 2;
	st *= uGridSize;

	// tile the space
	vec2 ist = floor(st);
	vec2 fst = fract(st);

	float m_dist = 1.;
	//m_dist = distance(mouse and fuckingpoint AAGHHG)

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			// neighbor place in grid
			vec2 neighbor = vec2(float(x),float(y));

			// point pos
			vec2 point = vec2(x+0.5, y+0.5);

			float dist = distance(neighbor, point - fst);
			//float mouse_dist = distance(neighbor, mouse - fst);
			//dist = min(dist, mouse_dist);

			m_dist = min(m_dist, dist);
		}
	}
	
	color += m_dist;

	color += 1.-step(.02, m_dist);

	color.r += step(.98, fst.x) + step(.98, fst.y);

	fragColor = vec4(color, 1.0);
}
