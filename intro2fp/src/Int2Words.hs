module Int2Words (convert2, convert3, convert6) where

-- 数を言葉に変換する
-- パターンマッチと++,!!を活用している
convert2 :: Int -> String
convert2 = combine2 . digits2

digits2 :: Int -> (Int, Int)
digits2 n = (n `div` 10, n `mod` 10)

units, teens, tens :: [String]
units = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
teens = ["ten", "eleven", "tweleve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
tens = ["twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

combine2 :: (Int, Int) -> String
combine2 (0, u) = units !! (u - 1)
combine2 (1, u) = teens !! u
combine2 (t, 0) = tens !! (t - 2)
combine2 (t, u) = tens !! (t - 2) ++ "-" ++ units !! (u - 1)


convert3 :: Int -> String
convert3 = combine3 . digits3

-- 3桁の数値を百の位と残りに分ける
digits3 :: Int -> (Int, Int)
digits3 n = (n `div` 100, n `mod` 100)

combine3 :: (Int, Int) -> String
combine3 (0, t) = convert2 t
combine3 (h, 0) = units !! (h - 1) ++ " hundred"
combine3 (h, t) = units !! (h - 1) ++ " hundred and " ++ convert2 t


convert6 :: Int -> String
convert6 = combine6 . digits6

-- 6桁の数値を3桁ずつに分ける
digits6  :: Int -> (Int, Int)
digits6 n = (n `div` 1000, n `mod` 1000)

combine6 :: (Int, Int) -> String
combine6 (0, h) = convert3 h
combine6 (m, 0) = convert3 m ++ " thousand"
combine6 (m, h) = convert3 m ++ " thousand" ++ link h ++ convert3 h

link :: Int -> String
link h = if h < 100 then " and " else " "
