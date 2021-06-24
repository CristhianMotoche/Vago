{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Harvest (TimeEntryInput(..), postTask) where

import Config (HarvestConfig(..))
import Data.Aeson as A
import Network.HTTP.Client
import qualified Network.HTTP.Client.TLS as TLS
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Char8 as B

data TimeEntryInput = TimeEntryInput
  { projectId :: Int
  , taskId :: Int
  , spendDate :: String
  } deriving (Show)

instance A.ToJSON TimeEntryInput where
  toJSON TimeEntryInput{..} =
    A.object
    [ "project_id" A..= projectId
    , "task_id" A..= taskId
    , "spent_date" A..= ("2021-06-23" :: String)
    ]

apiDomain :: Request
apiDomain =  "https://api.harvestapp.com"

endpoint :: TimeEntryInput -> HarvestConfig -> Request
endpoint timeEntry (HarvestConfig {..}) = apiDomain
  { method = "POST"
  , secure = True
  , requestHeaders = [
      ("User-Agent", "Vago API CLI"),
      ("Content-Type", "application/json"),
      ("Authorization", "Bearer " <> B.pack token),
      ("Harvest-Account-ID", (B.pack . show) id)
    ]
  , path = "/api/v2/time_entries"
  , requestBody = RequestBodyLBS $ encode timeEntry
  }

postTask :: TimeEntryInput -> HarvestConfig -> IO ByteString
postTask entry config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (endpoint entry config) man
  return $ responseBody resp
