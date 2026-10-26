#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

//Parametros fijos
#define MASS 1.0
#define K_SPRING 1.0
#define KB_T 0.2
#define PI 3.141592653589793238
#define B_LEN 1.0
#define N 16

extern int FLAG; //Método empleado (Euler-Maruyama (flag=0), Runge-Kutta (flag=1), Verlet explicito(flag=2)).

//Estado de una particula en una dimension
typedef struct {
    double x; // Posición
    double p; // Momento (p = m*v)
} Particle1D;

//Estado de una partícula en tres dimensiones
typedef struct {
    double r[3]; // (Vector posición  r[0]-->r.x, r[1]-->r.y, r[2]-->r.z)
    double p[3]; // (Vector momento  p[0]-->p.x, p[1]-->p.y, p[2]-->p.z)
    double f[3]; // (Vector fuerza sobre cada particula f[0]-->f.x, f[1]-->f.y, f[2]-->f.z)
} Particle3D;

//Obtiene los pasos de termalización.
long long thermalization_steps(double eta, double h, double *t_term);

//Termalizacion
double thermalization(Particle1D* part,double eta, double h, int flag);

//Termalizacion para el segundo sistema.
void thermalization2(Particle1D* part, double eta, double h, double A);

//Teorema de la equipartición
void equipartition( Particle1D *part, double t_final, double h, double eta, const char* file, double t_term);

//Para el segundo sistema, ya con Verlet fijo
void equipartition2( Particle1D *part, double t_final, double h, double eta, double A, const char* file);
//Simulacion con F=cte
void simular_fuerza_constante(Particle1D *part, double t_final, double h, double eta, double A);


