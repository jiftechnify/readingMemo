module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

square :: Integer -> Integer
square x = x * x

hoge :: IO ()
hoge = putStrLn "hoge"
