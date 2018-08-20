import Data.Char
import System.IO
-- Homework 6: Part B Template -- 

-- =================================================================
-- Utility functions
-- =================================================================

-----------------------------------------------------------------
-- The function call
--   windows size list
-- where
--   size = the size of the window
--   list = a list of elements of arbitrary type
-- will return a list of sublists of 'list',
-- constructed by sweeping a window of size 'size'
-- over list. 
-- For example, if 
--    list = [1,2,3,4,5]
--    size = 2
-- the we return
--    [[1,2],[2,3],[3,4],[4,5]
-- but if 
--    size = 3
-- we return
--    [[1,2,3],[2,3,4],[3,4,5]]
windows :: Int -> [a] -> [[a]]
windows n xs | n <= length xs = (take n xs) : windows n (tail xs)
             | otherwise      = []

-----------------------------------------------------------------
-- The function call
--    mapAllPairs f xs
-- where
--    f    = a binary function
--    xs   = a list of elements of arbitrary type
-- returns the result of applying f
--    to all pairs of elemtents drawn from xs.
-- Thus, this function, essentially, computes the
-- cross product of xs with itself, and applies 
-- f to all the resulting pairs of elements. 
mapAllPairs :: (a -> a -> b) -> [a] -> [b]
mapAllPairs f xs = [f x y | x <- xs, y <- xs] 


-- =================================================================
-- Hashes are represented as Ints.
-- =================================================================

type Hash = Int
type HashSet = [Hash]

hash :: String -> Hash
hash x = abs (h x)
    where h = foldr (\ x y -> ord x + 3 * y) 1 

hashShingle :: Shingle -> Hash
hashShingle (x,_) = hash x

-- =================================================================
-- A document is represented by its filename (a String).
-- When we've read in a document it is represented as a
-- list of the lines read, plus the line number.
-- =================================================================

-----------------------------------------------------------------
-- The name of a document is it's path, a String.
type DocName = FilePath

-----------------------------------------------------------------
-- A line of text, as read from a file, is represented by
-- a (row-number,line) tuple. The row-number starts at 0.
type Line = (Int,String)

-----------------------------------------------------------------
-- A document, as read from a file, is represented by
-- a list of (row-number,line) tuples.
type Document = [Line]

-- =================================================================
-- Functions for reading text files and splitting thei
-- into lists of lines.
-- =================================================================

-----------------------------------------------------------------
-- Given a string with embedded newlines, splitLines
-- will split it into a list of (row-number, line)
-- tuples.
splitLines :: String -> Document
splitLines s = zip [0..] $ lines s 

-- Given a list of filenames, loadFiles will read 
-- in the files and return them as a list of 
-- tuples (file-name,file-contents).
loadFiles :: [DocName] -> IO [(DocName,Document)]
loadFiles [] = return []
loadFiles (x:xs) = do 
                cont <- readFile x 
                let lines = splitLines cont
                tail <- loadFiles xs
                let files = (x,lines):tail
                return files

-- =================================================================
-- A Position is the location of a character in a file,
-- represented by the tuple (line-number, column-number).
type Position = (Int, Int)  


-- =================================================================
-- A shingle is a substring of the original document
-- plus the position at which it occurs. This section
-- contains functions for computing the shingles of
-- a document.
-- =================================================================

type Shingle = (String, Position)

-----------------------------------------------------------------
-- Extract all the singles from a line of text by 
-- sweeping a window of size shingleSize across it.
line2shingles :: Int -> Line -> [Shingle]
line2shingles shingleSize (lineNumber, text) = map
    (\(n, window) -> (window, (lineNumber, n)))
    $ zip [0..] (windows shingleSize text)


-----------------------------------------------------------------

-- by sweeping a window of size windowSize
-- over each of the lines of text.
shingles :: Int -> (DocName, Document) -> (DocName,[Shingle])
shingles windowSize (d, doc) = (d, shingled doc)
    where shingled doc = foldr (++) [] $ map (line2shingles windowSize) doc
-----------------------------------------------------------------
-- Given a list of shingles, convert it to a set of
-- hash values using the function "hash" above. There 
-- can be multiple shingles with the same string value, 
-- mapping to the same hash value, but the output of this 
-- function is a *set*, i.e. an ordered set of unique hashes.
shingles2hashSet :: (DocName, [Shingle]) -> (DocName,HashSet)
shingles2hashSet (doc,xs) = (doc, hashset)
        where hashset = makeSet $ map (\(x,_) -> hash x) xs

-- Create an ordered 'set' of unique elements in xs
-- This is a modifided version of a ubiquits implimentation
-- of QuickSort in Haskell.  
makeSet :: Ord a => [a] -> [a]
makeSet []         = []
makeSet (pivot:xs) =
    let leftSet  = makeSet [x | x <- xs, x < pivot]
        rightSet = makeSet [x | x <- xs, x > pivot]
        in leftSet ++ [pivot] ++ rightSet

-- =================================================================
-- This section contains algorithms for winnowing down sets of hashes 
-- to smaller sets. Usually, documents are large, and will result in 
-- way too many hashes being generated. "Winnowing" is any technique for
-- reducing the number of hashes. Here, we give several winnowing
-- functions. They all take a list of shingles as input and return a
-- (usually smaller) list of shingles. Later on, we can use
-- the most appropriate winnowing function depending on our
-- needs.
-- =================================================================
type WinnowFun = (DocName,[Shingle]) -> (DocName,[Shingle])

-----------------------------------------------------------------
-- The identity function, returning the same list of
-- shingles as it is given.
winnowNone :: (DocName,[Shingle]) -> (DocName,[Shingle])
winnowNone (d,xs) = (d,xs)

-----------------------------------------------------------------
-- Return only those shingles whose hash values is "0"
-- mod p.
winnowModP :: Int -> (DocName,[Shingle]) -> (DocName,[Shingle])
winnowModP p (d,xs) = (d, filter isMulP xs)
    where isMulP x = hashShingle x `mod` p == 0

-- multiples 
-----------------------------------------------------------------
-- Sweep a window of size p across the list of shingles.
-- For every window only keep the one with the minimum value.
-- If there are more than one 
winnowWindow :: Int -> (DocName,[Shingle]) -> (DocName,[Shingle])
winnowWindow p (d,xs) = (d, map minShingle (windows p xs))


-- Finds the rightmost minimum of set of shingles by hash value
minShingle ::  [Shingle] -> Shingle
minShingle [x] = x
minShingle xs  = foldr minOfTwo (last xs) (init xs)
    where minOfTwo a b | hashShingle a < hashShingle b = a
                       | otherwise                     = b

-- =================================================================
-- Main moss algorithm for computing the similarities between
-- n different documents.
-- =================================================================

-----------------------------------------------------------------
-- Given a list of documents (tuples of (docName, hash-set)),
-- compare all pairs of documents for similarity. This function 
-- returns a sorted list of tuples (DocName1,DocName2,SimilarityScore).
-- SimilarityScore is the value returned by the setSimilarity 
-- function over the hash-sets of each pair of documents. The 
-- resulting list is sorted, most similar documents first.
compareAllDocs :: [(DocName,HashSet)] -> [(DocName,DocName,Double)]
compareAllDocs xs = mySortBy (\(_,_,c) -> c)  
    [(n1, n2, setSimilarity hs1 hs2) | (n1, hs1) <- xs, (n2, hs2) <- xs]

-- Sorts a list of elements according to there valuation by a function 'f'.
mySortBy :: (a -> Double) -> [a] -> [a]
mySortBy _ []         = []
mySortBy f (pivot:xs) =
    let leftSort  = mySortBy f [x | x <- xs, f x >= f pivot]
        rightSort = mySortBy f [x | x <- xs, f x < f pivot]
        in leftSort ++ [pivot] ++ rightSort

setSimilarity :: [Int] -> [Int] -> Double
setSimilarity xs ys = len (intersection xs ys) / len (union xs ys)
    where intersection xs ys = [x | x <- xs, x `elem` ys]
          union xs ys       = makeSet (xs ++ ys)

len :: [a] -> Double
len = (fromIntegral . length)
-----------------------------------------------------------------
    --
-- The function call
--    kgram windowSize winnow (name,doc)
-- where
--   windowSize = the size of the window which we will sweep
--                across the document.
--   winnow     = the function which winnows down lists of
--                shingles to a manageable size
--   (name,doc) = the name and the contents of the file we
--                want to process.
-- performs the following steps:
--   1) compute the list of shingles of size windowSize
--   2) winnow down the list of shingles to a manageable size
--   3) convert the list of shingles to a set of hashes.
kgram :: Int -> WinnowFun -> (DocName,Document) -> (DocName,HashSet)
kgram windowSize winnowFun = shingles2hashSet . winnowFun . shingles windowSize

