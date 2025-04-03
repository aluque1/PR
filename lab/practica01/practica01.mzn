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
array [1..T] of 0..1: TrabRot;  %trabajadores en turnos rotatorios
array[1..T] of 0..1: TrabDob;    %trbajadores que doblan turnos
array[1..T, 1..D] of 0..1: DiasInd; %dias indeseados por los trabajadores
array[1..T, 1..3] of 0..1: TurnosInd;  %turnos indeseados por los trabajadores

int: total_turnos = N1+N2+N3; 

array[1..D, 1..total_turnos] of var 1..T : sol; % Que trabajadores hay en cada turno cada dia.

% 1. satisfaccion
constraint assert (T >= total_turnos, "No hay suficientes trabajadores para cubrir los turnos.");
constraint forall (x in 1..D)(alldifferent([sol[x, y] | y in 1..N1])); 
constraint forall (x in 1..D)(alldifferent([sol[x, y] | y in N1+1..N1+1+N2])); 
constraint forall (x in 1..D)(alldifferent([sol[x, y] | y in N1+N2+2..total_turnos])); 

% 2. satisfaccion
constraint forall(x in 1..D) (alldifferent([sol[x, y] | y in 1..total_turnos where TrabDob[sol[x,y]] != 1]));

% 3. satisfaccion
constraint forall(t in 1..T) (forall(d in 1..D-MaxDT) ((sum(i in d..d+MaxDT, j in 1..total_turnos where sol[i,j] == t)(1)) <= MaxDT));

%4. satisfaccion
constraint forall(t in 1..T where TrabDob[t] = 0) (forall(d in 1..D-MaxDL) ((sum(i in d..d+MaxDL, j in 1..total_turnos where 
                                                                            sol[i,j] == t /\ DiasInd[t,i] != 1)(1)) >= 1));

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

%1. restricciones adicionales
constraint forall(t in 1.. T where TrabRot[t] = 1)(forall(d in 1..D-6)(not(exists(i in 1..N1)(sol[d,i] = t)/\exists(i in 1..N1)(sol[d+1,i] = t)/\
                                                       exists(i in N1+1.. N1+N2+1)(sol[d+2,i] = t) /\exists(i in N1+1.. N1+N2+1)(sol[d+3,i] = t)
                                                       /\ exists(i in N1+N2+2..total_turnos)(sol[d+4, i] = t)) 
                                                       \/ (sum(x in 1..total_turnos where sol[d+5, x] = t)(1) = 0 /\
                                                            sum(x in 1..total_turnos where sol[d+6, x] = t)(1) = 0)));

%2. restricciones adicionales
constraint forall(t in 1..T where TrabDob[t] = 1) (forall(d in 1..D-MaxDL) (
(sum(i in d..d+MaxDL, j in 1..total_turnos where sol[i,j] == t)(1)) >= 1 \/ sum(i in 1..total_turnos where sol[max(1, d-1),i] = t)(1) = 2));
constraint forall(t in 1..T where TrabDob[t] = 1)(forall(d in 1..D-1)(not(sum(i in 1..total_turnos where sol[d,i] = t)(1) = 2) 
                                                                      \/sum(i in 1..total_turnos where sol[d+1,i] = t)(1) = 0));
                                                                      
constraint forall(t in 1..T where TrabDob[t] = 1)(forall(d in 1..D)(sum(i in 1..total_turnos where sol[d,i] = t)(1)<3));                                          

%3. optimizacion
solve minimize(sum(t in 1..T)(exists(d in 1..D, i in 1.. total_turnos)(sol[d,i] = t)));

%4. optimizacion
%solve minimize(sum(t in 1..T)(sum (d in 1..D)(                          %por cada dia, sumamos
%                sum(turn in 1.. N1 where sol[d,turn] = t /\ TurnosInd[t,1] = 1 )(1) +    %si trabaja el primer turno si no quiere
%                sum(turn in N1+1.. N1+N2+1 where sol[d,turn] = t /\ TurnosInd[t,2] = 1 )(1) +  %el segundo turno
%                 sum(turn in N1+N2+2..total_turnos where sol[d,turn] = t /\ TurnosInd[t,3] = 1 )(1)))); %el último turno




%restricciones auxiliares por eficiencia
constraint forall(d in 1..D)(forall(t in 1..N1-1)(sol[d,t] < sol[d, t+1]));
constraint forall(d in 1..D)(forall(t in N1+1..N1+N2)(sol[d,t] < sol[d, t+1]));
constraint forall(d in 1..D)(forall(t in N1+N2+2..total_turnos-1)(sol[d,t] < sol[d, t+1]));