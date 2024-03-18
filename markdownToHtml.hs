import Data.List 
import System.IO
import System.Directory



data Metadata = Metadata 
    { 
        title :: String,
        category :: String,
        date :: String,
        description :: String
    }

data code = "```" String "```"


markdownToHtml :: String -> String
markdownToHtml = 

splitDocument :: String -> (String, String)
splitDocument markdown = case break (=="---") (lines markdown) of
  (before, _:after) -> (unlines before, unlines $ drop 1 after)
  _                 -> ("", "")


main :: IO()
main = do
    withFile "articles/defcon31q.md" ReadMode (\handle -> do
        contents <- hGetContents handle   
        putStr contents)
    


