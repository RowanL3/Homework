import Data.Function
import System.Random

--Helper Functions
odds :: [a] -> [a]
odds []         = []
odds (x:xs) = x : evens xs

evens :: [a] -> [a]
evens []         = [] 
evens (x:xs) = odds xs

myLen :: [a] -> Int
myLen [] = 0
myLen (x:xs) = 1 + myLen xs

myMap :: (a -> b) -> [a] -> [b]
myMap f []      = []
myMap f (x:xs)  = f x : myMap f xs

myFilter :: (a -> Bool) -> [a] -> [a] 
myFilter f []            = [] 
myFilter f (x:xs)       | f x           = x : myFilter f xs
                        | otherwise     = myFilter f xs

myFlatten :: [[a]] -> [a]
myFlatten (x:xs) = x ++ myFlatten xs
myFlatten [] 	 = []

removeRepeats :: Ord a => a -> [a] -> [a]
removeRepeats last []    = []
removeRepeats last (x:xs) | last == x   = removeRepeats x xs
                          | otherwise   = x : removeRepeats x xs 

mySort :: (a -> a -> Ordering) -> [a] -> [a]
mySort cmp [] = []
mySort cmp xs | myLen xs > 1  =
                 let oddsSorted  = mySort cmp (odds xs)
                     evensSorted = mySort cmp (evens xs)
                     in myMerge cmp oddsSorted evensSorted
             | otherwise      = xs

myMerge :: (a -> a -> Ordering) -> [a] -> [a] -> [a]
myMerge cmp xs [] = xs
myMerge cmp [] ys = ys
myMerge cmp (x:xs) (y:ys) | x `cmp` y == LT       = x : myMerge cmp xs (y:ys)
                          | otherwise             = y : myMerge cmp (x:xs) ys

-- 2. Sorting 
intCMP :: Int -> Int -> Ordering
intCMP a b      | a == b = EQ
                | a < b = LT
                | otherwise = GT

intCMPRev :: Int -> Int -> Ordering
intCMPRev a b   | a == b = EQ   
                | a < b = GT
                | otherwise = LT

floatCMP :: Float -> Float -> Ordering
floatCMP a b    | a == b = EQ   
                | a < b = LT
                | otherwise = GT

sort3 :: (a -> a -> Ordering) -> [a] -> [a]
sort3 cmp (a:b:c:d:ls) = error "can't sort more than 3 elements!!!"

sort3 cmp (a:b:c:ls)    | a `cmp` b == LT =
                                if c `cmp` a == LT then (c:a:b:ls) 
                                else if b `cmp` c == LT then (a:b:c:ls)
                                else (a:c:b:ls)
                        | otherwise =
                                if c `cmp` b == LT then (c:b:a:ls) 
                                else if a `cmp` c == LT then (b:a:c:ls)
                                else (b:c:a:ls)

sort3 cmp (a:b:ls)      | a `cmp` b == LT       = a:b:ls
                        | otherwise             = b:a:ls
sort3 _ xs              = xs

type Pair = (Int, Int)

pairCMP :: Pair -> Pair -> Ordering
pairCMP (a1, a2) (b1, b2)       | a1 > b1       = GT
                                | a1 < b1       = LT
                                | a2 > b2       = GT
                                | a2 < b2       = LT
                                | otherwise     = EQ

merge :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
merge cmp xs [] = xs
merge cmp [] ys = ys
merge cmp (x:xs) (y:ys) | x `cmp` y == LT       = x : merge cmp xs (y:ys)
                        | otherwise             = y : merge cmp (x:xs) ys

msort :: Ord a => (a -> a -> Ordering) -> [a] -> [a]
msort cmp [] = []
msort cmp xs | myLen xs > 1  =
                 let oddsSorted  = msort cmp (odds xs)
                     evensSorted = msort cmp (evens xs)
                     in merge cmp oddsSorted evensSorted
             | otherwise      = xs

fsort :: Ord a => (a -> a -> Ordering) -> [a] -> [a]
fsort cmp [] = []
fsort cmp xs | myLen xs > 3  =
                 let oddsSorted  = fsort cmp (odds xs)
                     evensSorted = fsort cmp (evens xs)
                     in merge cmp oddsSorted evensSorted
             | otherwise      = sort3 cmp xs

