ef test():
    try:
        x = RationalNumber(.5, 1)
    except ValueError as e:
        print("Caught exception ", e)
    else:
        print("No exception caught")

    try:
        x = RationalNumber(1, 3.1)
    except ValueError as e:
        print("Caught exception ", e)
    else:
        print("No exception caught")

    x = RationalNumber(50, 100)
    print(x)

print(primes(300))
print(prime_factors(-1,primes(300)))
print(prime_factors(1,primes(300)))
print(prime_factors(0,primes(300)))

w = RationalNumber(50,100)
print('w = ', w)
x = RationalNumber(-7,21)
print('x = ', x)
y = RationalNumber(7,-21)
print('y = ', y)
z = RationalNumber(-21,-63)
print('z = ',z)


print('w==x ',w==x)
print('x==y ',x==y)
print('y==z ',y==z)
print('y==3 ',y==(3))


print('w+x = ', w+x)
print('x+y = ', x+y)
print('y+z = ', y+z)
print('y+3 = ', y+3)

print('w-x = ', w-x)
print('x-y = ', x-y)
print('y-z = ', y-z)
print('y-3 = ', y-3)


print('w*x = ', w*x)
print('x*y = ', x*y)
print('y*z = ', y*z)
print('y*3 = ', y*3)

print('w/x = ', w/x)
print('x/y = ', x/y)
print('y/z = ', y/z)
print('y/3 = ', y/3)

test()