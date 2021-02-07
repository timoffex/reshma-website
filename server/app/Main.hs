{-# LANGUAGE OverloadedStrings #-}


import qualified Data.ByteString.Char8    as BS
import qualified Data.ByteString.Lazy     as LBS
import qualified Data.Text                as T
import           Network.HTTP.Types
import           Network.Mime
    ( MimeType, defaultMimeLookup )
import           Network.Wai
import           Network.Wai.Handler.Warp
    ( run )


main :: IO ()
main = run 8080 app

app :: Application
app request respond = respond $ case pathInfo request of
  "assets":_       -> guessMime $ tail $ BS.unpack $ rawPathInfo request
  "fonts":_        -> guessMime $ tail $ BS.unpack $ rawPathInfo request
  ["main.dart.js"] -> javascript "main.dart.js"
  ["styles.css"]   -> css "styles.css"
  _                -> index


index :: Response
index = responseFile
  status200
  [("Content-Type", "text/html")]
  "index.html"
  Nothing


javascript :: FilePath -> Response
javascript = fileResponse "text/javascript"

css :: FilePath -> Response
css = fileResponse "text/css"

echoPath :: BS.ByteString -> Response
echoPath path = responseLBS status200 [] (LBS.fromStrict path)

guessMime :: FilePath -> Response
guessMime fp = fileResponse (defaultMimeLookup (T.pack fp)) fp

fileResponse :: MimeType -> FilePath -> Response
fileResponse mime path =
  responseFile
    status200
    [("Content-Type", mime)]
    path
    Nothing
