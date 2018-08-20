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
windows k = windows k  -- Just to pass the typechecker!!

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
mapAllPairs f xs = []


-- =================================================================
-- Hashes are represented as Ints.
-- =================================================================

type Hash = Int
type HashSet = [Hash]

hash :: String -> Hash
hash x = 0

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
-- Functions for reading text files and splitting them
-- into lists of lines.
-- =================================================================

-----------------------------------------------------------------
-- Given a string with embedded newlines, splitLines
-- will split it into a list of (row-number, line)
-- tuples.
splitLines :: String -> Document
splitLines "" = []

-----------------------------------------------------------------
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
-- ================================================================
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
line2shingles shingleSize (lineNumber,text) = []

-----------------------------------------------------------------
-- Extract all the shingles from a document
-- by sweeping a window of size windowSize
-- over each of the lines of text.
shingles :: Int -> (DocName,Document) -> (DocName,[Shingle])
shingles shingleSize (doc, xs) = ("", [])

-----------------------------------------------------------------
-- Given a list of shingles, convert it to a set of
-- hash values using the function "hash" above. There 
-- can be multiple shingles with the same string value, 
-- mapping to the same hash value, but the output of this 
-- function is a *set*, i.e. an ordered set of unique hashes.
shingles2hashSet :: (DocName,[Shingle]) -> (DocName,HashSet)
shingles2hashSet (doc,xs) = ("",[])

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
winnowModP p (d,xs) = (d,xs)

-----------------------------------------------------------------
-- Sweep a window of size p across the list of shingles.
-- For every window only keep the one with the minimum value.
-- If there are more than one 
winnowWindow :: Int -> (DocName,[Shingle]) -> (DocName,[Shingle])
winnowWindow p (d,xs) = (d,xs)

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
compareAllDocs xs = []

-----------------------------------------------------------------
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
kgram windowSize winnow = kgram windowSize winnow  -- Just to pass the typechecker!!

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
moss windowSize winnowFun = moss windowSize winnowFun -- Just to pass the typechecker!!

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

