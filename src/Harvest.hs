{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Harvest (listTasks) where

import Config (HarvestConfig(..))
import Network.HTTP.Client
import qualified Network.HTTP.Client.TLS as TLS
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Char8 as B


endpoint :: HarvestConfig -> Request
endpoint (HarvestConfig {..}) = "https://api.harvestapp.com/api/v2/users/me.json"
  { method = "GET"
  , secure = True
  , requestHeaders = [
      ("User-Agent", "API CLI"),
      ("Authorization", "Bearer " <> B.pack token),
      ("Harvest-Account-ID", (B.pack . show) id)
  ]
  }

listTasks :: HarvestConfig -> IO ByteString
listTasks config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (endpoint config) man
  return $ responseBody resp
