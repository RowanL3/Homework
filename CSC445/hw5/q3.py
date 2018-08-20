
def is_subsequence(X,Y,n,m):
    i = 0 
    j = 0
    while i < n and j < m:
        if X[i] == Y[j]:
            i += 1
        j += 1
    
    return (i==n)

w1 = "this is a test"
w2 = "is a "
w3 = " not here"
w4 = "not"

w5 = "aaabx"
w6 = "aab"

print(is_subsequence(w2,w1,len(w2),len(w1)))
print(is_subsequence(w4,w3,len(w4),len(w3)))
print(is_subsequence(w1,w5,len(w1),len(w5)))
print(is_subsequence(w6,w5,len(w6),len(w5)))
            


