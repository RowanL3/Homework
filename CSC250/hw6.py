#Rowan Lochrin
#CSC 250
#HW6 4/28/16
import random
import re

from operator import itemgetter

def max_of_two(a,b):
    try:
        if a > b:
            return a
        return b
    except:
        pass

random_integers = lambda n,l,u: [random.randint(l,u) for i in range(n)]

mean = lambda l: sum(l)/len(l)

def median(l):
    mid = itemgetter((len(l)-1)//2, (len(l))//2)
    return sum(mid(sorted(l)))/2

def find_locations_of_substring(filename):      
    with open(filename) as f:
        s = f.readline().strip()
        t = f.readline().strip() 
    return [m.start() for m in re.finditer(r'(?={})'.format(t),s)]

def find_longest_common_substring(filename):
    strings = []
    s = ''
    with open(filename) as f:
        for l in f.readlines():
            if l.startswith('>'):
                if s:
                    strings.append(s)
                s = ''
            else:
                s = s + l.strip()
        if s:
            strings.append(s)

    longest_total = ''
    for (index,s1) in enumerate(strings):
        for s2 in strings[:index]:
            matrix = [[0 for x in range(len(s2)+1)] for y in range(len(s1)+1)]
            max_length = -1
            for s1_index in range(len(s1)):
                for s2_index in range(len(s2)):
                    if s1[s1_index] == s2[s2_index]:
                        d = matrix[s1_index][s2_index] + 1 
                        matrix[s1_index+1][s2_index+1] = d
                        if d > max_length:
                            max_length = d
                            longest_of_comparison = s1[s1_index + 1 - d:s1_index + 1]

            if len(longest_of_comparison) > len(longest_total):
                longest_total = longest_of_comparison

    return longest_total



                



    

    

