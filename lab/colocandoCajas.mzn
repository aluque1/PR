%versión 1 (no se rotan)
int : nCajas = 5;
int : hCaja = 9;
int : wCaja = 9;
array [1..nCajas, 1..2] of int : cajas = [|3, 3| 3, 4| 3, 5| 3, 6| 3, 9|];

%array [1.. wCaja, 1..hCaja] of var 1..nCajas : sol;
array [1.. nCajas, 1..2] of var 0..max(hCaja, wCaja) : sol;

%las coordenadas son correctas
constraint forall(x in 1.. nCajas)((sol[x, 1] + cajas[x, 1]) <= wCaja /\ (sol[x, 2] + cajas[x, 2]) <= wCaja);

%no se solapan
constraint forall (x in 1..nCajas)(forall (y in x+1..nCajas)( (sol[y, 2] > (sol[x, 2] + cajas[x,2])) \/(sol[x, 1] < (sol[x, 1] + cajas[x,1]))));