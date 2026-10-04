#Para generar todas las graficas


set terminal pngcairo size 800,600 enhanced font "Helvetica,12"
set grid

# Arrays de parámetros
array ETAS[3] = [0.1, 1.0, 10.0]
array HS[4]   = [0.0001, 0.0010, 0.0100, 0.1000]
array STR_HS[4] = ["0.0001", "0.0010", "0.0100", "0.1000"]


set xlabel "Tiempo t"
set ylabel "Energía cinética promedio <Ec>"
set yrange [0:1.5]

do for [i=1:3] {
    do for [j=1:4] {
        eta_val = ETAS[i]
        h_str   = STR_HS[j]
        
        outfile = sprintf("plots/plots_totales/equiparticion/equiparticion_eta%.1f_h%s.png", eta_val, h_str)
        titlename = sprintf("Equipartición de la energía (eta = %.1f, h = %s)", eta_val, h_str)
        
        file_alg0 = sprintf("resultados/data_alg0_eta%.1f_h%s.dat", eta_val, h_str)
        file_alg1 = sprintf("resultados/data_alg1_eta%.1f_h%s.dat", eta_val, h_str)
        file_alg2 = sprintf("resultados/data_alg2_eta%.1f_h%s.dat", eta_val, h_str)
        
        set output outfile
        set title titlename
        
        plot 0.5 dt 2 lc rgb "black" title "Teoría (<Ec> = 0.5)", \
             file_alg0 u 3:2 w l lw 2 lc rgb "red" title "Euler-Maruyama", \
             file_alg1 u 3:2 w l lw 2 lc rgb "blue" title "Runge-Kutta 2", \
             file_alg2 u 3:2 w l lw 2 lc rgb "green" title "Verlet (G-JF)"
    }
}

unset yrange


set xlabel "Posición x"
set ylabel "Momento p"
set xrange [-3.5:3.5]
set yrange [-3.5:3.5]

array ALGNAMES[3] = ["Euler-Maruyama", "Runge-Kutta 2", "Verlet (G-JF)"]

do for [alg=0:2] {
    do for [j=1:4] {
        h_str = STR_HS[j]
        
        outfile = sprintf("plots/plots_totales/espacio_fases/fases_alg%d_h%s.png", alg, h_str)
        titlename = sprintf("Espacio de Fases (p vs x) - %s (h = %s)", ALGNAMES[alg+1], h_str)
        
        f_eta0 = sprintf("resultados/data_alg%d_eta0.1_h%s.dat", alg, h_str)
        f_eta1 = sprintf("resultados/data_alg%d_eta1.0_h%s.dat", alg, h_str)
        f_eta2 = sprintf("resultados/data_alg%d_eta10.0_h%s.dat", alg, h_str)
        
        set output outfile
        set title titlename
        
        plot f_eta0 u 4:5 w p pt 7 ps 0.2 lc rgb "blue" title "eta = 0.1 (Subamortiguado)", \
             f_eta1 u 4:5 w p pt 7 ps 0.2 lc rgb "green" title "eta = 1.0 (Intermedio)", \
             f_eta2 u 4:5 w p pt 7 ps 0.2 lc rgb "red" title "eta = 10.0 (Sobreamortiguado)"
    }
}

unset xrange
unset yrange


set xlabel "Posición x"
set ylabel "Densidad de Probabilidad P(x)"

binwidth = 0.1
bin(x,w) = w*floor(x/w) + w/2.0
gaussiana(x) = (1.0 / sqrt(2.0 * pi)) * exp(- (x**2) / 2.0)

set style fill solid 0.5 border lc rgb "black"

do for [alg=0:2] {
    do for [i=1:3] {
        do for [j=1:4] {
            eta_val = ETAS[i]
            h_str   = STR_HS[j]
            
            datafile = sprintf("resultados/data_alg%d_eta%.1f_h%s.dat", alg, eta_val, h_str)
            outfile  = sprintf("plots/plots_totales/histogramas/histo_alg%d_eta%.1f_h%s.png", alg, eta_val, h_str)
            titlename = sprintf("Distribución P(x) - Alg%d (%s) | eta=%.1f, h=%s", alg, ALGNAMES[alg+1], eta_val, h_str)
            
            # Obtener el número real de puntos en el archivo para normalizar a 1.0 el área
            stats datafile u 4 nooutput
            N_pts = STATS_records
            
            set output outfile
            set title titlename
            
            if (N_pts > 0) {
                plot datafile u (bin($4,binwidth)):(1.0/(binwidth*N_pts)) smooth freq w boxes lc rgb "skyblue" title "Simulación", \
                     gaussiana(x) w l lw 3 lc rgb "red" title "Gaussiana Teórica N(0,1)"
            }
        }
    }
}

