import sys

name = sys.argv[-1]
file_input = open(name)
line_number = 0 
max_alt = -999999
for line in file_input:
    line_number += 1
    if line_number > 19:
        alt =[item.strip() for  item in line.split(' ') if item][1]
        if float(alt) > max_alt:
            max_alt = float(alt)

print(max_alt)
