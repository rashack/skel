#!/usr/bin/env runhaskell

module Main where

import Data.Maybe (fromJust)
import System.Environment
import Control.Applicative ((<|>))

main :: IO ()
main = do
  coli <- getCols
  putStr $ take coli spaceNs
  putStrLn ""
  putStrLn $ take coli $ cycle ['0'..'9']

spaceNs :: String
spaceNs = " " ++ (concat $ zipWith (++) (repeat $ replicate 9 ' ') $ drop 1 $ cycle $ (map show [0..9]))

getCols :: IO Int
getCols = do
  args <- getArgs
  let cols = case args of
        [n] -> Just n
        _   -> Nothing
  mEnv <- lookupEnv "COLUMNS"
  return $ read (fromJust $ cols <|> mEnv <|> Just "80")
