{-# LANGUAGE RecordWildCards #-}

module Harvest (listTasks) where

import Config (Config(..))
import qualified Config as C
import Network.HTTP.Client
import qualified Network.HTTP.Client.TLS as TLS
import qualified Data.ByteString.Char8   as


apiPath :: String
apiPath = "https://api.harvestapp.com/api/v2"

endpoint :: Config -> Status -> Request
endpoint (Config {..}) status = apiPath
  { method = "GET"
  , secure = True
  , requestHeaders = [
      ("Content-type", "application/json; charset=utf-8"),
      ("Authorization", "Bearer " <> B.pack harvestToken)
  ]
  }

listTasks :: Config -> IO (Maybe StatusResponse)
listTasks config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (endpoint config status) man
  return $ responseBody resp
