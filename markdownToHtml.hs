import Data.List.Split 
import System.IO
import System.Directory



data Metadata = Metadata 
    { 
        title :: String,
        category :: String,
        date :: String,
        description :: String
    }

splitDocument :: String -> (String, String)
splitDocument markdown = 
    let splitted = split (onSublist "---") markdown
    in (splitted !! 2, splitted !! 4)

parseMetadata :: String -> Metadata
parseMetadata :: 




main :: IO()
main = do
    withFile "articles/defcon31q.md" ReadMode (\handle -> do
        markdown <- hGetContents handle   
        print (splitDocument markdown)
        )
    


