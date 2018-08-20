import sys

name = sys.argv[-1]
file_input = open(name)
line_number = 0 
best_ne = 999999
for line in file_input:
    line_number += 1
    if line_number > 19:
        hm,alt,ne =[item.strip() for  item in line.split(' ') if item]
        if abs(float(ne)-180) < best_ne:
            best_ne = abs(float(ne)-180)
            best_hm = hm

print(best_hm)
