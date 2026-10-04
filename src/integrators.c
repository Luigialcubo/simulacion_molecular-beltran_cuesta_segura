#include "integrators.h"

void step_euler_maruyama(Particle1D *part, double eta, double h) {
    //Pedimos un numero aleatorio gaussiano
    double Z = rand_gaussian();
    
    // Fuerza determinista del oscilador armónico: f(x) = -k*x
    double f_x = -K_SPRING * part->x;
    
    // Fuerza estocastica Z_amp = sqrt(2 * eta * m * kB*T * h) *Z
    double Z_amp = sqrt(2.0 * eta * MASS * KB_T * h) * Z;
    
    
    double x_next = part->x + (part->p / MASS) * h;
    double p_next = part->p + (-eta * part->p + f_x) * h + Z_amp;
    
    part->x = x_next;
    part->p = p_next;

}

void step_runge_kutta2(Particle1D *part, double eta, double h) {
    //Pedimos un numero aleatorio gaussiano
    double Z = rand_gaussian();

    // Fuerza estocastica Z_amp = sqrt(2 * eta * m * kB*T * h) 
    double Z_amp = sqrt(2.0 * eta * MASS * KB_T * h) * Z;
    
    // Definición de las funciones de derivada g(x, p) = -eta*p - k*x
    // y f(p) = p / m
    double x_n = part->x;
    double p_n = part->p;
    
    // Etapa 1: evaluamos en la posición inicial + fuerza estocástica
    double f_x1 = (p_n + Z_amp) / MASS;
    double g_p1 = -eta * (p_n + Z_amp) - K_SPRING * x_n;
    
    // Etapa 2: evaluamos con el incremento determinista h
    double f_x2 = (p_n + h * g_p1) / MASS;
    double g_p2 = -eta * (p_n + h * g_p1) - K_SPRING * (x_n + h * f_x1);
    
    // Actualización de variables (Promedio de las 2 etapas + Ruido)
    part->x = x_n + 0.5 * h * (f_x1 + f_x2);
    part->p = p_n + 0.5 * h * (g_p1 + g_p2) + Z_amp;

}

void step_verlet_gjf(Particle1D *part, double eta, double h) {
    // Parámetros propios del método Gronbech-Jensen:
        // a = (1 - (eta*h)/(2m)) / (1 + (eta*h)/(2m))
        // b = 1 / (1 + (eta*h)/(2m))
    double gamma_val = (eta * h) / (2.0 * MASS);
    double a = (1.0 - gamma_val) / (1.0 + gamma_val);
    double b = 1.0 / (1.0 + gamma_val);

    //Pedimos un numero aleatorio gaussiano
    double Z = rand_gaussian();
    
    // fuerza estocastica integrado en el intervalo:
    // <beta^2> = 2 * eta * m * kB*T * h
    double beta_stoch = sqrt(2.0 * eta * MASS * KB_T * h) * Z;
    
     // Fuerza determinista del oscilador armónico: f(x) = -k*x
    double f_x = -K_SPRING * part->x;
    
    // 1. Actualizar la posición r^{n+1}
    double x_next = part->x + b * h * part->p + (b * h * h / (2.0 * MASS)) * f_x + (b * h / (2.0 * MASS)) * beta_stoch;
    
    // Fuerza evaluada en la nueva posición f_{n+1} = -k * x_{n+1}
    double f_next = -K_SPRING * x_next;
    
    // 2. Actualizar el momento p^{n+1}
    double p_next = a * part->p + (h / (2.0 * MASS)) * (a * f_x + f_next) + (b / MASS) * beta_stoch;
    
    part->x = x_next;
    part->p = p_next;
}