include "alldifferent.mzn";
%include "exists.mzn";

int: D; % Dias
int: T; % Trabajadores
int: N1; % Num trabajadores turno 1
int: N2; % Num trabajadores turno 2
int: N3; % Num trabajadores turno 3
int: MaxDT; % Maximo dias consecutivos
int: MaxDL; % Maximo dias libres
int: MinDT; % Minimo de dias trabajados.
int: A;  %numero minimo de trabajadores afines
array[1..T, 1..T] of 0..1: afines;  %matriz de trabajadores afines entre si
set of 1..T: R;  %empleados encargados

int: total_turnos = N1+N2+N3; 

array[1..D, 1..total_turnos] of var 1..T : sol; % Que trabajadores hay en cada turno cada dia.

% 1. satisfaccion
constraint assert (T >= total_turnos, "No hay suficientes trabajadores para cubrir los turnos.");
constraint forall (x in 1..D)(alldifferent([sol[x, y] | y in 1..N1])); 
constraint forall (x in 1..D)(alldifferent([sol[x, y] | y in N1+1..N1+1+N2])); 
constraint forall (x in 1..D)(alldifferent([sol[x, y] | y in N1+N2+2..total_turnos])); 

% 2. satisfaccion
constraint forall(x in 1..D) (alldifferent([sol[x, y] | y in 1..total_turnos]));

% 3. satisfaccion
constraint forall(t in 1..T) (forall(d in 1..D-MaxDT) ((sum(i in d..d+MaxDT, j in 1..total_turnos where sol[i,j] == t)(1)) <= MaxDT));

%4. satisfaccion
constraint forall(t in 1..T) (forall(d in 1..D-MaxDL) ((sum(i in d..d+MaxDL, j in 1..total_turnos where sol[i,j] == t)(1)) >= 1));

% 5. satisfaccion
constraint assert ((T * MinDT/total_turnos) <= D, "Hay demasiados trabajadores para que todos trabajen el minimo.");
constraint forall(t in 1..T)((sum(i in 1..D, j in 1..total_turnos where sol[i,j] == t)(1)) >= MinDT);

% 6. satisfaccion
constraint forall(t in 1..T)(forall(d in 1..D-1)(not(sum(x in N1+N2+2..total_turnos where sol[d,x] = t)(1) = 1 /\ 
                                                      sum(y in 1..N1 where sol[d,y] = t)(1) = 1)));

% 7. satisfaccion
constraint forall(t in 1..T)(forall(d in 1..D-2)( not(sum(x in N1+N2+2..total_turnos where sol[d,x] = t)(1) = 1 /\ sum(x in N1+N2+2..total_turnos where sol[d+1,x] = t)(1) = 1) \/ sum(turn in 1..total_turnos where sol[d+2,turn] != t)(1) = 0));
                              
%8. satisfaccion
constraint assert(A<=T, "Hay demasiado pocos trabajadores para que sean afines");
constraint assert(A<= N1 /\ A <= N2 /\ A <= N3, "Hay demasiado pocos turnos para que trabajen afines");

constraint forall(d in 1..D)(forall(t in 1..N1)((sum(t2 in 1..N1)(afines[sol[d,t], sol[d, t2]])) >= A));
constraint forall(d in 1..D)(forall(t in N1+1..N1+N2+1)((sum(t2 in N1+1..N1+N2+1)(afines[sol[d,t], sol[d, t2]])) >= A));
constraint forall(d in 1..D)(forall(t in N1+N2+2..total_turnos)((sum(t2 in N1+N2+2..total_turnos)(afines[sol[d,t], sol[d, t2]])) >= A));

%9. satisfaccion
constraint forall(d in 1..D)(exists(h in 1..N1)(exists(r in R)(sol[d,h] = r)));
constraint forall(d in 1..D)(exists(h in N1+1..N1+N2+1)(exists(r in R)(sol[d,h] = r)));
constraint forall(d in 1..D)(exists(h in N1+N2+2..total_turnos)(exists(r in R)(sol[d,h] = r)));
























