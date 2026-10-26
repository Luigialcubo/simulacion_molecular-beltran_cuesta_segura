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

void step_verlet_gjf2(Particle1D *part, double eta, double h, double A) {
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
    double f_x = -A * 4 * part->x * (part->x*part->x - 1);
    
    // 1. Actualizar la posición r^{n+1}
    double x_next = part->x + b * h * part->p + (b * h * h / (2.0 * MASS)) * f_x + (b * h / (2.0 * MASS)) * beta_stoch;
    
    // Fuerza evaluada en la nueva posición f_{n+1} = -k * x_{n+1}
    double f_next = -A * 4.0 * x_next * (x_next * x_next - 1);
    
    // 2. Actualizar el momento p^{n+1}
 // 2. Actualizar el momento p^{n+1}
    double p_next = a * part->p + (h / 2.0) * (a * f_x + f_next) + b * beta_stoch;
    
    part->x = x_next;
    part->p = p_next;
}

void step_verlet_gjf_fuerza(Particle1D* part, double eta, double h, double A, double F_ext) {
    //Parámetros propios del método Gronbech-Jensen:
    //a = (1 - (eta*h)/(2m)) / (1 + (eta*h)/(2m))
    //b = 1 / (1 + (eta*h)/(2m))
    double gamma_val = (eta * h) / (2.0 * MASS);
    double a = (1.0 - gamma_val) / (1.0 + gamma_val);
    double b = 1.0 / (1.0 + gamma_val);

    //Pedimos un numero aleatorio gaussiano
    double Z = rand_gaussian();

    //<beta^2> = 2 * eta * m * kB*T * h
    double beta_stoch = sqrt(2.0 * eta * MASS * KB_T * h) * Z;

    //Fuerza determinista en x_n con fuerza externa F_ext
    double x = part->x;
    double p = part->p;
    double f_x = -4.0 * A * x * (x * x - 1.0) + F_ext;

    //Actualizar posición x^{n+1}
    double x_next = x + (b * h / MASS) * p
        + (b * h * h / (2.0 * MASS)) * f_x
        + (b * h / (2.0 * MASS)) * beta_stoch;

    //Fuerza evaluada en la nueva posición x^{n+1}
    double f_next = -4.0 * A * x_next * (x_next * x_next - 1.0) + F_ext;

    //Actualizar momento p^{n+1}
    double p_next = a * p + (h / 2.0) * (a * f_x + f_next) + b * beta_stoch;

    part->x = x_next;
    part->p = p_next;
}




//Calcula la fuerza armónica entre monómeros consecutivos en 3D
void compute_polymer_forces(Particle3D* polymer) {
    //Reiniciamos las fuerzas a cero
    for (int i = 0; i < N; i++) {
        polymer[i].f[0] = 0.0;
        polymer[i].f[1] = 0.0;
        polymer[i].f[2] = 0.0;
    }

    //Recorremos los N-1 enlaces entre partículas contiguas (i y i+1)
    for (int i = 0; i < N - 1; i++) {
        int j = i + 1;

        //Vector distancia r_ij = r_i - r_j
        double r_x = polymer[i].r[0] - polymer[j].r[0];
        double r_y = polymer[i].r[1] - polymer[j].r[1];
        double r_z = polymer[i].r[2] - polymer[j].r[2];

        double dist = sqrt(r_x * r_x + r_y * r_y + r_z * r_z);

        //Calculamos la fuerza para cada coordenada
        if (dist > 1e-12) { //Evitamos division por 0
            double factor = -K_SPRING * (dist - B_LEN) / dist;
            double fx = factor * r_x;
            double fy = factor * r_y;
            double fz = factor * r_z;

            //Tercera Ley de Newton
            polymer[i].f[0] += fx;
            polymer[i].f[1] += fy;
            polymer[i].f[2] += fz;
            polymer[j].f[0] -= fx;
            polymer[j].f[1] -= fy;
            polymer[j].f[2] -= fz;
        }
    }
}


void step_verlet_gjf_polymer(Particle3D* polymer, double eta, double h) {
    //Parámetros propios del método Gronbech-Jensen:
    //a = (1 - (eta*h)/(2m)) / (1 + (eta*h)/(2m))
    //b = 1 / (1 + (eta*h)/(2m))
    double gamma_val = (eta * h) / (2.0 * MASS);
    double a = (1.0 - gamma_val) / (1.0 + gamma_val);
    double b = 1.0 / (1.0 + gamma_val);

    //<beta^2> = 2 * eta * m * kB*T * h
    double sigma_beta = sqrt(2.0 * eta * MASS * KB_T * h);

    //Calculamos las fuerzas
    compute_polymer_forces(polymer);

    double beta[N][3];

    for (int i = 0; i < N; i++) {
        for (int d = 0; d < 3; d++) {
            //Generamos variable gaussiana independiente por coordenada
            beta[i][d] = sigma_beta * rand_gaussian();

            //Actualización de la coordenada r_i^{n+1}
            polymer[i].r[d] += b * h * (polymer[i].p[d] / MASS) + (b * h * h / (2.0 * MASS)) * polymer[i].f[d] + (b * h / (2.0 * MASS)) * beta[i][d];
        }
    }

    //Almacenamos f^n
    double f_old[N][3];
    for (int i = 0; i < N; i++) {
        for (int d = 0; d < 3; d++) {
            f_old[i][d] = polymer[i].f[d]; 
        }
    }

    //Recalculamos las fuerzas en las nuevas posiciones r^{n+1}
    compute_polymer_forces(polymer);

    for (int i = 0; i < N; i++) {
        for (int d = 0; d < 3; d++) {
            polymer[i].p[d] = a * polymer[i].p[d] + (h / 2.0) * (a * f_old[i][d] + polymer[i].f[d]) + b * beta[i][d];
        }
    }
}
