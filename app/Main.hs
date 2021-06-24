module Main where

import Config as C
import Harvest (TimeEntryInput(..), postTask)
import System.Environment (getArgs)
import System.Exit (die)


mkArgs :: [String] -> TimeEntryInput
mkArgs [pID, tID, desc] = TimeEntryInput (read pID) (read tID) desc
mkArgs _ = error "Wrong number of args"


main :: IO ()
main = do
  config <- C.readConfig
  args <- getArgs
  if length args < 3
  then die "Requires: ProjectID, TaskID, and description"
  else do
    tasks <- postTask (mkArgs args) (C.harvest config)
    print tasks
