% Use this editor as a MiniZinc scratch book
%include "alldiferent.mzn";

int: N = 3;
array[1..N, 1..N] of int: Tiempos = [|10,15,20| 30, 40, 50| 60, 80, 99|];

array[1..N] of var 1..N : asignados;

constraint forall(x in 1..N, y in x+1..N)(asignados[x] != asignados[y]);

solve minimize(sum(x in 1..N)(Tiempos[x,asignados[x]]))