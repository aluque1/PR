#!/usr/bin/python3
import z3
from z3 import *
import sys

filenameIn = sys.argv[1]
myinput = "".join(open(filenameIn, "r").readlines())
sys.stdin = io.StringIO(myinput)

# reading parameters:

n = int(input())
k = int(input())
coefs = []
for i in range(n):
    rcoef = input().split()
    scoef = []
    for j in range(k+1):
        scoef.append(int(rcoef[j]))
    coefs.append(scoef)
r = int(input())

# end of parameters part 1
# reading of additional parameters for part 2 (uncomment):
#m = int(input())
#inc = []
#for i in range(m):
#    pair = input().split()
#    a1 = int(pair[0])
#    a2 = int(pair[1])
#    inc.append([a1,a2])

# end of parameters
def n_equis(i):
    return "x_"+str(i)

def addsum(a):
    if len(a) == 0:
        return 0
    else:
        asum = a[0]
        for i in range(1,len(a)):
            asum = asum + a[i]
        return asum

def sumandmult(_coefs):
    if len(_coefs) == 0:
        return 0
    else:
        asum = _coefs[0]
        for i in range(1, len(_coefs)):
            asum = asum + _coefs[i]*equises[i-1]

    return asum

s = SolverFor("QF_LIA")

# Definicion de variables de la solucion
equises = []
for i in range(0, k):
    equises.append(Int(n_equis(i)))
# Fin definicion

# Constraint sum(forall(i in 0..n)(coefs[i][0] + sum(j in 1..k+1)(coefs[i][j]*equises[j]) <= 0)) >= r;
c = 0
for i in range(0,n):
    c += If(sumandmult(coefs[i]) <= 0, 1, 0)

s.add(c >= r)

print(s.check())

#if s.check == z3.sat:
for i in range(0, k):
    print(s.model().eval(equises[i]))

