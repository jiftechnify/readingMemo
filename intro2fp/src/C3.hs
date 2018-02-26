module C3 where

import Prelude hiding (succ)

-- 自然数nとは、ある関数fをn回適用するということ
type Cnum a = (a -> a) -> a -> a
zero, one, two :: Cnum a
zero f = id
one  f = f
two  f = f . f

-- succ: fをcn回適用して、さらに1回適用する
succ :: Cnum a -> Cnum a
succ cn f = f . cn f

-- CnumとIntの間の相互変換
church :: Int -> Cnum Int
church = foldn succ zero

natural :: Cnum Int -> Int
natural cn = cn (+1) 0

-- cn + dn とは、fをdn回適用してからcn回適用すること
plus1 :: Cnum a -> Cnum a -> Cnum a
plus1 cn dn f = cn f . dn f

-- cn + dn とは、dnにsuccをcn回適用すること
plus2 :: Cnum (Cnum a) -> Cnum a -> Cnum a
plus2 cn = cn succ

-- 以下、同様に考えていく
times1 :: Cnum a -> Cnum a -> Cnum a
times1 cn dn = cn . dn

times2 :: Cnum (Cnum a) -> Cnum a -> Cnum (a -> a)
times2 cn = cn . plus1

-- arrow1 m n = n ^ m
arrow1 :: Cnum (Cnum a) -> Cnum a -> Cnum (a -> a)
arrow1 cn = cn . times1

arrow2 cn dn = cn dn
