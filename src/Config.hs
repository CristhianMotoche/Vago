{-# LANGUAGE RecordWildCards #-}

module Config (Config(..), HarvestConfig(..), readConfig) where

import System.Environment (getEnv)


data Config = Config
  { harvest :: HarvestConfig
  }

data HarvestConfig = HarvestConfig
  { id :: String
  , token :: String
  }

readConfig :: IO Config
readConfig = do
  id <- getEnv "HARVEST_ID"
  token <- getEnv "HARVEST_TOKEN"
  harvest <- return HarvestConfig{..}
  return Config{..}
