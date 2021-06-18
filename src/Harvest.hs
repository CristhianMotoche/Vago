{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Harvest (listTasks) where

import Config (HarvestConfig(..))
import Network.HTTP.Client
import qualified Network.HTTP.Client.TLS as TLS
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Char8 as B


apiDomain :: Request
apiDomain =  "https://api.harvestapp.com"

endpoint :: HarvestConfig -> Request
endpoint (HarvestConfig {..}) = apiDomain
  { method = "GET"
  , secure = True
  , requestHeaders = [
      ("User-Agent", "Vago API CLI"),
      ("Authorization", "Bearer " <> B.pack token),
      ("Harvest-Account-ID", (B.pack . show) id)
    ]
  , path = "/api/v2/users/1065791/project_assignments"
  }

listTasks :: HarvestConfig -> IO ByteString
listTasks config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (endpoint config) man
  return $ responseBody resp
