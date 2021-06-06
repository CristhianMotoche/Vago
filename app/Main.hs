module Main where

import Config as C

main :: IO ()
main = do
  config <- C.readConfig
  putStrLn "WIP..."
