from functools import reduce

def partition(number):
    answer = set()
    answer.add((number, ))
    for x in range(1, number):
        for y in partition(number - x):
            answer.add(tuple(sorted((x, ) + y)))
    return answer

def gcd(a, b):
    while b:      
        a, b = b, a % b
    return a

def lcm(a, b):
    return a * b // gcd(a, b)

def lcmm(*args):
    return reduce(lcm, args)

for n in range(1,13):

    if not (n % 2):
        print('n =',n)
        for p in sorted(partition(n),key =lambda x:len(x)):
            if not sum(map(lambda x:1 if x % 2 == 0 else 0,p)) % 2:
               if n < lcmm(*p):
                    print(p,"lcm = {}".format(lcmm(*p)))
            else:
                pass
                #print(p,"odd")

