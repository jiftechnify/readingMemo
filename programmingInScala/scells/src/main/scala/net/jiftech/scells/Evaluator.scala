package net.jiftech.scells

import scala.collection.mutable

// 数式の評価に関係する処理
// 内部でModelを参照するため、自分型を指定している
trait Evaluator { this: Model =>
  // 数式を評価する
  def evaluate(e: Formula): Double = try {
    e match {
      case Coord(row, column) => cells(row)(column).value
      case Number(v) => v
      case Textual(_) => 0
      case Application(f, args) =>
        val argvals = args.flatMap(evalList)
        operations(f)(argvals)
    }
  }
  catch {
    case ex: Exception => { println(ex); Double.NaN }
  }

  // SCellsの演算子は、数値のリストをとって数値を返す関数
  type Op = List[Double] => Double
  val operations = new mutable.HashMap[String, Op]

  private def evalList(e: Formula): List[Double] = e match {
    case Range(_, _) => references(e).map(_.value)
    case _ => List(evaluate(e))
  }

  // 与えられた数式が参照しているセルのリストを取得する
  def references(e: Formula): List[Cell] = e match {
    case Coord(row, column) => List(cells(row)(column))
    case Range(Coord(r1, c1), Coord(r2, c2)) =>
      for(row <- (r1 to r2).toList; col <- (c1 to c2))
      yield cells(row)(col)
    case Application(f, args) =>
      args.flatMap(references)
    case _ => List()
  }
}
