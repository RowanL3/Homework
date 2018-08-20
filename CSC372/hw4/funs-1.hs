import Prelude
import Data.Char

-- File: funs.hs
-- Date: 9/10/17
-- Author: Rowan Lochrin
-- Class: CSC372

-- Non-recursive Functions

doublestring :: String -> String
doublestring s 		= s ++ s

charToString		:: Char -> String
charToString c 		= c : []

cylinderSurfaceArea :: (Float, Float) -> Int
cylinderSurfaceArea (r, h) = floor (2 * pi * r * h + 2 * pi * r ^ 2)
				where pi = 3.14159 

third 				:: [Int] -> Int
third xs = head $ tail $ tail xs

yahtzee 			:: [Int] -> Bool
yahtzee (a:b:c:d:e:f:_) |a /= b 	= False
						|b /= c		= False
						|c /= d		= False
						|e /= f		= False
						|a > 6		= False
						|a < 1		= False
						|otherwise	= True

-- Recursive Functions

msum 				:: Int -> Int
msum n  			= if n <= 0 
					then 0 
					else n + msum (n - 1)

gsum 				:: Int -> Int
gsum n  			| n == 0  	= 0 
					| otherwise 	= n + gsum (n - 1) 
	
 
copystring 			:: (String, Int) -> String
copystring (s, n) 	| n <= 0 	= []
		 			| otherwise  	= "s" ++ copystring (s, n - 1)

numlist				:: Int -> [Int]
numlist n  			| n < 0 	= error "illegal argument"
					| n == 0 	= [0]
	    			| otherwise	= numlist (n - 1) ++ [n]

allsame 			:: [Int] -> Bool
allsame (a:b:xs)	= a == b && allsame (b:xs)
allsame _ 			= True

swap 				:: [Int] -> [Int]
swap (a:b:xs) 		= [b,a] ++ swap xs
swap xs 			= xs 

split 				:: [Int] -> ([Int], [Int])
split xs = (oddSplit xs, evenSplit xs)

oddSplit 			:: [Int] -> [Int]
oddSplit [] 		= []
oddSplit (x:xs) 	= x : evenSplit xs

evenSplit 			:: [Int] -> [Int]
evenSplit []	 	= [] 
evenSplit (x:xs) 	= oddSplit xs

-- Phone Book

phoneDB = [("Jenny", "867-5309"), ("Alice", "555-1212"), ("Bob", "621-6613")]

nameEQ (a, _) (b, _) 	= a == b
numberEQ (_, b) (_, a) 	= a == b
intEQ a b 				= a == b

member 				:: Eq a => (a -> a -> Bool) -> a -> [a] -> Bool
member _  _ [] 		= False
member eq x (y:ys)	| eq x y 	= True
					|otherwise 	= member eq x ys
-- Better solution with currying and map ;-)
-- member eq x ys = or $ map (eq x) ys

-- Credit Card

isValidCC 			:: String -> Bool
isValidCC x 		= luhnSum (string2IntList x) `mod` 10 == 0

-- CC: Helper function
total 				:: [Int] -> Int
total [] 			= 0
total (x:xs) 		= x + total xs

notMap 				:: (a -> b) -> [a] -> [b]
notMap _ [] 		= []
notMap f (x:xs) 	= f x : notMap f xs

char2int 			:: Char -> Int
char2int c 			= ord c - 48

-- CC: Assigned functions
string2IntList 		:: String -> [Int]
string2IntList 		= notMap char2int 

sumDigits 			:: Int -> Int
sumDigits n 		= (n `quot` 10) + (n `mod` 10) 

sumDigitsList 		:: [Int] -> [Int]
sumDigitsList 		= notMap sumDigits

doubleDigits 		:: [Int] -> [Int]
doubleDigits 		= notMap (* 2)

everyOther 			:: [Int] -> [Int]
everyOther 			= oddSplit

luhnSum 			:: [Int] -> Int
luhnSum l			= let 	evens = total $ sumDigitsList $ doubleDigits $ evenSplit $ reverse  l
						odds = total $ oddSplit $ reverse l
						in evens + odds
