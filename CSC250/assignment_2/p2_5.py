import sys

inputfile = open(sys.argv[1])
quarry = sys.argv[2]
occurrences = 0

for line in inputfile:
    for n in range(len(line)):
        if line[n:n + len(quarry)] == quarry:
            occurrences += 1

print(occurrences)