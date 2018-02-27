module TextProcessing where

import Prelude hiding (lines, unlines, words, unwords,Word)

-- テキスト
type Text = [Char]
-- 行: 改行文字を含まないテキスト
type Line = [Char]
-- 語: 空白文字を含まないテキスト
type Word = [Char]

-- テキストを行のリストへ
lines :: Text -> [Line]
lines xs = if null zs then [ys] else ys : lines (tail zs)
           where (ys, zs) = span (/= '\n') xs

-- ただし、
-- span :: (a -> Bool) -> [a] -> ([a], [a])
-- span p xs = (takeWhile p xs, dropWhile p xs)

-- 行のリストをテキストへ
-- 各行に改行文字を挟み込みながら結合する
unlines :: [Line] -> Text
unlines = foldr1 (<+>)
          where xs <+> ys = xs ++ "\n" ++ ys

-- linesの一般化
-- 指定した要素でリストを分割
breakOn :: (Eq a) => a -> [a] -> [[a]]
breakOn x xs = if null zs then [xs] else ys : breakOn x (tail zs)
               where (ys, zs) = span (/= x) xs

-- unlinesの一般化
-- 指定した要素を挟み込みながら結合
joinWith :: a -> [[a]] -> [a]
joinWith x = foldr1 (<+>)
             where xs <+> ys = xs ++ [x] ++ ys

-- 任意のリストに対し、以下の等式が成り立つ
-- joinWith x (breakOn x xs) == xs


-- 行をスペースで分割して語のリストにする
-- 「空の語」は捨てる
words :: Line -> [Word]
words = filter (not . null) . breakOn ' '

-- 語のリストを行に戻す
unwords :: [Word] -> Line
unwords = joinWith ' '

-- テキスト中の語の数を数える
-- 行に分割->各行を語に分割->すべての語を1つのリストに->数える
wordcount :: Text -> Int
wordcount = length . concat . map words . lines

-- テキストを整形する(余分な空白を取り除く)
format1 :: Text -> Text
format1 = unlines . map formatLine . lines

-- 行ごとの整形処理
formatLine :: Line -> Line
formatLine = rebuild . words
             where rebuild ws = if null ws then [] else unwords ws


-- 以降、タブ位置は幅tごとに固定されているとする
t :: Int
t = 4

spaces :: Int -> [Char]
spaces x = replicate x ' '

-- フィールド: タブ文字を含まないテキスト
type Field = [Char]

-- 行をフィールドに分割する
fields :: Line -> [Field]
fields = breakOn '\t'

-- 1つのタブに足りない文だけスペースを補いながらフィールドを繋いで行にする
-- この実装はいちいち「行頭から」次のタブまでの文字数を計算するので効率が悪い
unfields :: [Field] -> Line
unfields = foldl1 (<+>)
           where xs <+> ys = xs ++ spaces (t - (length xs) `mod` t) ++ ys

-- ここまでの行の長さをタプルの第2要素に記録しつつ繋いでいくことで、効率を向上させたunfields
-- unfields = fst . expand
expand :: [Field] -> (Line, Int)
expand = foldl1 (<+>) . map addLength
         where addLength xs = (xs, length xs)
               (xs, m) <+> (ys, n) = (xs ++ spaces k ++ ys, m + k + n)
                                     where k = t - m `mod` t

-- テキストからタブ文字を取り除く
detab :: Text -> Text
detab = unlines . map detabLine . lines

-- 行ごとのタブ除去処理
detabLine :: Line -> Line
detabLine = unfields . fields
