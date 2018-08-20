from hw6 import *

l =[1]
l.append(1)

print(l)
#max of two
print(max_of_two(3,4))
print(max_of_two(4,3))
print(max_of_two('a',4))
print(max_of_two(['a'],['b']))
print(max_of_two('a',['a']))
print(max_of_two('a',['a']))

#random integers
random.seed(987654321)
print(random_integers(12, 1, 10))

#mean
random.seed(987654321)
print(mean(random_integers(12, 1, 10)))
print(mean(random_integers(12, 1, 10)))
print(mean(random_integers(12, 1, 10)))

#median
random.seed(987654321)
print(median(random_integers(13, 1, 10)))

#find locations of substrings
print(find_locations_of_substring('hw6-5-test.dat'))

#find longest common substring
print(find_longest_common_substring('hw6-6-trial.dat'))