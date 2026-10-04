#pragma once
#include "simulacion.h"
#include "random.h"

//Aqui haremos las funciones de los 3 algoritmos

//Euler-Maruyama
void step_euler_maruyama(Particle1D *part, double eta, double h);

//Runge-Kutta de 2º Orden Estocástico
void step_runge_kutta2(Particle1D *part, double eta, double h);

//Verlet Explícito Estocástico (Algoritmo Gronbech-Jensen)
void step_verlet_gjf(Particle1D *part, double eta, double h);