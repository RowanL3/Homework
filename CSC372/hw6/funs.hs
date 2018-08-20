-- Rowan Lochrin
-- Generic Helper Functions
intCMP :: Int -> Int -> Ordering
intCMP a b      | a == b = EQ
                | a < b = LT
                | otherwise = GT


-- 2. A: Individual problems
-- Returns the maximum of 'x:xs'.
max' :: (Ord a) => [a] -> a
max' []     = error "empty list"
max' (x:xs) = foldr max x xs

--  Multiples ever element of 'xs' by x.
mul' :: (Num a) => [a] -> a -> [a]
mul' xs x   = map (* x) xs

-- Returns the sum of the squares of the elements of 'xs' divisible by 7.
sumc :: [Int] -> Int
sumc xs = (sum . (map cube) . (filter by7)) xs
	where cube x = x*x
	      by7 x = x `mod` 7 == 0

-- Returns the elements of 'xs' relatively prime to n.
siever :: Int -> ([Int]) -> [Int]
siever n xs = [x | x <- xs, x `mod` n /= 0] 


nthP :: Int -> Int
nthPrime = let s' 1 = [1..n]
	       s' x = let p_x = nthPrime !! x
		in [x | x <- s' (x - 1), x `mod` p_x ]
	in map s' [1..] !!

primesUpTo 2 = [2]
primesUpTo n = let sqrtN = celi n
	  	in primesUpTo sqrtN

celi n = 1 + floor $ sqrt n
-- Highlights, catagory: haskell, date: 10/27/17 
-- Returns: an ordered set of unique elements in 'xs', ordered by the function 'cmp'.
-- Conditions: Does not presort elements. 

-- Does not presort elements of xs, instead it works something like a QuickSort 
-- that excludes the pivot from BOTH the top half and the bottom halve. Since 
-- every element is eventually a pivot this ensures every element will be unique.
makeSet :: Ord a => (a -> a -> Ordering) -> [a] -> [a]
makeSet cmp []         = []
makeSet cmp (pivot:xs) = 
	let leftSet  = makeSet cmp [x | x <- xs, x  `cmp` pivot == LT]
	    rightSet = makeSet cmp [x | x <- xs, x  `cmp` pivot == GT]
        in leftSet ++ [p] ++ rightSet
-- /Highlight

median :: Ord a => [a] -> a
median (x:xs) =
-- Returns True iff xs is a set
isSet :: Ord a => (a -> a -> Ordering) -> [a] -> Bool
isSet cmp xs = head $ map (== (makeSet cmp xs)) [xs]

-- Returns True iff x is a member of xs 
member :: Ord a => (a -> a -> Ordering) -> a -> [a] -> Bool
member cmp x xs = or $ map (\y -> y `cmp` x == EQ) xs

-- Returns the elements of xs that are also in ys
setIntersect :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
setIntersect cmp xs ys = filter (\x -> member cmp x ys) xs

-- Returns the union of two sets constructed by makeset
setUnion :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
setUnion cmp xs ys = head $ map (makeSet cmp) [xs ++ ys] 

-- Returns all elements of xs not in ys
setSubtract :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> [a]
setSubtract cmp xs ys = filter (\x -> not (member cmp x ys)) xs

-- Returns the similarity of the two sets if both sets are empty returns 0.0
setSimilarity :: Ord a => (a -> a -> Ordering) -> [a] -> [a] -> Double
setSimilarity cmp xs ys = fromIntegral (length (setIntersect cmp xs ys)) / fromIntegral (length (setUnion cmp xs ys))

row :: Int -> Int -> [Int]
row n v = [if x == v then 1 else 0| x <- [0..n]]

idmatrix :: Int -> [[Int]]
idmatrix n = [row n x| x <- [0..n]]

data Nat = 
	Zero | 
	Succ Nat
	deriving Show 

-- Converts integers to there literal Peano axiom forms
toPeano :: Int -> Nat
toPeano 0 = Zero
toPeano x = Succ $ toPeano (x - 1)

-- Converts Piano axiom integers into there Hindu–Arabic numeral system representations
fromPeano :: Nat -> Int
fromPeano Zero     = 0 
fromPeano (Succ n) = 1 + fromPeano n

-- Adds two peano integers
addPeano :: Nat -> Nat -> Nat
addPeano Zero b     = b
addPeano (Succ a) b = addPeano a (Succ b)

-- Multiples two piano integers
mulPeano :: Nat -> Nat -> Nat
mulPeano a b = nTimes a (addPeano b) Zero

-- Applies the function f to x n times where n is a peano axiom integer
nTimes :: Nat -> (t -> t) -> t -> t
nTimes Zero     f x = x
nTimes (Succ n) f x = nTimes n f (f x)

-- Returns true iff a equals b for two piano axiom numbers
peanoEQ :: Nat -> Nat -> Bool
peanoEQ Zero 	 Zero 	  = True
peanoEQ (Succ a) (Succ b) = peanoEQ a b
peanoEQ _        _	  = False

-- Returns true iff a is less then b for two piano axiom numbers
peanoLT :: Nat -> Nat -> Bool
peanoLT a    Zero 	  = False
peanoLT Zero b    	  = True
peanoLT (Succ a) (Succ b) = peanoLT a b
