module Main where

import Config as C
import Harvest (listTasks)

main :: IO ()
main = do
  config <- C.readConfig
  tasks <- listTasks $ C.harvest config
  print tasks
