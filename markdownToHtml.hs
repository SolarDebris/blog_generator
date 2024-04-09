import Data.List.Split 
import System.IO
import System.Directory


-- A custom data structure for
-- storing the metadata
data Metadata = Metadata 
    { 
        title :: String,
        category :: String,
        date :: String,
        description :: String
    }

-- Function that will split document by the string "---"
-- and takes the header and document
splitDocument :: String -> (String, String)
splitDocument markdown = 
    let splitted = split (onSublist "---") markdown
    in (splitted !! 2, splitted !! 4)


-- Function that will use the results of splitDocument to parse the metadata
-- and parse the document
-- (NOTE this function may be useless)
parseDocument :: (String, String) -> [String]
parseDocument (header, document) = parseMetadata header

-- Function that takes a string and parses it into the Metadata class
parseMetadata :: String -> [String]
parseMetadata header = tail (lines header)

let test_document = unlines ["---", "title: DEFCON 31 Quals Challenges", "category: Writeup", "date: June 10th, 2023","description: A retroactive writeup on a few pwn and re challenges from DEFCON 31 Quals.","---","Starting stuff"]

main :: IO()
main = do
    withFile "articles/defcon31q.md" ReadMode (\handle -> do
        markdown <- hGetContents handle   
        print (parseDocument(splitDocument markdown))
        )
    
