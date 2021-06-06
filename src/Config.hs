{-# LANGUAGE RecordWildCards #-}

module Config (Config(..), readConfig) where

import System.Environment (getEnv)

data Config = Config
  { harvestID :: String
  , harvestToken :: String
  }


readConfig :: IO Config
readConfig = do
  harvestID <- getEnv "HARVEST_ID"
  harvestToken <- getEnv "HARVEST_TOKEN"
  return Config{..}
