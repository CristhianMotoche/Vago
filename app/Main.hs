module Main where

import Config as C
import Harvest (postTask)
import System.Environment (getArgs)
import System.Exit (die)


data Args = Args
  { projectID :: Int
  , taskID :: Int
  , description :: String
  } deriving Show

mkArgs :: [String] -> Args
mkArgs [pID, tID, desc] = Args (read pID) (read tID) desc
mkArgs _ = error "Wrong number of args"


main :: IO ()
main = do
  config <- C.readConfig
  args <- getArgs
  if length args < 3
  then die "Requires: ProjectID, TaskID, and description"
  else do
    print $ mkArgs args
    tasks <- postTask $ C.harvest config
    print tasks
