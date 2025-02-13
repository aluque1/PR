int : nObjetos = 4;
int : presupuesto = 10;
array [1..nObjetos, 1..2] of int: infoObjetos = [|4, 2|3, 4|5, 5|2, 1|]; %coste, superficie


array [1..nObjetos] of var 0..1: objetosComprados; %solo puedes comprar uno de cada 

%constraint forall (x in 1..nObjetos)(objetosComprados[x] >= 0);

constraint (sum(x in 1..nObjetos)(infoObjetos[x, 1] * objetosComprados[x])) <= presupuesto;

solve maximize (sum(x in 1..nObjetos)(infoObjetos[x, 2] * objetosComprados[x]));