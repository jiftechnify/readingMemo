package net.jiftech.scells

// SCellsが扱う数式の定義
trait Formula
// 座標(ex: "A1")
case class Coord(row: Int, column: Int) extends Formula {
  override def toString = ('A' + column).toChar.toString + row
}
// 範囲(ex: "A1:B3")
case class Range(c1: Coord, c2: Coord) extends Formula {
  override def toString = c1.toString + ":" + c2.toString
}
// 数値
case class Number(value: Double) extends Formula {
  override def toString = value.toString
}
// テキスト
case class Textual(value: String) extends Formula {
  override def toString = value
}
// 関数適用(ex: "Sum(A1:A5)")
case class Application(function: String, arguments: List[Formula]) extends Formula {
  override def toString = function + arguments.mkString("(", ",", ")")
}
object Empty extends Textual("")