-----------------------------------------------------------------
-- The function call
--   moss windowSize winnowFunction listOfDocuments
-- where
--    windowSize      = the size of the windows we sweek across the document
--    winnowFun       = the function that winnows down the large 
--                      list of shingles to a more manageable list
--    listOfDocuments = a list of pairs (document-name, document-contents)
--                      that we want to compare
-- performs the following steps:
--    1) use 'kgram' to compute a set of hashes for each document
--    2) use 'compareAllDocs' to compute, for every pair of documents,
--       how similar they are.
-- This function uses the compareAllDocs function above
-- to compute a list of all pairs of documents and a
-- measure of how similar they are.
moss :: Int -> WinnowFun ->[(DocName,Document)] -> [(DocName,DocName,Double)]
moss windowSize winnowFun = compareAllDocs . (map (kgram windowSize winnowFun))

-----------------------------------------------------------------
-- The function call
--    similar shingleSize winnowAlg fileNames
-- performs the actions
--    1) read in all the files in fileNames (a list of strings),
--    2) compute the simiarity of each pair of documents.
-- This function uses compareAllDocs above to do the actual
-- comparisons.
similar :: Int -> WinnowFun -> [DocName] -> IO [(DocName, DocName, Double)]
similar shingleSize winnowAlg fileNames = do
      docs <- loadFiles fileNames
      let w = moss shingleSize winnowAlg docs
      return w

