%aceites totales: 5. aceites vegetales 1,2. aceites no vegetales: 3, 4, 5
int: VALOR; %por cuanto vendemos el aceite
int: MAXV;  %cuando aceite vegetal podemos refinar como máximo
int: MAXN;  %cuanto aceite no vegetal podemos refinar como máximo
int: MCAP;  %cuanto aceite de cada tipo podemos almacenar
int: CA;    %coste de almacenamiento de los aceites. Los aceites refinados no pueden almacenarse
array [1..5] of float: dureza;
float: MinD;    %dureza minima del aceite no vegatal
float: MaxD;    %dureza máxima del aceite no vegetal 
array [1..6, 1..5] of int: precios;
array [1..5] of int: inicial;   %aceites con los que empezamos
float: PV;  %porcentaje de desviación con los aceites iniciales
int: MinB;  %beneficio mínimo

array [1..6] of int: mensualMin;  %minimo numero de aceites q tenemos q usar cada mes
array [1..5] of int: cantidadMin; %cantidad minima de aceite q podemos usar si usamos aceite
array [1..5, 1..5] of int: incompatibles; %aceites incompatibles, si el aceite i es incompatible con el j, incompatibles[i,j] = 1 else 0
array [1..5, 1..5] of int: requeridos; %aceites requeridos, si el aceite i requiere el j, requeridos[i,j] = 1 else 0

array [1..5] of int: costeRefinamiento;  %el coste de refinar una tonelada de cada aceite

array [1..6, 1..5] of var 0..MCAP+max(MAXV, MAXN): aceiteTotal; %el aceite total que tenemos este mes (antes de refinar)
array [1..6, 1..5] of var 0..MCAP+max(MAXV, MAXN): aceiteComprado;  %el aceite comprado este mes (solo para facilitar cálculos)
array [1..6, 1..5] of var 0..max(MAXV, MAXN): cuantoRefinar;    %el aceite total que refinamos este mes 


%cálculos de aceite comprado
constraint forall(a in 1..5)(aceiteTotal[1,a] = inicial[a] + aceiteComprado[1,a]);  %el primer mes
constraint forall(m in 2..6, a in 1..5)(aceiteTotal[m,a] = aceiteTotal[m-1, a] - cuantoRefinar[m-1,a] + aceiteComprado[m, a]);  %el resto  

%constraints para reducir el espacio de búsqueda
constraint forall(a in 1..5)(aceiteComprado[1,a] <= inicial[a] + cuantoRefinar[1,a]);  %el primer mes
constraint forall(m in 2..6, a in 1..5)(aceiteComprado[m,a] <= MCAP - aceiteTotal[m-1, a] + cuantoRefinar[m,a]);

%no almacenar mas aceite del que podemos
constraint forall(m in 1..6, a in 1..5)(aceiteTotal[m,a] - cuantoRefinar[m,a] <= MCAP);

%no desviarnos de PV al final
constraint forall(a in 1..5)(int2float(abs((inicial[a] - (aceiteTotal[6, a] - cuantoRefinar[6,a]))))/int2float(inicial[a]) * 100 <= PV);

%no refinar más aceite del que tenemos
constraint forall(m in 1..6, a in 1..5)(cuantoRefinar[m,a] <= aceiteTotal[m,a]);  
%no refinar más aceite vegetal del que podemos
constraint forall(m in 1..6)(cuantoRefinar[m,1] + cuantoRefinar[m,2] <= MAXV);
%no refinar mas aceite no vegetal del que podemos
constraint forall(m in 1..6)(cuantoRefinar[m,3] + cuantoRefinar[m,4] + cuantoRefinar[m,5] <= MAXN);

%que la densidad final sea la adecuada
constraint forall(m in 1..6 where cuantoRefinar[m,3] > 0 \/ cuantoRefinar[m, 4] > 0 \/ cuantoRefinar[m,5] > 0)  %si hay aceites no vegetales
(sum(a in 1..5)(cuantoRefinar[m,a]*dureza[a]) >= MinD * sum(a in 1..5)(cuantoRefinar[m,a]) /\ 
sum(a in 1..5)(cuantoRefinar[m,a]*dureza[a]) <= MaxD * sum(a in 1..5)(cuantoRefinar[m,a])); 

%llegar a los benificios minimos
constraint sum(m in 1..6, a in 1..5)(cuantoRefinar[m,a]*VALOR - aceiteComprado[m,a]*precios[m,a]) >= MinB;

%RESTRICCIONES ADICIONALES

%usar K aceites minimos cada mes
constraint forall(m in 1..6)(sum(a in 1..5 where cuantoRefinar[m,a] >0)(1) >= mensualMin[m]);

%usar un minimo de T si usamos un aceite
constraint forall(m in 1..6)(forall(a in 1..5 where cuantoRefinar[m,a] > 0)(cuantoRefinar[m,a] >= cantidadMin[a]));

%aceites incompatibles: si uno se refina, el otro no puede refinarse
constraint forall(m in 1..6)(forall( a in 1..5, b in 1..5 where incompatibles[a,b] == 1)(
    (cuantoRefinar[m,a] > 0 -> cuantoRefinar[m,b] == 0) 
)); /* si no fuera simetrico se haria con /\
    (cuantoRefinar[m,b] > 0 -> cuantoRefinar[m,a] == 0) tambien */

%aceites requeridos: si uno se refina, el otro tiene que refinarse
constraint forall(m in 1..6)(forall( a in 1..5, b in 1..5 where requeridos[a,b] == 1)(
    (cuantoRefinar[m,a] > 0 <-> cuantoRefinar[m,b] > 0)
));

%RESTRICCION PROPUESTA
%añadir costes de refinamiento al cálculo final de beneficios
%calcular beneficios finales
solve maximize sum(m in 1..6, a in 1..5)(cuantoRefinar[m,a]*VALOR - aceiteComprado[m,a]*precios[m,a] - cuantoRefinar[m,a]*costeRefinamiento[a]);