--MSORT Times:
--real	0m1.819s
--user	0m0.244s
--sys	0m0.516s

--FSORT Times:
--real	0m1.630s
--user	0m0.236s
--sys	0m0.481s

-- Set Manipulation 
-- ADD ERRROR CHECKING 
checkSet cmp xs | isSet cmp xs 		= xs
		| otherwise 		= error "arguments must be sets" 

makeSet :: Ord a => (a -> a -> Ordering) -> [a] -> [a]
makeSet cmp (x:xs) = x : removeRepeats x (fsort cmp xs)

isSet :: Ord a => (a -> a -> Ordering) -> [a] -> Bool
isSet cmp (a:b:xs) | a `cmp` b == LT = isSet cmp (b:xs) 
                   | otherwise       = False 
isSet _ _          = True

-- the second argument must be a set
member :: Ord a => (a -> a -> Ordering) -> a -> [a] -> Bool
member cmp n (x:xs) | n `cmp` x == EQ = True
                    | otherwise       = member cmp n xs 
member cmp n []     = False

setIntersect :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
setIntersect cmp (x:xs) ys | member cmp x ys = x : setIntersect cmp xs ys 
                           | otherwise       = setIntersect cmp xs ys
setIntersect _   []     _  = []

setUnion :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
setUnion cmp xs ys = makeSet cmp (xs ++ ys)

setSubtract :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
setSubtract cmp (x:xs) ys | not (member cmp x ys) = x : setSubtract cmp xs ys
			  | otherwise  	          = setSubtract cmp xs ys
setSubtract _	[]     _  = []
	
setCrossproduct :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [(a,a)]
setCrossproduct cmp xs ys = [(x,y) | x <- xs, y <- ys]

setIsSubset :: Ord a => (a -> a-> Ordering) -> [a] -> [a] -> Bool
setIsSubset cmp xs ys | setSubtract cmp xs ys == [] = True
		      | otherwise	            = False 

setSimilarity :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> Double
setSimilarity cmp xs ys = fromIntegral (myLen (setIntersect cmp xs ys)) / fromIntegral (myLen (setUnion cmp xs ys))

setContainment :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> Double
setContainment cmp xs ys =  fromIntegral (myLen (setIntersect cmp xs ys)) / fromIntegral (myLen xs) 

--Computing Primes
siever :: Int -> [Int] -> [Int]
siever n xs = myFilter (relprime n) xs

sieve :: [Int] -> [Int]
sieve (x:xs) = x : sieve (siever x xs) 
sieve _      = []

relprime :: Int -> Int -> Bool
relprime p n = n `mod` p > 0

--Shuffling Cards
data Suit = Club | Diamond | Heart | Spade
	   deriving Enum	

data Value = Two | Three | Four | Five
	   | Six | Seven | Eight | Nine 
	   | Ten | Jack | Queen | King | Ace
	   deriving Enum	

type Card = (Suit, Value)

type Deck = [Card]

instance Show Suit where
	show Club = "Club"
	show Diamond = "Diamond"
	show Heart = "Heart"
	show Spade =  "Spade"

instance Show Value where
	show Two = "Two"
	show Three = "Three"
	show Four = "Four"
	show Five = "Five"
	show Six = "Six"
	show Seven = "Seven"
	show Eight = "Eight"
	show Nine = "Nine"
	show Ten = "Ten"
	show Jack = "Jack"
	show Queen = "Queen"
	show King = "King"
	show Ace = "Ace"

makeDeck :: Deck 
makeDeck = myFlatten $ myMap (\c -> (myMap (\x -> (c, x)) [Two ..])) [Club ..]

rands :: Int -> Int -> [Float]
rands seed count = take count (randoms (mkStdGen seed)) :: [Float]

shuffle :: Deck -> Int -> Deck
shuffle deck seed = (\(_, a) -> a) (unzip (shuffledDeck deck seed))

shuffledDeck :: Deck -> Int -> [(Float, Card)]
shuffledDeck deck seed =  mySort fpCMP (seeded seed deck)

seeded :: Int -> Deck -> [(Float, Card)]
seeded seed deck = zip (rands seed 52) deck

fpCMP :: (Float, Card) -> (Float, Card) -> Ordering fpCMP (a, _) (b, _)         | a > b         = GT
                            | a < b         = LT
                            | otherwise     = EQ


