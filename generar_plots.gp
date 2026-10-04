# En este archivo vamos a plotear por cada eta todo

set terminal pngcairo size 800,600 enhanced font "Helvetica,12"
set grid

set xlabel "Tiempo t"
set ylabel "Energía cinética promedio <Ec>"
set yrange [0:1.5]

# eta = 0.1

set output "plots/equiparticion_eta0.1.png"
set title "Equipartición de la energía (eta = 0.1, h = 0.1)"
plot 0.5 dt 2 lc rgb "black" title "Teoría (<Ec> = 0.5)", \
     "resultados/data_alg0_eta0.1_h0.1000.dat" u 3:2 w l lw 2 lc rgb "red" title "Euler-Maruyama", \
     "resultados/data_alg1_eta0.1_h0.1000.dat" u 3:2 w l lw 2 lc rgb "blue" title "Runge-Kutta 2", \
     "resultados/data_alg2_eta0.1_h0.1000.dat" u 3:2 w l lw 2 lc rgb "green" title "Verlet (G-JF)"

# eta = 1.0

set output "plots/equiparticion_eta1.0.png"
set title "Equipartición de la energía (eta = 1.0, h = 0.1)"
plot 0.5 dt 2 lc rgb "black" title "Teoría (<Ec> = 0.5)", \
     "resultados/data_alg0_eta1.0_h0.1000.dat" u 3:2 w l lw 2 lc rgb "red" title "Euler-Maruyama", \
     "resultados/data_alg1_eta1.0_h0.1000.dat" u 3:2 w l lw 2 lc rgb "blue" title "Runge-Kutta 2", \
     "resultados/data_alg2_eta1.0_h0.1000.dat" u 3:2 w l lw 2 lc rgb "green" title "Verlet (G-JF)"

# eta = 10.0

set output "plots/equiparticion_eta10.0.png"
set title "Equipartición de la energía (eta = 10.0, h = 0.1)"
plot 0.5 dt 2 lc rgb "black" title "Teoría (<Ec> = 0.5)", \
     "resultados/data_alg0_eta10.0_h0.1000.dat" u 3:2 w l lw 2 lc rgb "red" title "Euler-Maruyama", \
     "resultados/data_alg1_eta10.0_h0.1000.dat" u 3:2 w l lw 2 lc rgb "blue" title "Runge-Kutta 2", \
     "resultados/data_alg2_eta10.0_h0.1000.dat" u 3:2 w l lc rgb "green" title "Verlet (G-JF)"

unset yrange

# Efecto del damping: espacio de fases (p vs x con verlet)

set output "plots/espacio_fases_damping.png"
set title "Espacio de Fases (p vs x) con Verlet (h = 0.01)"
set xlabel "Posición x"
set ylabel "Momento p"
set xrange [-3:3]
set yrange [-3:3]

plot "resultados/data_alg2_eta0.1_h0.0100.dat" u 4:5 w p pt 7 ps 0.2 lc rgb "blue" title "eta = 0.1 (Poco amortiguado)", \
     "resultados/data_alg2_eta1.0_h0.0100.dat" u 4:5 w p pt 7 ps 0.2 lc rgb "green" title "eta = 1.0 (Intermedio)", \
     "resultados/data_alg2_eta10.0_h0.0100.dat" u 4:5 w p pt 7 ps 0.2 lc rgb "red" title "eta = 10.0 (Sobreamortiguado)"

unset xrange
unset yrange

#Gausianas y histogramas

set output "plots/histograma_posicion.png"
set title "Distribución de Posiciones P(x) - Verlet (eta = 1.0, h = 0.001)"
set xlabel "Posición x"
set ylabel "Densidad de Probabilidad P(x)"

# Configuración para construir el histograma en Gnuplot
binwidth = 0.1
bin(x,w) = w*floor(x/w) + w/2.0

# Gaussiana teórica N(0,1): P(x) = (1 / sqrt(2*pi)) * exp(-x^2 / 2)

# Normalización automática en Gnuplot
stats "resultados/data_alg2_eta1.0_h0.0010.dat" u 4 nooutput
N = STATS_records  # Cuenta automáticamente cuántos puntos reales hay en el archivo

binwidth = 0.1
bin(x,w) = w*floor(x/w) + w/2.0
gaussiana(x) = (1.0 / sqrt(2.0 * pi)) * exp(- (x**2) / 2.0)

set style fill solid 0.5 border lc rgb "black"

plot "resultados/data_alg2_eta1.0_h0.0010.dat" u (bin($4,binwidth)):(1.0/(binwidth*N)) smooth freq w boxes lc rgb "skyblue" title "Simulación", \
     gaussiana(x) w l lw 3 lc rgb "red" title "Gaussiana Teórica N(0,1)"