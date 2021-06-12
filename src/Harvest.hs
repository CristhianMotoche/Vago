{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Harvest (listTasks) where

import Config (HarvestConfig(..))
import Network.HTTP.Client
import qualified Network.HTTP.Client.TLS as TLS
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Char8 as B


endpoint :: HarvestConfig -> Request
endpoint (HarvestConfig {..}) = "https://api.harvestapp.com/api/v2"
  { method = "GET"
  , secure = True
  , requestHeaders = [
      ("Content-type", "application/json; charset=utf-8"),
      ("Authorization", "Bearer " <> B.pack token)
  ]
  }

listTasks :: HarvestConfig -> IO ByteString
listTasks config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (endpoint config) man
  return $ responseBody resp
