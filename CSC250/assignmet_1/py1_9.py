n = int(input("n: "))
count = 1
while n != 1:
    if n%2 == 0:
        n = int(n/2)
    else:
        n = (n*3)+1
    count += 1
print(count)
