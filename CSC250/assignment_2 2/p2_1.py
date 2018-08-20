import sys

name = sys.argv[-1]
file_input = open(name)
line_number = 0
for line in file_input:
    line_number += 1
    if line_number == 5:    
        print(line)
    if line_number == 7:
        for i in line.split(','):
            i = i.strip()
            if i.startswith('S') or i.startswith('W'):
                neg = True
            else:
                neg = False
            i = i[1:].split(' ')
            i = float(i[0]) + float(i[1])/60
            if neg == True:
                i = -i
            print(i,end=" ")
        print('\n')