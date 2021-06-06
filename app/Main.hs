module Main where

import Dummy
import Config as C

main :: IO ()
main = do
  config <- readConfig
  print =<< dice
