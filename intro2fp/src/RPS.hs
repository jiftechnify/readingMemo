module RPS where

pair :: (a -> b, a -> c) -> a -> (b, c)
pair (f, g) x = (f x, g x)

data Move = Rock | Paper | Scissors
            deriving (Show)
type Round = (Move, Move)

-- 勝った方に1点
score :: Round -> (Int, Int)
score (x, y)
    | x `beats` y = (1, 0)
    | y `beats` x = (0, 1)
    | otherwise   = (0, 0)

-- 勝利判定
beats :: Move -> Move -> Bool
x `beats` y = (m + 1 == n) || (m == n + 2)
              where m = code x; n = code y

code :: Move -> Int
code Paper    = 0
code Rock     = 1
code Scissors = 2

-- n回対戦し、お互いの点を計算する
match :: Int -> (Strategy, Strategy) -> (Int, Int)
match n = total . map score . take n . rounds

-- 各対戦における点数を合計する
total :: [(Int, Int)] -> (Int, Int)
total = pair (sum . map fst, sum . map snd)

-- 「戦略」の実装1
-- 相手がこれまでに出した手のリストから、次に出す手を決める関数
-- extendにΩ(n)の時間がかかり、効率的でない
-- type Strategy = [Move] -> Move
--
-- rounds :: (Strategy, Strategy) -> [Round]
-- rounds (f, g) = (map last . tail . iterate (extend (f, g))) []
--
-- extend :: (Strategy, Strategy) -> [Round] -> [Round]
-- extend (f, g) rs = rs ++ [(f (map snd rs), g (map fst rs))]

-- 戦略の実装
-- 常に相手が直前に出した手を出す「仕返し(reciprocate)」
-- recip :: Strategy
-- recip ms = if null ms then Rock else last ms
--
-- -- これまでに相手が出した手を数えて、確率的に最適な手を出す「こしゃくな(smart)」戦略
-- smart :: Strategy
-- smart ms = if null ms then Rock else choose (count ms)
--
-- count :: [Move] -> (Int, Int, Int)
-- count = foldl (<+>) (0, 0, 0)

(<+>) :: (Int, Int, Int) -> Move -> (Int, Int, Int)
(p, r, s) <+> Paper    = (p + 1, r, s)
(p, r, s) <+> Rock     = (p, r + 1, s)
(p, r, s) <+> Scissors = (p, r, s + 1)

choose :: (Int, Int, Int) -> Move
choose (p, r, s)
    | m < p     = Scissors
    | m < p + r = Paper
    | otherwise = Rock
      where m = rand (p + r + s)

-- 適当乱数実装
rand :: Int -> Int
rand x = randoms !! x `mod` x

randoms :: [Int]
randoms = iterate f 7
          where f x = (48271 * x) `mod` (2^32 - 1) `div` 2^16

-- 「戦略」の実装2
-- 相手の出す手の無限リストをとり、それに対応する自分の手の無限リストを生成する
-- roundsで最初のn手を計算する計算量はO(n)となる
type Strategy = [Move] -> [Move]

rounds (f, g) = zip xs ys
                where xs = police f ys; ys = police g xs

recipr ms = Rock : ms

smart xs = Rock : map choose (counts xs)
counts = tail . scanl (<+>) (0, 0, 0)

-- 2つ目の実装では、相手の手を「覗き見」できてしまう!
-- 相手の次の手を見てそれに勝つ手を出す戦略
-- 覗き見ができる戦略cheat以外にも存在する
cheat xs = map trumps xs

trumps :: Move -> Move
trumps Paper    = Scissors
trumps Rock     = Paper
trumps Scissors = Rock

-- きちんと定義された手を返さないという戦略もゲームを破壊する
dozy xs = repeat undefined

-- 戦略fが「公正である」とは、相手の最初のn手がきちんと定義されているなら、fはn+1手目までの手をきちんと定義するということ
-- fが公正で、xsがきちんと定義された手の無限列ならpolice f xs = f xsとなるような関数policeを定義できる
-- fが公正でなければ、policeは_|_を返す
police f xs = ys where ys = f (synch xs ys)

synch :: [Move] -> [Move] -> [Move]
synch (x : xs) (y : ys) =
    if defined y then x : synch xs ys else undefined

defined :: Move -> Bool
defined Paper = True
defined Rock  = True
defined Scissors = True
