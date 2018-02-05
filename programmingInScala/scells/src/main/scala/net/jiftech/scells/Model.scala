package net.jiftech.scells

import scala.swing._

class Model(val height: Int, val width: Int) extends Evaluator with Arithmetic {
  // セルの値が更新されたときに発火するイベント
  case class ValueChanged(cell: Cell) extends event.Event

  // セルの内容(数式とそれを評価した値)を保持する
  case class Cell(row: Int, column: Int) extends Publisher {
    private var v: Double = 0
    def value: Double = v
    def value_=(w: Double) = {
      if(!(v == w || v.isNaN && w.isNaN)) {
        v = w
        // 自身の値が更新されたことを、参照元のセルに通知する
        publish(ValueChanged(this))
      }
    }

    private var f: Formula = Empty
    def formula: Formula = f
    def formula_=(f: Formula) = {
      // 新しい数式を代入し、イベント購読先を更新する
      for(c <- references(formula)) deafTo(c)
      this.f = f
      for(c <- references(formula)) listenTo(c)
      value = evaluate(f)
    }

    reactions += {
      // 参照先のセルが更新された際の処理(再計算)
      case ValueChanged(_) => value = evaluate(formula)
    }
    override def toString = formula match {
      case Textual(s) => s
      case _ => value.toString
    }
  }
  // 初期化
  val cells = Array.ofDim[Cell](height, width)
  for(i <- 0 until height; j <- 0 until width) {
    cells(i)(j) = new Cell(i, j)
  }
}
