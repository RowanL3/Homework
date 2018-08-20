n1 = int(input("n1: "))
n2 = int(input("n2: "))
def cycle_length(n):
    count = 1
    while n != 1:
        if n%2 == 0:
            n = int(n/2)
        else:
            n = (n*3)+1
        count += 1
    return count

print(max(map(cycle_length,range(n1,n2+1))))