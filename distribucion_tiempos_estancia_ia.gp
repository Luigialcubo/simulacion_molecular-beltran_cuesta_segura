set terminal pngcairo enhanced font "sans,11" size 900, 500

# 1. Parámetros estáticos y funciones
binwidth = 10.0
bin(x, w) = w * (floor(x / w) + 0.5)
safe_log(val) = (val > 1e-12) ? log(val) : 1/0

set boxwidth binwidth
set style fill solid 0.5 border lc rgb "#1c3b82"

# Listas de valores
list_eta = "5.00 1.00 0.10 0.01"
list_A   = "2.0 1.0 0.5"

# 2. Bucle anidado
do for [eta in list_eta] {
    do for [A in list_A] {

        archivo = sprintf("resultados/doblepozo_eta%s_A%s.dat_tiempos.dat", eta, A)

        # PASO A: Crear tabla con la frecuencia de cada bin
        set table "temp_histograma.dat"
        plot archivo using (bin($1, binwidth)):(1.0) smooth frequency
        unset table

        # PASO B: Calcular N_saltos y tau_exp sin usar 'stats'
        N_saltos = 0
        sum_t = 0.0
        set table "temp_dummy.dat"
        plot archivo using (N_saltos = N_saltos + 1, sum_t = sum_t + $1, $1)
        unset table
        
        tau_exp = (N_saltos > 0) ? (sum_t / N_saltos) : 0.0
        peso = (N_saltos > 0) ? (1.0 / (N_saltos * binwidth)) : 1.0

        # PASO C: Configurar la imagen PNG
        set output sprintf("plots objetivo 2/distribucion_tiempos_eta%s_A%s.png", eta, A)

        set title sprintf("Distribución de Tiempos de Estancia P(t) (\\eta=%s, A=%s)", eta, A) font "sans-bold,12"
        set xlabel "Tiempo de estancia t" font "sans-bold,11"
        set ylabel "ln( P(t) )" font "sans-bold,11"
        set grid

        # Posicionamiento de la leyenda arriba a la derecha con caja sólida de fondo blanco para que no interfiera
        set key top right box opaque spacing 1.2

        # Rango Y ampliado de -15 a 0 (dando un poco de margen superior)
        set yrange [-15 : 1]
        set autoscale x

        # Graficar con cajas
        plot "temp_histograma.dat" using 1:(safe_log($2 * peso)) with boxes \
            lc rgb "#4169e1" \
            title sprintf("Simulación (<{/Symbol t}>_{exp} = %.2f)", tau_exp)

        set output
    }
}