{-# LANGUAGE RecordWildCards #-}

module Config (Config(..), HarvestConfig(..), readConfig) where

import System.Environment (getEnv)


data Config = Config
  { harvest :: HarvestConfig
  } deriving Show

data HarvestConfig = HarvestConfig
  { id :: Int
  , token :: String
  } deriving Show

readConfig :: IO Config
readConfig = do
  id <- read <$> getEnv "HARVEST_ID"
  token <- getEnv "HARVEST_TOKEN"
  harvest <- return HarvestConfig{..}
  return Config{..}
