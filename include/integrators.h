#pragma once
#include "simulacion.h"
#include "random.h"

//Aqui haremos las funciones de los 3 algoritmos

//Euler-Maruyama
void step_euler_maruyama(Particle1D *part, double eta, double h);

//Runge-Kutta de 2º Orden Estocástico
void step_runge_kutta2(Particle1D *part, double eta, double h);

//Verlet Explícito Estocástico para un oscilador armónico (Algoritmo Gronbech-Jensen)
void step_verlet_gjf(Particle1D *part, double eta, double h);

//Verlet Explícito Estocástico para el segundo objetivo (Algoritmo Gronbech-Jensen)
void step_verlet_gjf2(Particle1D *part, double eta, double h, double A);
//Verlet Explícito Estocástico para F=cte
void step_verlet_gjf_fuerza(Particle1D* part, double eta, double h, double A, double F_ext);

// Calcula la fuerza armónica entre monómeros consecutivos en 3D
void compute_polymer_forces(Particle3D* polymer);

//Verlet Explícito Estocástico para un polímero
void step_verlet_gjf_polymer(Particle3D* polymer, double eta, double h);