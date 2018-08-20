#Rowan Lochrin
#CSC 250
#HW5 4/15/16

from operator import mul
from functools import reduce

def primes(n):
    return [p for p in range(2,n+1) if not [i for i in range(2,int((p+3)/2)) if p % i == 0]]

def prime_factors(n,pl):
    f = []
    i = 0
    while abs(n) != 1 and n != 0:
        p = pl[i]
        while not n % p:
            f.append(p)
            n /= p
        i += 1

    if n == -1:
        f.append(-1)
    return f

class RationalNumber:

    primes = primes(1000)

    def __init__(self,a,b):
        if isinstance(a,int) and isinstance(b,int):
            self.numerator = a
            self.denominator = b
            self._simplify()
        else:
            raise ValueError("Arguments must be int ",a,b)

    def __repr__(self):
        return 'RationalNumber({}, {})'.format(str(self.numerator), str(self.denominator))

    def __eq__(self,other):
        if isinstance(other,RationalNumber):
            return other.numerator == self.numerator and other.denominator == self.denominator
        elif isinstance(other,int):
            return float(self.numerator/self.denominator) == float(other)
        else:
            raise ValueError()

    def __add__(self,other):
        if isinstance(other,RationalNumber):
            r_sum = RationalNumber(self.numerator*other.denominator + other.numerator*self.denominator,self.denominator*other.denominator)
        elif isinstance(other,int):
            r_sum = RationalNumber(self.numerator + other*self.denominator,self.denominator)
        else:
            raise ValueError()

        r_sum._simplify()
        return r_sum

    def __sub__(self,other):
        if isinstance(other,RationalNumber):
            r_sum = RationalNumber(self.numerator*other.denominator - other.numerator*self.denominator,self.denominator*other.denominator)
        elif isinstance(other,int):
            r_sum = RationalNumber(self.numerator - other*self.denominator,self.denominator)
        else:
            raise ValueError()

        r_sum._simplify()
        return r_sum

    def __mul__(self,other):
        if isinstance(other,RationalNumber):
            r_sum = RationalNumber(self.numerator*other.numerator,self.denominator*other.denominator)
        elif isinstance(other,int):
            r_sum = RationalNumber(self.numerator*other,self.denominator)
        else:
            raise ValueError()

        r_sum._simplify()
        return r_sum

    def __truediv__(self,other):
        if isinstance(other,RationalNumber):
            r_sum = RationalNumber(self.numerator*other.denominator,self.denominator*other.numerator)
        elif isinstance(other,int):
            r_sum = RationalNumber(self.numerator,self.denominator*other)
        else:
            raise ValueError()

        r_sum._simplify()
        return r_sum

    def _simplify(self):
        if self.denominator < 0:
            self.numerator *= -1
            self.denominator *= -1
        if self.numerator and self.denominator and abs(self.numerator) != 1 and self.denominator != 1:  
            numerator_factors = prime_factors(self.numerator,primes(abs(self.numerator)))
            denominator_factors = prime_factors(self.denominator,primes(abs(self.denominator)))
            for fac in numerator_factors[:]:
                if fac in denominator_factors:
                    numerator_factors.remove(fac)
                    denominator_factors.remove(fac)
            self.numerator = numerator_factors and reduce(mul,numerator_factors) or 1
            self.denominator = denominator_factors and reduce(mul,denominator_factors) or 1

        