module Calendar
    ( year
    ) where

import Data.List hiding (group)

type Date = (Year, Month, Day)
type Day = Int
type Month = Int
type Year = Int
type Dayname = Int

-- 曜日を計算する部分
-- ある日付の曜日
day :: Date -> Dayname
day (y, m, d) = (fstday (y, m) + d - 1) `mod` 7

-- 指定した月の一日の曜日
fstday :: (Year, Month) -> Dayname
fstday (y, m) = fstdays y !! (m - 1)

-- 指定した年の各月の一日の曜日のリスト
fstdays :: Year -> [Dayname]
fstdays = take 12 . map (`mod` 7) . mtotals

-- 指定した年の各月一日が、その年で何日目か + 曜日オフセット
mtotals :: Year -> [Int]
mtotals y = scanl (+) (jan1 y) (mlengths y)

-- 各月の長さ
mlengths :: Year -> [Int]
mlengths y = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
             where feb = if leap y then 29 else 28

-- うるう年か?
leap :: Year -> Bool
leap y = if y `mod` 100 == 0
  then y `mod` 400 == 0
  else y `mod` 4 == 0

-- 指定した年の1月1日の曜日
-- 西暦1年1月1日を月曜日とする
jan1 :: Year -> Dayname
jan1 y = (365 * x + x `div` 4 - x `div` 100 + x `div` 400 + 1) `mod` 7
         where x = y - 1


-- 図形を組み立てるためのコンビネータ
type Picture = (Height, Width, [String])
type Height = Int
type Width = Int

height :: Picture -> Height
height (h, w, xss) = h

width :: Picture -> Width
width (h, w, xss) = w

-- 単一の文字を1 * 1の図形に変換する
pixel :: Char -> Picture
pixel c = (1, 1, [[c]])

-- above: ある図形の上に図形を重ねる
-- beside: ある図形の左隣に図形を置く
above, beside :: Picture -> Picture -> Picture
(h, w, xss) `above` (j, v, yss)
    | w == v    = (h + j, w, xss ++ yss)
    | otherwise = error "above: different widths"

(h, w, xss) `beside` (j, v, yss)
    | h == j    = (h, w + v, zipWith (++) xss yss)
    | otherwise = error "beside: different heights"

-- 複数の図形を上に重ねていく、横に並べていく
stack, spread :: [Picture] -> Picture
stack = foldr1 above
spread = foldr1 beside

-- 文字列を高さ1の図形にする
row :: String -> Picture
row = spread . map pixel

-- 指定された高さ・幅の空白の図形
blank :: (Height, Width) -> Picture
blank = stack . map row . blanks
        where blanks (h, w) = replicate h (replicate w ' ')

-- 指定した高さ(幅)の空白を挟みつつ重ねる(並べる)
stackWith :: Height -> [Picture] -> Picture
stackWith h = foldr1 (<+>)
              where p <+> q = p `above` (blank (h, width q) `above` q)

spreadWith :: Width -> [Picture] -> Picture
spreadWith w = foldr1 (<+>)
               where p <+> q = p `beside` (blank (height q, w) `beside` q)

-- 2次元の図形リストを敷き詰めて大きな1つの図形を組み立てる
tile :: [[Picture]] -> Picture
tile = stack . map spread

-- tileの、間の空白の高さと幅を指定できる版
tileWith :: (Height, Width) -> [[Picture]] -> Picture
tileWith (h, w) = stackWith h . map (spreadWith w)

-- 図形を表示する関数
showpic :: Picture -> String
showpic (h, w, xss) = unlines xss


-- カレンダーを図形として組み立てる
-- 1年分のカレンダー
year :: Year -> String
year = showpic . tileWith (1, 4) . group 3 . map picture . months

-- リストを、指定した数ずつの要素からなるリストに分割
group :: Int -> [a] -> [[a]]
group n xs = if null xs then [] else ys : group n zs
             where (ys, zs) = splitAt n xs

-- 各月のカレンダー情報(月名・年・一日の曜日・日数)のリスト
months :: Year -> [(String, Year, Dayname, Int)]
months y = zipp4 (mnames, replicate 12 y, fstdays y, mlengths y)

zipp4 :: ([a], [b], [c], [d]) -> [(a, b, c, d)]
zipp4 = uncurry4 zip4
        where uncurry4 f t4 = let (a, b, c, d) = t4 in f a b c d

mnames :: [String]
mnames = ["January", "February", "March",
          "April", "May", "June",
          "July", "August", "September",
          "October", "November", "December"]

-- 指定した月・年のカレンダーを表す図形
picture :: (String, Year, Dayname, Int) -> Picture
picture (m, y, d, s) = heading (m, y) `above` entries (d, s)

-- 指定した長さに合わせて右揃え
rjustify :: Int -> String -> String
rjustify n xs = spaces (n - length xs) ++ xs
                where spaces m = replicate m ' '

-- ヘッダ
heading (m, y) = banner (m, y) `above` dnames
banner (m, y) = row (rjustify 21 (m ++ " " ++ show y))
dnames = row " Su Mo Tu We Th Fr Sa"

-- 各月のカレンダー本体
entries = tile . group 7 . pix
pix (d, s) = map (row . rjustify 3 . pic) [1 - d .. 42 - d]
             where pic n = if 1 <= n && n <= s then show n else ""