-----------------------------------------------------------------
-- Below are four functions which are all specializations
-- of the "similar" function.
--    1) sim_none does no winnowing.
--    2) sim_modP uses the mod P winnowing algorithm.
--    3) sim_window uses the window-based winnowing algorithm
--    4) sim is like sim_modP but with a default shingle size
--       set to 3 and with winnowing set to mod 4.
sim_none :: Int -> [DocName] ->  IO [(DocName, DocName, Double)]
sim_none shingleSize = similar shingleSize winnowNone 

sim_modP :: Int -> Int -> [DocName] -> IO [(DocName, DocName, Double)]
sim_modP shingleSize modP = similar shingleSize (winnowModP modP) 

sim_window :: Int -> Int -> [DocName] -> IO [(DocName, DocName, Double)]
sim_window shingleSize windowSize = similar shingleSize (winnowWindow windowSize) 

sim :: [DocName] -> IO [(DocName, DocName, Double)]
sim files = sim_modP 3 4 files 
-- =================================================================
-- PART C FUNCTIONS 
-- =================================================================

-----------------------------------------------------------------
-- This is the main function for visualizing the
-- similarities between two documents.
-- The functio  call
--   visualize doc1name doc2name
-- where 
--    doc1name = the name of the first document
--    doc2name = the name of the second document
-- this function will
--    1) read in the files,
--    2) compute their similarities (by comparing the set of shingles),
--    3) compute an html string visualizing the similarities,
--    4) write the html string to the file named
--           doc1name-doc2name.html.
visualize :: Int -> DocName -> DocName -> IO()
visualize shingleSize doc1name doc2name = do
          let outfileName = doc1name ++ "-" ++ doc2name ++ ".html"
          [doc1,doc2] <- loadFiles [doc1name,doc2name] 
          let shingles1 = shingles shingleSize doc1
          let shingles2 = shingles shingleSize doc2
          let common = commonStrings shingles1 shingles2
          let regions1 = shingles2regions shingles1 common
          let regions2 = shingles2regions shingles2 common
	  let html = showSimilarities doc1 regions1 doc2 regions2
          writeFile outfileName html

-----------------------------------------------------------------
-- The viz function is a specializion of "visualize" with
-- the shingle size set to 3.
viz :: DocName -> DocName -> IO()
viz = visualize 3

-----------------------------------------------------------------
-- A Region is a tuple (pos,len) that represents 
-- a segment of a file starting in position pos
-- (a (row,column) tuple) and extending for len
-- characters. For simplicity, a Region never
-- extends past the end of a line.
type Region = (Position,Int)

-----------------------------------------------------------------

-- The function call
--   inRegion pos region
-- returns True if pos is within region.
-- Regions don't span lines.
inRegion :: Position -> Region -> Bool
inRegion (row,col) ((r,c),len) = row==r && col>=c && col<(c+len)

-- The function call
--   inRegions pos listOfRegions
-- returns True if pos is within any of the
-- regions in listOfRegions. 
inRegions :: Position -> [Region] -> Bool
inRegions pos regions = or $ map (inRegion pos) regions

