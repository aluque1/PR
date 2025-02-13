%versión 1 (no se rotan)
int : nCajas = 5;
int : hCaja = 9;
int : wCaja = 9;
array [1..nCajas, 1..2] of int : cajas = [|3, 3| 3, 4| 3, 5| 3, 6| 3, 9|];

array [1.. wCaja, 1..hCaja] of var 1..nCajas : sol;

constraint 