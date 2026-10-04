#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

//Parametros fijos
#define MASS 1.0
#define K_SPRING 1.0
#define KB_T 1.0
#define PI 3.141592653589793238
#define FLAG 1 //Método empleado (Euler-Maruyama (flag=0), Runge-Kutta (flag=1), Verlet explicito(flag=2)).

//Estado de una particula en una dimension
typedef struct {
    double x; // Posición
    double p; // Momento (p = m*v)
} Particle1D;

//Obtiene los pasos de termalización.
int thermalization_steps(double eta, double h);

//Termalizacion
void thermalization(Particle1D* part,double eta, double h, double *xhist, double *phist);

//Teorema de la equipartición
void equipartition(Particle1D* part, double t_final, double h);



