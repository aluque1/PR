%versión 1 (no se rotan)
int : nCajas = 5;
int : hCaja = 9;
int : wCaja = 9;
array [1..nCajas, 1..2] of int : cajas = [|3, 3| 3, 4| 3, 5| 3, 6| 3, 9|];

%array [1.. wCaja, 1..hCaja] of var 1..nCajas : sol;
array [1.. nCajas, 1..2] of var 0..max(hCaja, wCaja) : sol;

%array[1..nCajas, 1..2] of var 1..2 : posDim; %para guardar las rotaciones
%se coje o la altura o la anchura
%constraint forall(x in 1..nCajas)(posDim[x,1] + posDim[x,2] = 3);

%las coordenadas son correctas
constraint forall(x in 1.. nCajas)((sol[x, 1] + cajas[x, 1]) <= wCaja /\ (sol[x, 2] + cajas[x, 2]) <= wCaja);


%no se solapan                                                          %se solapan en y
constraint forall (x in 1..nCajas)
(forall (y in 1..nCajas where y != x)(not((sol[y, 2] <= sol[x, 2])/\(sol[y, 2] + cajas[y, 2] > sol[x, 2])) 
                                    \/ not((sol[y, 1] <= sol[x, 1])/\(sol[y, 1] + cajas[y, 1] > sol[x, 1]))));
                                    
%solo es válido si cubren toda la superficie
