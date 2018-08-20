-- Rowan Lochrin
-- 
--
--
--
begin :: [Int] -> [Int] -> Bool
begin (x:xs) (y:ys) = if x == y then begin xs ys else False
begin []     _      = True
begin _      []     = False

subsequence :: [Int] -> [Int] -> Bool
subsequence _ []  = False
subsequence xs ys = begin xs ys || subsequence xs (tail ys) 

mystery :: [a] -> [[a]]
mystery [] = [[]]
mystery (x:xs) = sets ++ (map (x:) sets)
		 where sets = mystery xs

stripEmpty = filter (/= "")

f xs ys = foldr (++) [] $ map (\(x,y) -> [x,y]) (zip xs ys)

adjpairs = zip xs $ tail xs
invert = map inv
inv False = True
inv True = False
