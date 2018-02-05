package net.jiftech.scells
import scala.swing._
import scala.swing.event._

/**
 * スプレッドシートコンポーネント
 * @param height 行数
 * @param width  列数
 */
class Spreadsheet(val height: Int, val width: Int) extends ScrollPane {
  val cellModel = new Model(height, width)
  import cellModel._
  // 表の本体
  val table = new Table(height, width) {
    // 行の高さ
    rowHeight = 25
    // サイズの自動変更を無効化
    autoResizeMode = Table.AutoResizeMode.Off
    // グリッドの設定
    showGrid = true
    gridColor = new java.awt.Color(150, 150, 150)

    // 指定されたセルの入力内容を取得する
    def userData(row: Int, column: Int): String = {
      val v = this(row, column)
      if (v == null) "" else v.toString
    }
    // セルの表示内容を定義する。Tableクラスの定義をオーバーライド
    override def rendererComponent(isSelected: Boolean, hasFocus: Boolean, row: Int, column: Int): Component = {
      if (hasFocus) new TextField(userData(row, column))
      else new Label(cells(row)(column).toString) {
        xAlignment = Alignment.Right
      }
    }
    // 入力が変更された際の処理内容
    // 変更の影響を受けたセルを改めて解析する
    reactions += {
      case TableUpdated(table, rows, column) =>
        for(row <- rows) {
          cells(row)(column).formula = FormulaParsers.parse(userData(row, column))
        }
      case ValueChanged(cell) => updateCell(cell.row, cell.column)
    }

    for (row <- cells; cell <- row) listenTo(cell)
  }
  // 行ヘッダ
  val rowHeader =
    new ListView((0 until height) map (_.toString)) {
      // 幅と高さの設定
      fixedCellWidth = 30
      fixedCellHeight = table.rowHeight
    }
  viewportView = table
  rowHeaderView = rowHeader
}
