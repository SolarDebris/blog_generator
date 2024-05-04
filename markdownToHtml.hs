import Data.List.Split
import Data.List (intercalate)
import Data.Typeable (typeOf)
import Data.Text (unpack, pack)
import System.IO
import System.Directory (listDirectory)
import System.Environment
import Text.Pandoc
import Text.Pandoc.Options




test_document = unlines ["---\n", "title: DEFCON 31 Quals Challenges\n", "category: Writeup\n", "date: June 10th, 2023\n","description: A retroactive writeup on a few pwn and re challenges from DEFCON 31 Quals.\n","---\n","Starting stuff\n","## Open House\n", "### Understanding the Vulnerability\n", "### Getting Leaks\n","```\n", "int main(void)\n","```\n", "**Bold**", "_italic_", "> Testing\n", "> `Inline`\n", "1. Test1\n", "- Test\n", "- Test\n",      "#### Heap Leak\n","![alt_text](/src/assets/images/logo.jpg)\n", "#### PIE Leak\n","#### Libc Leak\n", "### Read/Write Primitive\n"]

-- Insert "Category - Title" into 4th element
-- Insert "Date " into 6th element
-- Insert Content into
template = ["<div className=\"flex justify-center p-10\">", "      <div className=\"pt-14 p-10 bg-dr-current_line/40 w-1/2 h-full rounded-lg\">", "       <h2 className=\"text-dr-orange font-bold text-4xl flex justify-center text-center\">","       </h2>", "       <h6 className=\"text-dr-purple py-1 flex justify-center\">By SolarDebris</h6>", "       <h6 className=\"text-dr-foreground py-1 pb-7 flex justify-center\">", "       </h6>","        <div>", "</div></div></div>"]

-- Function that will use the results of splitDocument to parse the metadata
-- and parse the document
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
parseContent content = case markdownToHtml content of
                         Left err -> "Error: " ++ err
                         Right html -> html

-- Function that takes a string and parses it into the Metadata class
parseMetadata :: String -> [String]
parseMetadata header = map getField (tail (lines header))

-- Function that returns Value from Key: Value
getField :: String -> String
getField line = concat $ (tail (splitOn ":" line))

--convertToHtml :: String -> String
createHtml :: ([String],String) -> String
createHtml (header, document) = unlines $
        take 3 template ++
        [getTitle ((header !! 1), (header !! 0))] ++
        take 3 (drop 3 template) ++
        [header !! 2] ++
        take 2 (drop 6 template) ++
        [document] ++
        drop 8 template

-- Function that returns "Category - Title"
getTitle :: ([Char],[Char]) -> String
getTitle (category, title) = category ++ " - " ++ title

-- Converts a string of markdown to html using pandoc library
markdownToHtml :: String -> Either String String
markdownToHtml markdownText =
    let pandocReaderOptions = def { readerExtensions = pandocExtensions }
        pandocWriterOptions = def { writerHtmlQTags = True }
        pandocResult = runPure $ do
            doc <- readMarkdown pandocReaderOptions (pack markdownText)
            writeHtml5String pandocWriterOptions doc
    in case pandocResult of
        Left err -> Left $ "Error converting Markdown to HTML: " ++ show err
        Right html -> Right (unpack html)

replaceExtension :: FilePath -> FilePath -> FilePath
replaceExtension outputDir md_file = outputDir ++ head (splitOn "." md_file) ++ ".html"

convertFile :: FilePath -> FilePath -> FilePath -> IO ()
convertFile inputDir outputDir sourceFile = do

    let source = inputDir ++ sourceFile

    let new_file = replaceExtension outputDir sourceFile

    handle <- openFile source ReadMode
    contents <- hGetContents handle

    putStrLn $ "Converting " ++ sourceFile ++ " to " ++ new_file
    let ( metadata, document ) = splitDocument contents

    let html_file = createHtml ( parseDocument (metadata, document) )

    writeFile new_file html_file
    hClose handle

main :: IO()
main = do

    args <- getArgs
    case args of
        [inputDir, outputDir] -> do
            files <- listDirectory inputDir
            mapM_ (\file -> convertFile inputDir outputDir file) files
        _ -> putStrLn "Please provide two arguments ./mdToHtml (inputDirectory) (outputDirectory)"
