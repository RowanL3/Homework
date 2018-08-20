#Rowan lochrin
#CSC 250
#HW7 4/29/16
import re

def filt(pat):
    return lambda l:list(filter(lambda s:re.match(pat,s),l))

hw7_1 = filt(r'.*d.*')
hw7_2 = filt(r'.*ck$')
hw7_3 = filt(r'[a-f]+$')
hw7_4 = filt(r'^\d+')
hw7_6 = filt(r'.*(?<!tmp)$')
hw7_9 = filt(r'.*\d$')

hw7_5 = lambda l: list(map(lambda s:s.strip(),filt(r'^\B')(l)))
hw7_7 = lambda l: list(map(lambda s:re.search(r'\b\d{4}\b',s).group(),filt(r'.*\b\d{4}\b.*')(l)))
hw7_8 = lambda l: list(map(lambda s:(int(re.search(r'(\d+)x(\d+)',s).group(1 )),int(re.search(r'(\d+)x(\d+)',s).group(2))),l))