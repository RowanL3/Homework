import sys
import random

m = int(sys.argv[1])

print("I've picked a number. Can you guess it? It's between 1 and {} (inclusive).".format(m))
n = random.randint(1,m)
i = 0
while True:
    g = int(input("Your guess: "))
    i += 1
    if g == n:
        print("You guessed right in {} tries!".format(i))
        quit()
    if g > n:
        print("Pick lower.", end = " ")
    if g < n:
        print("Pick higher.", end = " ")

