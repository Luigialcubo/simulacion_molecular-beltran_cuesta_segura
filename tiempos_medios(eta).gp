# 1. Terminal y codificación limpia para evitar caracteres rotos (Ã³, ?)
set encoding utf8
set terminal qt font "sans,11"

# 2. Etiquetas limpias con símbolos griegos correctos
set title "Tiempo Medio de Estancia frente al Amortiguamiento (A = 1.0)"
set xlabel "Amortiguamiento {/Symbol h}"
set ylabel "Tiempo medio <{/Symbol t}>({/Symbol h})"
set grid
set key top left box opaque

# 3. Ajuste de los ejes para que no queden los puntos pegados a los bordes
# Dejamos un margen a la izquierda (x = -0.2) y a la derecha (x = 5.3)
set xrange [-0.2 : 5.3]
# Damos margen vertical por debajo (250) y por arriba (1100)
set yrange [250 : 1100]

# 4. Trazar ÚNICAMENTE PUNTOS (with points en vez de with linespoints)
plot 'resultados/tiempos_medios(eta)_A=1.0.txt' using 1:2 with points \
     pt 7 ps 1.8 lc rgb "#1c3b82" \
     title "Simulación (A = 1.0)"