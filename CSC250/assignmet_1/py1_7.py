s = ''.join([c.lower() for c in input("Phrase: ") if c.isalnum()])
print(s == s[::-1])
