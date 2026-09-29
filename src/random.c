#include "random.h"

#define PI 3.14159265358979323846

//Creamos un numero aleatorio entre 0 y 1 (sin incluir el 0), siendo una distribucion uniforme
void init_random(){
    srand((unsigned int)time(NULL));
}

double rand_uniform(){
    return ((double)rand() + 1.0) / ((double)RAND_MAX + 1.0);
}

//Creamos un numero aleatorio siguendo una gaussiana (BOX MULLER) a partir de un par de numeros aleatorios a partir de una distribucion uniforme
double rand_gaussian(){
    double x1 = rand_uniform();
    double x2 = rand_uniform();

    double salida1 = sqrt(-2.0 * log(x1)) * (-1.0) * cos(2.0 * PI * x2);
    double salida2 = sqrt(-2.0 * log(x1)) * (-1.0) * sin(2.0 * PI * x2);

    //Sacamos uno de los dos por dar un resultado, pero podriamos usar los dos (si en un futuro queremos solo uno, borramos el otro para que no haga tdo el rato el calculo)
    return salida1;
}

//Algoritmo para ver si existe correlación en el generador de numeros aleatorios.
void correlacion_numeros_aleatorios(const char* file, int N_muestras) {
    FILE* f = fopen(file, "w");
    double r;
    if (!f) {
        printf("Error al abrir el archivo\n");
        return;
    }
    for (int i = 0;i < N_muestras;i++) {
        r = rand_gaussian();
        fprintf(f, "% .6f\n", r);
    }
    fclose(f);
}