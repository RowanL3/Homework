import sys

inputfile = open(sys.argv[-1])

inputlist = [line.strip() for line in inputfile if line.strip() != '']
matrix = [[0 for e in inputlist[0]] for e in range(4)]

for line in inputlist:
    index = 0
    for letter in line:
        if letter == 'A':
            matrix[0][index] += 1
        elif letter == 'C':
            matrix[1][index] += 1
        elif letter == 'G':
            matrix[2][index] += 1
        elif letter == 'T':
            matrix[3][index] += 1
        index += 1
        

print(matrix)