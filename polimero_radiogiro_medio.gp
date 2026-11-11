

outfile = "resultados/ley_escala.dat"

set print outfile
set print

corte = 5000
lista_N = "4 8 16 32 64"
eta_val = "0.1"

do for [N in lista_N] {
    filename = sprintf("resultados/polimero_N%s_eta%s.dat", N, eta_val)
    stats filename every ::corte using 4 name "ST" nooutput
    
    set print outfile append
    print sprintf("%s %.6f %.6f", N, ST_mean, ST_stddev)
    set print
}



f(x) = A * (x**nu)
A = 0.4
nu = 0.5

fit f(x) outfile using 1:2 via A, nu

set terminal pngcairo size 850,650 enhanced font "Arial,11"
set output "plots objetivo 3/radiosgiro/ley_escala_fit.png"

set logscale xy
set xlabel "Número de monómeros (N)"
set ylabel "Radio de Giro medio <R_g> [b]"
set title "Ley de escala del Radio de Giro en Polímeros 3D"
set grid mxtics mytics

# Dar un poco de margen en los ejes para que las etiquetas no se corten
set offset graph 0.1, graph 0.1, graph 0.1, graph 0.1

leyenda_fit = sprintf("Ajuste Teórico: <R_g> = %.3f · N^{%.3f}", A, nu)

# OFFSET CAMBIADO A (1.0, -0.6) PARA MOVER LAS ETIQUETAS POR DEBAJO DE LA RECTA
plot outfile using 1:2:3 title "Medidas Simulación" with yerrorbars pt 7 ps 1.4 lc rgb "blue", \
     outfile using 1:2:(sprintf("N=%g: <R_g>=%.3f", $1, $2)) with labels left offset 1.0, -0.6 tc rgb "dark-blue" title "", \
     f(x) title leyenda_fit lw 2 lc rgb "red"

set output