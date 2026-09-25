#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

//Parametros fijos
#define MASS 1.0
#define K_SPRING 1.0
#define KB_T 1.0

//Estado de una particula en una dimension
typedef struct {
    double x; // Posición
    double p; // Momento (p = m*v)
} Particle1D;

