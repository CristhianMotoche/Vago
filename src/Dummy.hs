module Dummy where

import System.Random (randomRIO)

dice :: IO Int
dice = randomRIO (1, 6)
