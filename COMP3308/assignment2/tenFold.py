from sys import argv

infile = argv[1]



with open(infile) as f:
    lines = [line for line in f.readlines()]

lines = list(filter(lambda l: l != '' and l[0] != '#',lines))

lines = [line.split(',') for line in lines]

print(list(lines))
lines = [[row[i] for i in [1, 5, 7, 8]] for row in lines]
print(lines)

with open('pima-CFS.csv', 'r+') as f:
    f.truncate()
    [f.write(','.join(line)) for line in lines]