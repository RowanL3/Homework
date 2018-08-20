-- Homework 6: Part A Template -- 
max' :: (Ord a) => [a] -> a
max' xs = head xs 

mul' :: (Num a) => [a] -> a -> [a]
mul' xs x = []

sumc :: [Int] -> Int
sumc xs = 0 
   where cube x = 0
         by7 x = 0 
         
siever :: Int -> [Int] -> [Int]
siever n xs = []

-- =================================================================
-- Comparisons
-- =================================================================
intCMP :: Int -> Int -> Ordering
intCMP a b | a == b = EQ 
           | a < b  = LT
           | otherwise = GT

strCMP :: String -> String -> Ordering
strCMP a b | a == b = EQ 
           | a < b  = LT
           | otherwise = GT

doubleCMPRev :: Double -> Double -> Ordering
doubleCMPRev a b | a == b    = EQ 
                 | a < b     = GT
                 | otherwise = LT

-- =================================================================
-- Operations on sets
-- =================================================================
isSet  :: Ord a => (a -> a-> Ordering) -> [a] -> Bool
isSet _ [] = True

-----------------------------------------------------------------
-- Return true if x occurs in xs using cmp as the comparison function
member :: Ord a => (a -> a-> Ordering) -> a -> [a] -> Bool
member cmp x xs = True

-----------------------------------------------------------------
-- Make a set from a list by removing duplicates and sorting
makeSet :: Ord a => (a -> a-> Ordering) -> [a] -> [a]
makeSet cmp xs = []

-----------------------------------------------------------------
-- Return the set intersection of two sets (previously constructed
-- by makeSet), using cmp as the element comparison function.
setIntersect  :: Ord a => (a -> a-> Ordering) -> [a] -> [a] -> [a]
setIntersect cmp xs ys = []

-----------------------------------------------------------------
-- Return the set union of two sets (previously constructed
-- by makeSet), using cmp as the element comparison function.
setUnion  :: Ord a => (a -> a-> Ordering) -> [a] -> [a] -> [a]
setUnion cmp xs ys = []

setSubtract  :: Ord a => (a -> a-> Ordering) -> [a] -> [a] -> [a]
setSubtract cmp xs ys = []

setIsSubset  :: Ord a => (a -> a-> Ordering) -> [a] -> [a] -> Bool
setIsSubset cmp xs ys = True

-----------------------------------------------------------------
-- Compute the similarity (a value between 0.0 and 1.0) between two
-- sets. If both sets are empty, return 0.0.
setSimilarity :: Ord a => (a -> a-> Ordering) -> [a] -> [a] -> Double
setSimilarity cmp [] [] = 0.0

data Nat = 
  Zero |
  Succ Nat
  deriving Show
  
toPeano :: Int -> Nat
toPeano x = Zero 

fromPeano :: Nat -> Int
fromPeano n = 0

addPeano :: Nat -> Nat -> Nat
addPeano a b = Zero

mulPeano :: Nat -> Nat -> Nat
mulPeano a b = Zero

peanoEQ :: Nat -> Nat -> Bool
peanoEQ a b = True

peanoLT :: Nat -> Nat -> Bool
peanoLT a b = True
