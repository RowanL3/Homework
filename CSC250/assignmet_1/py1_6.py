s = input("Enter sentence: ")
n = 0
for c in s:
    if c.isupper():
        n += 1

print(n)