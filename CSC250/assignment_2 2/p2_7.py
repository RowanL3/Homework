import sys

inputfile = open(sys.argv[-1])

#Puting the input file into a list
inputlist=[line.strip() for line in inputfile if line.strip() != '']
#Setting up a 0 matrix
matrix = [[0 for e in inputlist[0]] for e in range(4)]

#Filling the matrix
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

#Creating the consensus         
consensus = ''

for index in range(len(matrix[0])):
    values = {'A': matrix[0][index],'C' : matrix[1][index],'G' : matrix[2][index],'T' : matrix[3][index]}
    consensus += max(values,key=values.get)

#Calculating the min and max HD
min_hd = 999999
max_hd = -999999
for line in inputlist:
    index = 0
    hd = 0
    for letter in line:
        if letter != consensus[index]:
            hd += 1
        index += 1
    if hd > max_hd:
        max_hd = hd
    if hd < min_hd:
        min_hd = hd

#Printing outputs
print(consensus)
print(min_hd,max_hd)