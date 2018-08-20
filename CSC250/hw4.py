#Rowan Lochrin
#CSC 250
#Assignment 4
#4/1/16

def get_from_dictionary(d, k, default = None):
    return k in d and d[k] or default

def primes(n):
    return [p for p in range(2,n+1) if not [i for i in range(2,int((p+3)/2)) if p % i == 0]]

def compute_prime_factors(n,pl):
    f = []
    i = 0
    while n != 1:
        p = pl[i]
        if not n % p:
            f.append(p)
            while not n % p:
                n /= p
        i += 1    
    return f

def add_large_slow(l):
    remainder = 0
    grand_total = ''
    for i in range(max([len(e) for e in l])):
        row_total = sum([int(s[-(i+1)]) for s in l if len(s)>i])  + remainder
        digit = str(row_total % 10)
        remainder = int(row_total / 10)
        grand_total = digit + grand_total 
    if remainder:
        grand_total = str(remainder) + grand_total
    return grand_total

def add_large_native(l):
    return sum([int(n) for n in l])

print(compute_prime_factors(825,primes(10000)))

