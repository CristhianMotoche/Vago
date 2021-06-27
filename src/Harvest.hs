{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Harvest (TimeEntryInput(..), postTask, getTask) where

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
  , description :: String
  } deriving (Show)

testingDate :: String
testingDate = "2021-06-25"

instance A.ToJSON TimeEntryInput where
  toJSON TimeEntryInput{..} =
    A.object
    [ "project_id" A..= projectId
    , "task_id" A..= taskId
    , "spent_date" A..= testingDate
    , "notes" A..= description
    ]

apiDomain :: Request
apiDomain =  "https://api.harvestapp.com"

postTimeEntries :: TimeEntryInput -> HarvestConfig -> Request
postTimeEntries timeEntry (HarvestConfig {..}) = apiDomain
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


getTimeEntries :: HarvestConfig -> Request
getTimeEntries (HarvestConfig {..}) = apiDomain
  { method = "GET"
  , secure = True
  , requestHeaders = [
      ("User-Agent", "Vago API CLI"),
      ("Content-Type", "application/json"),
      ("Authorization", "Bearer " <> B.pack token),
      ("Harvest-Account-ID", (B.pack . show) id)
    ]
  , path = "/api/v2/time_entries"
  , queryString = B.pack $ "from=" <> testingDate
  }


postTask :: TimeEntryInput -> HarvestConfig -> IO ByteString
postTask entry config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (postTimeEntries entry config) man
  return $ responseBody resp

getTask :: HarvestConfig -> IO ByteString
getTask config = do
  man <- TLS.newTlsManager
  resp <- httpLbs (getTimeEntries config) man
  return $ responseBody resp
