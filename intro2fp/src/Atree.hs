module Atree where

data Atree a = Leaf a | Fork Int (Atree a) (Atree a) deriving (Show)

fork :: Atree a -> Atree a -> Atree a
fork xt yt = Fork (lsize xt) xt yt

lsize :: Atree a -> Int
lsize (Leaf x) = 1
lsize (Fork n xt yt) = n + lsize yt