-----------------------------------------------------------------
-- The function call
--   commonStrings (doc1name,shingles1) (doc2name,shingles2)
-- where
--   doc1name  = name of the first document
--   shingles1 = the list of shingles of the first document
--   doc2name  = name of the second document
--   shingles2 = the list of shingles of the second document
-- returns
--   the *set* of the shingle strings that occur in both documents
--   (i.e. compute the *intersection* of the shingle strings in the
--   two documents).
commonStrings :: (DocName,[Shingle]) -> (DocName,[Shingle]) -> [String]
commonStrings (_, sh1) (_, sh2) = intersection (strings sh1) (strings sh2)
	where strings = (fst . unzip)

-- Returns all unique elements of xs that are also elements of ys
intersection :: Ord a => [a] -> [a] -> [a]
intersection xs ys = makeSet [x | x <- xs, x `elem` ys]
-----------------------------------------------------------------
-- The function call 
--   shingles2regions (doc,shingles) common
-- where
--   doc      = the name of a document
--   shingles = the list of the shingles of the document
--   common   = a list of strings that occur in this document
--              (and which, eventually, we will want to highlight
--              because they also occur in the document we're
--              comparing too)
-- returns 
--   a list of regions where the strings in common 
--   occur in shingles.
shingles2regions :: (DocName,[Shingle]) -> [String] -> [Region]
shingles2regions (doc, shings) common = map shingleReg $ filter inCommon shings
	where inCommon (s, _) = s `elem` common
	      shingleReg (s, pos) = (pos, length s)

-----------------------------------------------------------------
-- The function call
--   showSimilarities (doc1name,doc1) reg1 (doc2name,doc2) reg2
-- where
--    doc1name    = name of the first document
--    doc1        = the text of document 1 as a list of lines
--    reg1        = a list of regions of document 1 that should 
--                  be highlighted
--    doc2name    = name of the second document
--    doc2        = the text of document 2 as a list of lines
--    reg2        = a list of regions of document 2 that should 
--                  be highlighted
-- will perform the actions
--    1) compute a version of doc1 where regions in reg1 
--       have been highlighted
--    2) compute a version of doc2 where regions in reg2 
--       have been highlighted
--    3) construct html code that displays the hightlighted 
--       documents side by side
showSimilarities :: (DocName,Document) -> [Region] -> (DocName,Document) -> [Region] -> String
showSimilarities (doc1name,doc1) reg1 (doc2name,doc2) reg2 = html
  where
     ann1 = highlight' doc1 reg1
     ann2 = highlight' doc2 reg2
     html = htmlTemplate (doc1name,ann1) (doc2name,ann2)

-----------------------------------------------------------------
-- The function call
--   highlight doc regions 
-- where 
--   doc     = a text document represented as (row,line) pairs
--   regions = a list of ((row,column),length) tuples, 
--             representing the regions of the document that
--             should be highlighted
-- will return a string where each character c whose position
-- lies within any of the regions has been highlighted (i.e.
-- replaced by the output of the
--       highlightChar c
-- function call).
--
-- NOTE TO GRADER: This is the unoptimized version of the function for the
-- extra credit see highlight' below.
highlight :: Document -> [Region] -> [String]
highlight doc regs = map (line2HTML regs) doc

-- Returns the html representation of a line of highlighted in the inside the
-- regions given
line2HTML :: [Region] -> Line -> String
line2HTML regs l = concatMap (char2HTML regs) $ line2Pos l

-- Takes in a list of regions and a character position pair, returns the 
-- html for that character highlighted if it's position lies in any of the 
-- regions. Returns a string containing only that character if it
-- does not.
char2HTML :: [Region] -> (Position, Char) -> String
char2HTML regs (pos, c)	 | pos `inRegions` regs = highlightChar c
		      	 | otherwise 		= [c]


-- Converts a line to a list of positions and characters
line2Pos :: Line -> [(Position, Char)]
line2Pos (row, s) = [((row, col), c)| (col, c) <- (enum s)]
	where enum = zip [0 :: Int ..] -- Python style enumerate, with Ints
----------------------------------------------------------------
-- This function wraps a string in html that
-- gives it a yellow background color.
highlightChar :: Char -> String
highlightChar x = "<FONT style=\"BACKGROUND-COLOR: yellow\">" ++ [x] ++ "</FONT>"
-----------------------------------------------------------------
-- EXTRA CREDIT
-----------------------------------------------------------------
-- This is the optimized version of highlight. I decided to write the 
-- unoptimized function without recursion from the ground up as 
-- recursive functions are slower and can have huge amounts of stack
-- overhead.
-- I made the following two additional changes in this version:
-- 1. This algorithm no longer checks ranges on different lines
-- when deciding if a character should be highlighted.
-- 2. We no longer, enclose every character that needs to be highlighted
-- in its own set of highlight tags instead surround every group of 
-- consecutive highlighted characters with one set of tags e.g.
-- Instead of "<highlight>A<\highlight><highlight>B<\highlight>C"
-- would do <highlight>AB<\highlight>C.

