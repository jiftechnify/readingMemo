module C1
    ( square, delta
    ) where

main :: IO ()
main = return ()

square :: Float -> Float
square x = x * x

delta :: (Float, Float, Float) -> Float
delta (a, b, c) = sqrt (square b - 4 * a * c)

-- ex1.1
quad :: Float -> Float
quad = square.square

greater :: (Float, Float) -> Float
greater (x, y) = if x >= y then x else y

circleArea :: Float -> Float
circleArea r = square r * 22 / 7
