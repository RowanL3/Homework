dna = input("DNA string: ")
gc_count = 0.0
for c in dna:
    if c == 'G' or  c=='C':
        gc_count += 1

print((gc_count/float(len(dna)))*100)
