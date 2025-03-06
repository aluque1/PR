include "alldifferent.mzn";

int: D; % Dias
int: T; % Trabajadores
int: N1; % Num trabajadores turno 1
int: N2; % Num trabajadores turno 2
int: N3; % Num trabajadores turno 3
int: MaxDT; % Maximo dias consecutivos
int: MaxDL; % Maximo dias libres
int: MinDT; % Minimo de dias trabajados.

int: total_turnos = N1+N2+N3; 

array[1..D, 1..total_turnos] of var 1..T : sol; % Que trabajadores hay en cada turno cada dia.

% 1. satisfaccion
constraint assert (T >= total_turnos, "No hay suficientes trabajadores para cubrir los turnos.");

% 2. satisfaccion
constraint forall(x in 1..D) (alldifferent([sol[x, y] | y in 1..total_turnos]));

% 3. satisfaccion
constraint forall(t in 1..T) (forall(d in 1..D-MaxDT) ((sum(i in d..d+MaxDT, j in 1..total_turnos where sol[i,j] == t)(1)) <= MaxDT));

% 5. satisfaccion
constraint assert ((T * MinDT/total_turnos) <= D, "Hay demasiados trabajadores para que todos trabajen el minimo.");
