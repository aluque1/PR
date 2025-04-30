#!/usr/bin/python3
import z3
from z3 import *
import sys

filenameIn = sys.argv[1]
myinput = "".join(open(filenameIn, "r").readlines())
sys.stdin = io.StringIO(myinput)

# reading parameters:
VALOR = int(input()) #por cuanto vendemos el aceite
dureza = []
aux = input().split()
for i in range(0,5):
    dureza.append(float(aux[i]))

precios = []
for i in range(0,6):
    tpre1 = input().split()
    lpre = []
    for j in range(0,5):
        lpre.append(int(tpre[j]))
    coefs.append(lpre)

MAXV = int(input())     #cuando aceite vegetal podemos refinar como máximo
MAXN = int(input()) #cuanto aceite no vegetal podemos refinar como máximo
MCAP = int(input()) #cuanto aceite de cada tipo podemos almacenar
CA = int(input())   #coste de almacenamiento de los aceites. Los aceites refinados no pueden almacenarse
MinD = float(input())   #dureza minima del aceite no vegatal
MaxD = float(input())   #dureza máxima del aceite no vegatal
MinB = int(input())   #beneficio mínimo

inicial = []    #aceites con los que empezamos
aux = input().split()
for i in range(0,5):
    inicial.append(int(aux[i]))

PV = float(input()) #porcentaje de desviación con los aceites con los q empezamos

# end of parameters


#funciones auxiliares
def n_equis(i):
    return "x_"+str(i)

#fin de las definiciones


s = SolverFor("QF_LIA")


# Definicion de variables de la solucion
int a = 0
aceiteTotal = []    #aceite que tenemos este mes, antes de refinar. matriz 6x5
for i in range(0, 6):
    aux = []
    for j in range (0, 5):
        aux.append(Int(n_equis(a)))
        a+=1
    aceiteTotal.append(aux)

aceiteComprado = []    #aceite que compramos este mes. matriz 6x5
for i in range(0, 6):
    aux = []
    for j in range (0, 5):
        aux.append(Int(n_equis(a)))
        a+=1
    aceiteComprado.append(aux)

cuantoRefinar = []    #aceite que refinamos este mes. matriz 6x5
for i in range(0, 6):
    aux = []
    for j in range (0, 5):
        aux.append(Int(n_equis(a)))
        a+=1
    cuantoRefinar.append(aux)
# Fin definicion


#constraints


# Constraint sum(forall(i in 0..n)(coefs[i][0] + sum(j in 1..k+1)(coefs[i][j]*equises[j]) <= 0)) >= r;
c = 0
for i in range(0,n):
    c += If(sumandmult(coefs[i]) <= 0, 1, 0)

s.add(c >= r)

#fin constraints

print(s.check())

#if s.check == z3.sat:
for i in range(0, k):
    print(s.model().eval(equises[i]))