highlight' :: Document -> [Region] -> [String]
highlight' doc regs = [line2HTML' line (regionsOn line) | line <- doc]
			where regionsOn line = filter (isOn line) regs

-- Returns true iff the Line contains the region
isOn ::  Line -> Region -> Bool
isOn (b,_) ((a,_),_) = a == b

line2HTML' :: Line -> [Region] ->  String
line2HTML' l regs = addTags regs $ line2Pos' l

-- Adds the tags to a line in chunks as described above
addTags :: [Region] -> [(Position, Char)] -> String
addTags regs []      = "" 
addTags regs [(c,_)] = if inRegions c regs then closingTag else ""
addTags regs (x:y:xs)| outRegs x && inRegs y = snd x : openingTag ++ addTags regs (y:xs)
		     | inRegs x && outRegs y = snd x : closingTag ++ addTags regs (y:xs) 
		     | otherwise 	     = snd x : addTags regs (y:xs)
		       where inRegs (c,_) = inRegions c regs
		       	     outRegs (c,_)= not $ inRegions c regs

openingTag = "<FONT style=\"BACKGROUND-COLOR: yellow\">"
closingTag = "</FONT>"

line2Pos' :: Line -> [(Position, Char)]
line2Pos' (row, s) = [((row, col), c)| (col, c) <- (enum s)]
	where enum = zip [0 :: Int ..] -- Python style enumerate, with Ints

-----------------------------------------------------------------
-- The function call
--   htmlTemplate (doc1name lines1) (doc2name lines2)
-- returns a string containing html that
-- displays lines1 and lines2 side by side.
htmlTemplate :: (DocName,[String]) -> (DocName,[String]) -> String
htmlTemplate (doc1name,lines1) (doc2name,lines2)= "\
   \<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n\
   \<html>\n\
   \  <head>\n\
   \    <title>" 
   ++ 
   title 
   ++ 
   "</title>\n\
   \  </head>\n\
   \\n\
   \  <body>\n\
   \<center>\n\
   \    <h1>"
   ++
   title
   ++
   "</h1>\n\
   \   <table border=1>\n\
   \      <tr>\n\
   \         <th>" ++ doc1name ++ "</th>\n\
   \         <th>" ++ doc2name ++ "</th>\n\
   \      </tr>\n\
   \      <tr>\n\
   \         <td>\n\
   \<pre>\n"
   ++
   unlines lines1 
   ++
   "\n</pre>\n\
   \         </td>\n\
   \         <td>\n\
   \<pre>\n"
   ++
   unlines lines2
   ++
   "\n</pre>\n\
   \         </td>\n\
   \     </tr>\n\
   \   </table>\n\
   \</center>\n\
   \  </body>\n\
   \</html>\n"
   where
      title = doc1name ++ " vs. " ++ doc2name

-- =================================================================
-- Useful for debugging
-- =================================================================

fred0 = shingles 3 ("fred",[(0,"yabbadabbadoo")])
fred0a = shingles 3 ("fred",[(0,"bbadooyabbada")])
frank0 = shingles 3 ("frank",[(0,"doobeedoobeedoo")])
scooby0 = shingles 3 ("scooby",[(0,"scoobydoobydoo")])

fred1 = kgram 3 winnowNone ("fred",[(0,"yabbadabbadoo")])
fred1a = kgram 3 winnowNone ("fred",[(0,"bbadooyabbada")])
frank1 = kgram 3 winnowNone ("frank",[(0,"doobeedoobeedoo")])
scooby1 = kgram 3 winnowNone ("scooby",[(0,"scoobydoobydoo")])

fred2 = kgram 3 (winnowModP 4) ("fred",[(0,"yabbadabbadoo")])
fred2a = kgram 3 (winnowModP 4) ("fred",[(0,"bbadooyabbada")])
frank2 = kgram 3 (winnowModP 4) ("frank",[(0,"doobeedoobeedoo")])
scooby2 = kgram 3 (winnowModP 4) ("scooby",[(0,"scoobydoobydoo")])

sim1 = sim ["Fib1.java","Fibonacci3.java","Fibonacci4.java"]
sim2 = sim ["fred"]
sim3 = sim_none 3 ["fred","frank"] 
sim4 = sim_none 3 ["fred","frank","scooby"]
sim5 = sim []

viz1 = viz "landskrona1" "landskrona3"
viz2 = viz "fred" "frank"
