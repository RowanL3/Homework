def fib(n):
    if n == 1 or n == 0:
        return n
    else:
        return fib(n-1) + fib(n-2)


fib_max = float(input("limit: "))
n = 0
num = 0
while num <= fib_max:
    print(num)
    n += 1
    num = fib(n)
    

