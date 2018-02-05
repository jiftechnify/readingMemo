package net.jiftech.scells

// 算術演算の定義
// Modelにミックスインして利用する
trait Arithmetic { this: Evaluator =>
  operations += (
    "add"  -> { case List(x, y) => x + y },
    "sub"  -> { case List(x, y) => x - y },
    "div"  -> { case List(x, y) => x / y },
    "mul"  -> { case List(x, y) => x * y },
    "mod"  -> { case List(x, y) => x % y },
    "sum"  -> { xs => xs.foldLeft(0.0)(_ + _) },
    "prod" -> { xs => xs.foldLeft(1.0)(_ * _) }
  )
}
