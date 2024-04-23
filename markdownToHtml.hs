import Data.List.Split 
import System.IO

test_document = unlines ["---", "title: DEFCON 31 Quals Challenges", "category: Writeup", "date: June 10th, 2023","description: A retroactive writeup on a few pwn and re challenges from DEFCON 31 Quals.","---","Starting stuff"]

-- Insert "Category - Title" into 4th element
-- Insert "Date " into 6th element
-- Insert Content into
template = ["<div className=\"flex justify-center p-10\">", "      <div className=\"pt-14 p-10 bg-dr-current_line/40 w-1/2 h-full rounded-lg\">", "       <h2 className=\"text-dr-orange font-bold text-4xl flex justify-center text-center\">","       </h2>", "       <h6 className=\"text-dr-purple py-1 flex justify-center\">By SolarDebris</h6>", "       <h6 className=\"text-dr-foreground py-1 pb-7 flex justify-center\">", "       </h6>","        <div>", "</div></div></div>"]

-- A custom data structure for
-- storing the metadata
data Metadata = Metadata
    {
        title :: String,
        category :: String,
        date :: String,
        description :: String
    }

-- Function that will use the results of splitDocument to parse the metadata
-- and parse the document
-- (NOTE this function may be useless)
parseDocument :: (String, String) -> ( [String], String )
parseDocument (header, document) = (parseMetadata header, parseContent document)

-- Function that will split document by the string "---"
-- and takes the header and document
splitDocument :: String -> (String, String)
splitDocument markdown =
    let splitted = split (onSublist "---") markdown
    in (splitted !! 2, splitted !! 4)

-- Functiont that takes markdown and converts to HTML
parseContent :: String -> String
parseContent content = content

-- Function that takes a string and parses it into the Metadata class
parseMetadata :: String -> [String]
parseMetadata header = map getField (tail (lines header))

-- Function that returns Value from Key: Value
getField :: String -> String
getField line = concat $ (tail (splitOn ":" line))

--convertToHtml :: String -> String
createHtml :: ([String],String) -> String
createHtml (header, document) =
  let html = take 3 template ++
        [getTitle (header !! 1) (header !! 0)] ++
        take 3 (drop 3 template) ++
        [getField (header !! 2)] ++
        take 2 (drop 6 template) ++
        [document] ++
        drop 8 template
  in html

-- Function that returns "Category - Title"
getTitle :: [Char] -> [Char] -> String
getTitle category title = category ++ " - " ++ title

main :: IO()
main = do
  print ( createHtml ( parseDocument (splitDocument test_document)))
    -- withFile "articles/defcon31q.md" ReadMode (\handle -> do
        --markdown <- hGetContents handle   
        --print (parseDocument(splitDocument markdown))
        --)
