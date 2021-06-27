module Main where

import Config as C
import Harvest (TimeEntryInput(..), postTask, getTask)
import System.Environment (getArgs)
import System.Exit (die)


mkArgs :: [String] -> TimeEntryInput
mkArgs [pID, tID, desc] = TimeEntryInput (read pID) (read tID) desc desc
mkArgs _ = error "Wrong number of args"


main :: IO ()
main = do
  config <- C.readConfig
  args <- getArgs
  case args of
    ("R": []) -> getTask (C.harvest config) >>= print
    ( "C": pID: tID: desc: _) -> postTask (mkArgs [pID, tID, desc]) (C.harvest config) >>= print
    _  -> die "Requires: R | {C, ProjectID, TaskID, and description}"
