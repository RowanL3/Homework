import sys
strs = []
char_num = 0
hd = 0  

for filename in sys.argv[1:]:
    inputfile = open(filename)
    strs.append(inputfile.read())

for char in strs[0]:
    if char != strs[1][char_num]:
        hd += 1
    char_num += 1

print(hd)